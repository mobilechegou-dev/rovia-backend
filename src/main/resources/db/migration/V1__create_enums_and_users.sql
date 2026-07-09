-- ════════════════════════════════════════════════════════════════════════════════
-- V1: Enums e Tabela de Usuários
-- ════════════════════════════════════════════════════════════════════════════════

-- ─── ENUMS ────────────────────────────────────────────────────────────────────
CREATE TYPE user_role AS ENUM ('CLIENT', 'TRANSPORTER', 'ADMIN');
CREATE TYPE transporter_status AS ENUM ('PENDING', 'ACTIVE', 'BLOCKED');
CREATE TYPE vehicle_category AS ENUM ('MOTO', 'CARRO', 'UTILITARIO', 'VAN', 'CAMINHAO_PEQUENO', 'CAMINHAO_MUDANCA');
CREATE TYPE freight_status AS ENUM ('OPEN', 'MATCHED', 'IN_PROGRESS', 'DONE', 'CANCELLED');
CREATE TYPE ride_status AS ENUM ('WAITING', 'COMING', 'COLLECTED', 'IN_TRANSIT', 'DELIVERED', 'CANCELLED');
CREATE TYPE notification_type AS ENUM (
    'NEW_FREIGHT_REQUEST',
    'FREIGHT_ACCEPTED',
    'FREIGHT_REJECTED',
    'STATUS_UPDATED',
    'FREIGHT_DONE',
    'FREIGHT_CANCELLED',
    'SYSTEM'
);

-- ─── USERS ────────────────────────────────────────────────────────────────────
CREATE TABLE users (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    email         VARCHAR(255) UNIQUE,
    phone         VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          user_role   NOT NULL,
    is_active     BOOLEAN     NOT NULL DEFAULT TRUE,
    fcm_token     VARCHAR(512),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Ao menos um dos dois precisa estar preenchido
    CONSTRAINT chk_users_contact CHECK (
        email IS NOT NULL OR phone IS NOT NULL
    )
);

CREATE INDEX idx_users_email   ON users(email)   WHERE email IS NOT NULL;
CREATE INDEX idx_users_phone   ON users(phone)   WHERE phone IS NOT NULL;
CREATE INDEX idx_users_role    ON users(role);
CREATE INDEX idx_users_active  ON users(is_active) WHERE is_active = TRUE;

COMMENT ON TABLE  users IS 'Tabela base de usuários. Estendida por clients e transporters.';
COMMENT ON COLUMN users.fcm_token IS 'Token do Firebase Cloud Messaging para push notifications.';
