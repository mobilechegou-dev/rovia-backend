-- ════════════════════════════════════════════════════════════════════════════════
-- V4: Tabela de Veículos dos Transportadores
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE vehicles (
    id              UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
    transporter_id  UUID             NOT NULL REFERENCES transporters(id) ON DELETE CASCADE,
    category        vehicle_category NOT NULL,
    plate           VARCHAR(10)      NOT NULL,
    model           VARCHAR(100)     NOT NULL,
    year            SMALLINT         NOT NULL,
    color           VARCHAR(50),
    is_active       BOOLEAN          NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ      NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_vehicles_year CHECK (year BETWEEN 1990 AND 2030),
    CONSTRAINT uq_vehicles_plate UNIQUE (plate)
);

CREATE INDEX idx_vehicles_transporter_id ON vehicles(transporter_id);
CREATE INDEX idx_vehicles_category       ON vehicles(category);

COMMENT ON TABLE vehicles IS 'Veículos cadastrados pelos transportadores. Um transportador pode ter vários.';
