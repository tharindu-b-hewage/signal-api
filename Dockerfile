# -------- Stage 1: build ----------
FROM eclipse-temurin:27-jdk@sha256:2771efbbc159b89dc38b82ebe01312fd1b5f226071ff715ca9edd5411a389761 AS build
WORKDIR /src

# copy build files first so Docker can cache dependency downloads
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew

COPY src src
RUN ./gradlew bootJar --no-daemon

# ---------- Stage 2: run ------------
FROM eclipse-temurin:27-jre@sha256:387922dd341a11a06f39375e6b13f3cb865e09aa409789cd4f7a5a6577cd2290
WORKDIR /app

# curl is needed for the container healthcheck later
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /usr/bin/pebble

# never run as root \
RUN useradd --system --uid 1001 appuser

COPY --from=build /src/build/libs/*.jar app.jar
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]