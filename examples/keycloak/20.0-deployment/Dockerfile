FROM quay.io/keycloak/keycloak:20.0 AS builder
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH="/auth"
WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:20.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
