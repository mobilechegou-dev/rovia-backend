package com.rovia.api.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Configuração do Swagger / OpenAPI 3.
 * Acesso: http://localhost:8080/swagger-ui.html
 */
@Configuration
public class SwaggerConfig {

    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    private static final String SECURITY_SCHEME_NAME = "bearerAuth";

    @Bean
    public OpenAPI roviaOpenAPI() {
        return new OpenAPI()
                .info(buildInfo())
                .servers(buildServers())
                .addSecurityItem(new SecurityRequirement().addList(SECURITY_SCHEME_NAME))
                .components(new Components()
                        .addSecuritySchemes(SECURITY_SCHEME_NAME, buildSecurityScheme())
                );
    }

    private Info buildInfo() {
        return new Info()
                .title("Rovia API")
                .description("""
                        **Rovia** — Plataforma de Mobilidade Logística Sob Demanda.
                        
                        Conecta clientes a transportadores autônomos em tempo real
                        para fretes, entregas e mudanças de qualquer porte.
                        
                        ### Autenticação
                        Utilize o endpoint `/api/v1/auth/login` para obter o Bearer token.
                        Clique em **Authorize** e insira: `Bearer {seu_token}`
                        """)
                .version("v1.0.0")
                .contact(new Contact()
                        .name("Rovia Engineering")
                        .email("tech@rovia.com.br")
                        .url("https://rovia.com.br"))
                .license(new License()
                        .name("Proprietary")
                        .url("https://rovia.com.br/terms"));
    }

    private List<Server> buildServers() {
        Server localServer = new Server()
                .url("http://localhost:8080")
                .description("Ambiente local (" + activeProfile + ")");

        Server stagingServer = new Server()
                .url("https://api-staging.rovia.com.br")
                .description("Homologação");

        return List.of(localServer, stagingServer);
    }

    private SecurityScheme buildSecurityScheme() {
        return new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .description("Insira o token JWT gerado pelo endpoint de login");
    }
}
