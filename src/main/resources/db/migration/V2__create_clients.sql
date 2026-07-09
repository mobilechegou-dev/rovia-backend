-- ════════════════════════════════════════════════════════════════════════════════
-- V2: Tabela de Clientes
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE clients (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID        NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(255) NOT NULL,
    cpf             VARCHAR(14) UNIQUE,
    profile_photo   VARCHAR(512),
    address_base    VARCHAR(512),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_clients_user_id ON clients(user_id);

COMMENT ON TABLE clients IS 'Perfil estendido de clientes (pessoas físicas, empresas, e-commerces).';
