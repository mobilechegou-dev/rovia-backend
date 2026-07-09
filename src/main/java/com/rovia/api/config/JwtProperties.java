package com.rovia.api.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.annotation.Validated;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

@Getter
@Setter
@Validated
@Configuration
@ConfigurationProperties(prefix = "rovia.jwt")
public class JwtProperties {

    /**
     * Chave secreta Base64 para assinar os tokens JWT.
     * Deve ter no mínimo 256 bits (32 bytes codificados em Base64).
     * Gerar com: openssl rand -base64 32
     */
    @NotBlank(message = "JWT secret não pode ser vazio")
    private String secret;

    /**
     * Expiração do Access Token em segundos. Padrão: 3600 (1 hora).
     */
    @Min(value = 300, message = "Access token deve durar no mínimo 5 minutos")
    private long accessTokenExpiration = 3600;

    /**
     * Expiração do Refresh Token em segundos. Padrão: 2592000 (30 dias).
     */
    @Min(value = 86400, message = "Refresh token deve durar no mínimo 1 dia")
    private long refreshTokenExpiration = 2592000;
}
