# -------- Stage 1: build ----------
FROM eclipse-temurin:26-jdk@sha256:c0fe66ea21e972724000cf402f8081c7841d960839f69cb0754f40b40f74b2cc AS build
WORKDIR /src

# copy build files first so Docker can cache dependency downloads
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew

COPY src src
RUN ./gradlew bootJar --no-daemon

# ---------- Stage 2: run ------------
FROM eclipse-temurin:26-jre@sha256:2b3c7b20375e9ac3ab6a7bc39357d3dbe2caf48378fe9e5c306a22da3499f170
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