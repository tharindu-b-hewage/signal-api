# -------- Stage 1: build ----------
FROM eclipse-temurin:26-jdk@sha256:196a32e6591e431e049a90baffdb03921ea0e1d05ec56ccaee311463e6640c47 AS build
WORKDIR /src

# copy build files first so Docker can cache dependency downloads
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew

COPY src src
RUN ./gradlew bootJar --no-daemon

# ---------- Stage 2: run ------------
FROM eclipse-temurin:26-jre@sha256:104b5f371e2970cea995c01c3367ea7b0e3a4fa327c6aed51dda672b5e34d241
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