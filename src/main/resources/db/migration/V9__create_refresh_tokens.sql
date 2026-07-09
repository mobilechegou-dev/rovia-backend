-- ════════════════════════════════════════════════════════════════════════════════
-- V9: Refresh Tokens (Rotação Segura)
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE refresh_tokens (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    -- Armazena hash SHA-256 do token, nunca o token raw
    token_hash  VARCHAR(512) NOT NULL UNIQUE,
    expires_at  TIMESTAMPTZ  NOT NULL,
    revoked     BOOLEAN      NOT NULL DEFAULT FALSE,
    revoked_at  TIMESTAMPTZ,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_refresh_tokens_user_id   ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_hash      ON refresh_tokens(token_hash);
-- Tokens válidos: não revogados e não expirados
CREATE INDEX idx_refresh_tokens_valid
    ON refresh_tokens(user_id, expires_at)
    WHERE revoked = FALSE;

COMMENT ON TABLE  refresh_tokens IS 'Refresh tokens com suporte a rotação e revogação. O token raw nunca é armazenado.';
COMMENT ON COLUMN refresh_tokens.token_hash IS 'Hash SHA-256 do refresh token. Token raw transmitido apenas ao cliente.';
