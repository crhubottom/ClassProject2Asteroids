# syntax=docker/dockerfile:1.6

#############################################
# Stage 1: Build the Asteroids project JAR #
#############################################
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy pom first to leverage Docker layer caching for dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source and build the shaded jar
COPY src ./src

# Run tests; skip them by passing --build-arg SKIP_TESTS=true
ARG SKIP_TESTS=false
RUN if [ "$SKIP_TESTS" = "true" ]; then \
        mvn -q package -DskipTests; \
    else \
        mvn -q test package; \
    fi

#########################################
# Stage 2: Prepare a slim runtime image #
#########################################
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Install minimal X11 libs for Swing/AWT rendering
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libxi6 \
        libxrender1 \
        libxtst6 \
        libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Copy build artifacts
COPY --from=builder /app/target/Asteroids-1.0-SNAPSHOT.jar ./Asteroids.jar

# Default runtime configuration
ENV JAVA_OPTS=""
ENV DISPLAY=host.docker.internal:0

CMD ["/bin/sh", "-c", "java $JAVA_OPTS -jar Asteroids.jar"]
