-- ════════════════════════════════════════════════════════════════════════════════
-- V3: Tabela de Transportadores Parceiros
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE transporters (
    id              UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID              NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(255)      NOT NULL,
    cpf             VARCHAR(14)       UNIQUE NOT NULL,
    cnh             VARCHAR(20),
    profile_photo   VARCHAR(512),
    status          transporter_status NOT NULL DEFAULT 'PENDING',
    rating_avg      DECIMAL(3, 2)     NOT NULL DEFAULT 0.00,
    total_ratings   INTEGER           NOT NULL DEFAULT 0,
    is_online       BOOLEAN           NOT NULL DEFAULT FALSE,
    current_lat     DECIMAL(10, 8),
    current_lng     DECIMAL(11, 8),
    online_at       TIMESTAMPTZ,
    created_at      TIMESTAMPTZ       NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ       NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_transporters_rating CHECK (rating_avg BETWEEN 0 AND 5),
    CONSTRAINT chk_transporters_ratings_count CHECK (total_ratings >= 0)
);

CREATE INDEX idx_transporters_user_id  ON transporters(user_id);
CREATE INDEX idx_transporters_status   ON transporters(status);
-- Índice parcial: somente transportadores online e ativos são consultados para matching
CREATE INDEX idx_transporters_online_active
    ON transporters(current_lat, current_lng, status)
    WHERE is_online = TRUE AND status = 'ACTIVE';

COMMENT ON TABLE  transporters IS 'Perfil estendido de parceiros transportadores.';
COMMENT ON COLUMN transporters.status IS 'PENDING=aguardando aprovação, ACTIVE=aprovado, BLOCKED=bloqueado.';
COMMENT ON COLUMN transporters.is_online IS 'TRUE quando o parceiro está disponível para receber chamados.';
COMMENT ON COLUMN transporters.current_lat IS 'Latitude atualizada periodicamente quando online.';
COMMENT ON COLUMN transporters.current_lng IS 'Longitude atualizada periodicamente quando online.';
