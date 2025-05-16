FROM golang:1.24 AS build
COPY . .
ENV GOPATH=""
ENV CGO_ENABLED=0
RUN go build -trimpath -a -ldflags="-w -s" ./cmd/web-api

FROM gcr.io/distroless/static
COPY --from=build /go/web-api /web-api
ENTRYPOINT ["/web-api"]
