# -------- Stage 1: build ----------
FROM eclipse-temurin:26-jdk AS build
WORKDIR /src

# copy build files first so Docker can cache dependency downloads
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew

COPY src src
RUN ./gradlew bootJar --no-daemon

# ---------- Stage 2: run ------------
FROM eclipse-temurin:26-jre
WORKDIR /app

# curl is needed for the container healthcheck later
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# never run as root \
RUN useradd --system --uid 1001 appuser

COPY --from=build /src/build/libs/*.jar app.jar
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]