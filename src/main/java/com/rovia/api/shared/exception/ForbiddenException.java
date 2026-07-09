package com.rovia.api.shared.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Autenticado mas sem permissão para o recurso. Retorna HTTP 403 Forbidden.
 */
@ResponseStatus(HttpStatus.FORBIDDEN)
public class ForbiddenException extends RuntimeException {

    public ForbiddenException(String message) {
        super(message);
    }

    public static ForbiddenException insufficientPermissions() {
        return new ForbiddenException("Você não tem permissão para realizar esta ação");
    }
}
