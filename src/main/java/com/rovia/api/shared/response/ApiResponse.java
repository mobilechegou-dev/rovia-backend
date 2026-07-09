package com.rovia.api.shared.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;

/**
 * Wrapper padrão para todas as respostas da API.
 *
 * Garante consistência no formato:
 * { "success": true, "message": "...", "data": {...} }
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(description = "Resposta padrão da API")
public record ApiResponse<T>(

        @Schema(description = "Indica se a operação foi bem-sucedida")
        boolean success,

        @Schema(description = "Mensagem descritiva")
        String message,

        @Schema(description = "Dados retornados pela operação")
        T data,

        @Schema(description = "Timestamp da resposta")
        LocalDateTime timestamp

) {
    // ─── Factory methods ──────────────────────────────────────────────────────

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(true, "Operação realizada com sucesso", data, LocalDateTime.now());
    }

    public static <T> ApiResponse<T> ok(String message, T data) {
        return new ApiResponse<>(true, message, data, LocalDateTime.now());
    }

    public static <T> ApiResponse<T> created(T data) {
        return new ApiResponse<>(true, "Recurso criado com sucesso", data, LocalDateTime.now());
    }

    public static <T> ApiResponse<T> created(String message, T data) {
        return new ApiResponse<>(true, message, data, LocalDateTime.now());
    }

    public static ApiResponse<Void> noContent(String message) {
        return new ApiResponse<>(true, message, null, LocalDateTime.now());
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null, LocalDateTime.now());
    }
}
