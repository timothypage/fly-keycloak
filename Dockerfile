FROM quay.io/keycloak/keycloak:22.0.3 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_PROXY=edge

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:22.0.3
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# from https://community.fly.io/t/run-keycloak-with-fly/5454/4
ENV JAVA_OPTS_APPEND="-Djava.net.preferIPv4Stack=false"

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
