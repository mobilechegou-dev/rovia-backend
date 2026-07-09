-- ════════════════════════════════════════════════════════════════════════════════
-- V5: Solicitações de Frete
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE freights (
    id                      UUID             PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id               UUID             NOT NULL REFERENCES clients(id),
    pickup_address          VARCHAR(512)     NOT NULL,
    pickup_lat              DECIMAL(10, 8)   NOT NULL,
    pickup_lng              DECIMAL(11, 8)   NOT NULL,
    delivery_address        VARCHAR(512)     NOT NULL,
    delivery_lat            DECIMAL(10, 8)   NOT NULL,
    delivery_lng            DECIMAL(11, 8)   NOT NULL,
    description             TEXT             NOT NULL,
    vehicle_category        vehicle_category NOT NULL,
    cargo_photos            JSONB            NOT NULL DEFAULT '[]',
    observations            TEXT,
    status                  freight_status   NOT NULL DEFAULT 'OPEN',
    estimated_distance_km   DECIMAL(10, 2),
    created_at              TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_freights_client_id        ON freights(client_id);
CREATE INDEX idx_freights_status           ON freights(status);
CREATE INDEX idx_freights_vehicle_category ON freights(vehicle_category);
CREATE INDEX idx_freights_created_at       ON freights(created_at DESC);
-- Índice composto para busca de fretes abertos por categoria (matching engine)
CREATE INDEX idx_freights_open_by_category
    ON freights(vehicle_category, created_at DESC)
    WHERE status = 'OPEN';

COMMENT ON TABLE  freights IS 'Solicitações de frete criadas pelos clientes.';
COMMENT ON COLUMN freights.cargo_photos IS 'Array JSON de URLs das fotos da carga uploadadas no S3.';
COMMENT ON COLUMN freights.status IS 'OPEN=aguardando transportador, MATCHED=transportador alocado, IN_PROGRESS=em execução, DONE=concluído, CANCELLED=cancelado.';
