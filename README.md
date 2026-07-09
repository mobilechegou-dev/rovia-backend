# 🚛 Rovia API

> Plataforma de Mobilidade Logística Sob Demanda — Back-end REST API

---

## Stack

| Tecnologia | Versão | Função |
|---|---|---|
| Java | 21 (LTS) | Linguagem |
| Spring Boot | 3.3.x | Framework |
| Spring Security | 6.x | Autenticação/Autorização |
| PostgreSQL | 16 | Banco de dados |
| Redis | 7 | Cache e dados temporários |
| Flyway | 10.x | Migrations |
| JWT (jjwt) | 0.12.6 | Tokens de autenticação |
| Docker | 24+ | Containerização |
| Swagger/OpenAPI | 3 | Documentação da API |

---

## Pré-requisitos

- Java 21+
- Maven 3.9+
- Docker + Docker Compose

---

## Setup Rápido

### 1. Clone e configure o ambiente

```bash
git clone https://github.com/rovia/rovia-backend.git
cd rovia-backend

# Copie e configure as variáveis de ambiente
cp .env.example .env
```

### 2. Edite o `.env`

O campo mais importante é o `JWT_SECRET`. Gere um seguro:

```bash
openssl rand -base64 32
# Cole o resultado no JWT_SECRET do .env
```

### 3. Suba os serviços de infraestrutura

```bash
# PostgreSQL + Redis
docker compose -f docker/docker-compose.yml up -d

# Com pgAdmin + Redis Commander (ferramentas visuais)
docker compose -f docker/docker-compose.yml --profile tools up -d
```

### 4. Verifique os serviços

```bash
docker compose -f docker/docker-compose.yml ps
# postgres: healthy | redis: healthy
```

### 5. Rode a aplicação

```bash
./mvnw spring-boot:run
# ou
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

A API estará disponível em: `http://localhost:8080`

---

## URLs Importantes

| Recurso | URL |
|---|---|
| Swagger UI | http://localhost:8080/swagger-ui.html |
| OpenAPI JSON | http://localhost:8080/v3/api-docs |
| Health Check | http://localhost:8080/api/v1/health |
| Ping | http://localhost:8080/api/v1/health/ping |
| Actuator | http://localhost:8080/actuator/health |
| pgAdmin | http://localhost:5050 |
| Redis Commander | http://localhost:8081 |

---

## Estrutura do Projeto

```
rovia-backend/
├── src/main/java/com/rovia/api/
│   ├── RoviaApplication.java          # Entry point
│   ├── config/                        # Configurações globais
│   │   ├── SecurityConfig.java        # Spring Security + JWT
│   │   ├── JwtProperties.java         # Properties JWT
│   │   ├── CorsConfig.java            # CORS
│   │   ├── RedisConfig.java           # Cache Redis
│   │   └── SwaggerConfig.java         # OpenAPI
│   ├── infrastructure/
│   │   └── security/
│   │       ├── JwtProvider.java       # Geração/validação JWT
│   │       └── JwtAuthFilter.java     # Filtro por requisição
│   ├── modules/                       # Módulos de negócio (Fase 1+)
│   │   └── health/
│   └── shared/
│       ├── exception/                 # Exceções + Handler global
│       ├── response/                  # ApiResponse, ErrorResponse, PageResponse
│       └── audit/                     # AuditableEntity
├── src/main/resources/
│   ├── application.yml                # Config principal
│   ├── application-dev.yml            # Override dev
│   ├── application-prod.yml           # Override prod
│   └── db/migration/                  # Flyway migrations
│       ├── V1__create_enums_and_users.sql
│       ├── V2__create_clients.sql
│       ├── V3__create_transporters.sql
│       ├── V4__create_vehicles.sql
│       ├── V5__create_freights.sql
│       ├── V6__create_freight_rides.sql
│       ├── V7__create_ratings.sql
│       ├── V8__create_notifications.sql
│       └── V9__create_refresh_tokens.sql
├── docker/
│   ├── Dockerfile                     # Multi-stage build
│   ├── docker-compose.yml             # Dev (PostgreSQL + Redis)
│   └── docker-compose.prod.yml        # Produção
├── .github/workflows/ci.yml           # GitHub Actions
├── .env.example                       # Template de variáveis
└── pom.xml
```

---

## Segurança

### Autenticação
- JWT com assinatura HMAC-SHA256
- Access Token: 1 hora de validade
- Refresh Token: 30 dias, armazenado como hash SHA-256
- Refresh Token Rotation na Fase 1

### Senhas
- BCrypt com fator de custo 12
- Nunca armazenadas ou logadas em plain text

### API
- Endpoints protegidos por role via `@PreAuthorize`
- CSRF desabilitado (API stateless)
- Sem sessão HTTP (SessionCreationPolicy.STATELESS)
- Sem exposição de stack traces nos erros

---

## Migrations (Flyway)

As migrations são executadas automaticamente ao iniciar a aplicação.
Para criar uma nova migration:

```
src/main/resources/db/migration/V{NUMERO}__{descricao_com_underline}.sql
```

**Regra:** Uma migration commitada NUNCA pode ser alterada.
Se precisar corrigir, crie uma nova migration.

---

## Variáveis de Ambiente

| Variável | Obrigatória | Descrição |
|---|---|---|
| `JWT_SECRET` | ✅ | Base64 de 32+ bytes. Gere: `openssl rand -base64 32` |
| `DB_HOST` | ✅ | Host do PostgreSQL |
| `DB_NAME` | ✅ | Nome do banco |
| `DB_USER` | ✅ | Usuário do banco |
| `DB_PASSWORD` | ✅ | Senha do banco |
| `REDIS_HOST` | ✅ | Host do Redis |
| `REDIS_PASSWORD` | ✅ | Senha do Redis |
| `SPRING_PROFILES_ACTIVE` | ⚠️ | `dev` ou `prod` |
| `LOG_LEVEL` | ⚠️ | `DEBUG`, `INFO`, `WARN` |

---

## Build para Produção

```bash
# Build da imagem Docker
docker build -f docker/Dockerfile -t rovia/api:1.0.0 .

# Deploy completo (API + PostgreSQL + Redis)
docker compose -f docker/docker-compose.prod.yml up -d
```

---

## Roadmap

| Fase | Status | Conteúdo |
|---|---|---|
| **Fase 0** | ✅ Concluída | Setup, infraestrutura, segurança base |
| **Fase 1** | 🔜 Próxima | Auth (login, cadastro, JWT, refresh token) |
| **Fase 2** | ⏳ | Perfis, veículos, upload de fotos |
| **Fase 3** | ⏳ | Fretes, geolocalização, matching |
| **Fase 4** | ⏳ | Tracking de status, corridas |
| **Fase 5** | ⏳ | Push notifications (Firebase) |
| **Fase 6** | ⏳ | Avaliações e histórico |
| **Fase 7** | ⏳ | Painel administrativo |
| **Fase 8** | ⏳ | Testes, deploy, QA |

---

## Licença

Proprietário — © 2025 Rovia. Todos os direitos reservados.
