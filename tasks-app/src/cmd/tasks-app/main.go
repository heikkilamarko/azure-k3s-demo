package main

import (
	"database/sql"
	"encoding/json"
	"log/slog"
	"net/http"
	"os"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type Task struct {
	ID        int64  `json:"id"`
	Name      string `json:"name"`
	CreatedAt string `json:"created_at"`
}

func getTasksHandler(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		slog.Info("get tasks", "method", r.Method, "url", r.URL.String())

		rows, err := db.QueryContext(r.Context(), "SELECT id, name, created_at FROM tasks_app.task")
		if err != nil {
			slog.Error("failed to query tasks", "error", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		tasks := []Task{}
		for rows.Next() {
			var t Task
			if err := rows.Scan(&t.ID, &t.Name, &t.CreatedAt); err != nil {
				slog.Error("failed to scan task row", "error", err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			tasks = append(tasks, t)
		}

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(tasks); err != nil {
			slog.Error("failed to encode response", "error", err)
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}

func main() {
	slog.SetDefault(slog.New(slog.NewJSONHandler(os.Stdout, nil)))

	dbConnectionString := os.Getenv("DB_CONNECTION_STRING")
	if dbConnectionString == "" {
		slog.Error("database connection string not set")
		os.Exit(1)
	}

	db, err := sql.Open("pgx", dbConnectionString)
	if err != nil {
		slog.Error("failed to connect to database", "error", err)
		os.Exit(1)
	}
	defer db.Close()

	mux := http.NewServeMux()
	mux.Handle("GET /tasks", getTasksHandler(db))

	slog.Info("starting server on port 8080")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		slog.Error("server failed", "error", err)
		os.Exit(1)
	}
}
