# ════════════════════════════════════════════════════════════════════════════════
# ROVIA API — Dockerfile Multi-Stage
# Stage 1: Build com Maven
# Stage 2: Runtime mínimo com JRE 21
# ════════════════════════════════════════════════════════════════════════════════

# ─── STAGE 1: BUILD ──────────────────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# 1. Copia somente o pom.xml para aproveitar cache do Docker (deps não mudam a cada build)
COPY pom.xml .

# 2. Baixa dependências sem compilar o código (cache de layer)
RUN mvn dependency:go-offline -B

# 3. Copia o código-fonte e compila
COPY src ./src
RUN mvn clean package -DskipTests -B

# ─── STAGE 2: RUNTIME ────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jre-alpine AS runtime

# Usuário não-root para segurança
RUN addgroup -S rovia && adduser -S rovia -G rovia

WORKDIR /app

# Copia o JAR compilado
COPY --from=builder /app/target/*.jar app.jar

# Diretório de logs
RUN mkdir -p /var/log/rovia && chown rovia:rovia /var/log/rovia

USER rovia

# Expõe a porta da aplicação
EXPOSE 8080

# JVM tuning para container
ENV JAVA_OPTS="\
  -Xms256m \
  -Xmx768m \
  -XX:+UseG1GC \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  -Djava.security.egd=file:/dev/./urandom \
  -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE:-prod}"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget -qO- http://localhost:8080/api/v1/health/ping || exit 1
