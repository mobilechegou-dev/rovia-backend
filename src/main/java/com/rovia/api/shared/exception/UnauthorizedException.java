package com.rovia.api.shared.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Não autenticado ou token inválido. Retorna HTTP 401 Unauthorized.
 */
@ResponseStatus(HttpStatus.UNAUTHORIZED)
public class UnauthorizedException extends RuntimeException {

    public UnauthorizedException(String message) {
        super(message);
    }

    public static UnauthorizedException invalidToken() {
        return new UnauthorizedException("Token inválido ou expirado");
    }

    public static UnauthorizedException credentialsInvalid() {
        return new UnauthorizedException("E-mail/telefone ou senha incorretos");
    }
}
