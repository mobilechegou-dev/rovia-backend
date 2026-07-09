package com.rovia.api.shared.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Resposta de erro estruturada.
 * Retornada pelo GlobalExceptionHandler em todos os casos de erro.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ErrorResponse(

        boolean success,
        int status,
        String error,
        String message,
        String path,
        LocalDateTime timestamp,
        List<FieldError> errors

) {
    /**
     * Erro de campo específico (ex: validação de formulário).
     */
    public record FieldError(String field, String message) {}

    public static ErrorResponse of(int status, String error, String message, String path) {
        return new ErrorResponse(false, status, error, message, path, LocalDateTime.now(), null);
    }

    public static ErrorResponse withFields(int status, String error, String message, String path,
                                           List<FieldError> errors) {
        return new ErrorResponse(false, status, error, message, path, LocalDateTime.now(), errors);
    }
}
