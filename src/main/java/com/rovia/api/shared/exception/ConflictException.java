package com.rovia.api.shared.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Conflito de dados (ex: e-mail já cadastrado). Retorna HTTP 409 Conflict.
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ConflictException extends RuntimeException {

    public ConflictException(String message) {
        super(message);
    }

    public static ConflictException emailAlreadyExists() {
        return new ConflictException("E-mail já cadastrado");
    }

    public static ConflictException phoneAlreadyExists() {
        return new ConflictException("Telefone já cadastrado");
    }
}
