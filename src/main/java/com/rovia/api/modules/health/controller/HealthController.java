package com.rovia.api.modules.health.controller;

import com.rovia.api.shared.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Health check customizado da aplicação.
 * Verifica conectividade com PostgreSQL e Redis.
 *
 * Utilizado por load balancers e sistemas de monitoramento.
 * Endpoint público: não requer autenticação.
 */
@RestController
@RequestMapping("/api/v1/health")
@RequiredArgsConstructor
@Tag(name = "Health", description = "Status e saúde da aplicação")
public class HealthController {

    private final JdbcTemplate jdbcTemplate;
    private final RedisTemplate<String, Object> redisTemplate;

    @GetMapping
    @Operation(summary = "Status geral da aplicação", description = "Retorna status dos serviços críticos: banco de dados e cache")
    public ResponseEntity<ApiResponse<Map<String, Object>>> health() {
        Map<String, Object> status = new LinkedHashMap<>();
        status.put("application", "UP");
        status.put("timestamp", LocalDateTime.now());
        status.put("version", "1.0.0");

        boolean dbOk    = checkDatabase(status);
        boolean redisOk = checkRedis(status);

        String overallStatus = (dbOk && redisOk) ? "UP" : "DEGRADED";
        status.put("status", overallStatus);

        if ("UP".equals(overallStatus)) {
            return ResponseEntity.ok(ApiResponse.ok("Todos os serviços operacionais", status));
        } else {
            return ResponseEntity.status(503).body(ApiResponse.error("Serviço degradado"));
        }
    }

    @GetMapping("/ping")
    @Operation(summary = "Ping simples", description = "Retorna pong. Ideal para health check de load balancer.")
    public ResponseEntity<ApiResponse<String>> ping() {
        return ResponseEntity.ok(ApiResponse.ok("pong"));
    }

    // ─── Verificações internas ────────────────────────────────────────────────

    private boolean checkDatabase(Map<String, Object> status) {
        try {
            jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            status.put("database", Map.of("status", "UP", "type", "PostgreSQL"));
            return true;
        } catch (Exception e) {
            status.put("database", Map.of("status", "DOWN", "error", e.getMessage()));
            return false;
        }
    }

    private boolean checkRedis(Map<String, Object> status) {
        try {
            String pong = (String) redisTemplate.getConnectionFactory()
                    .getConnection()
                    .ping();
            status.put("cache", Map.of("status", "UP", "type", "Redis", "response", pong));
            return true;
        } catch (Exception e) {
            status.put("cache", Map.of("status", "DOWN", "error", e.getMessage()));
            return false;
        }
    }
}
