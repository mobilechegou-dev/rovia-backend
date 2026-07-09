-- ════════════════════════════════════════════════════════════════════════════════
-- V6: Corridas de Frete (Frete Aceito por um Transportador)
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE freight_rides (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    freight_id      UUID        NOT NULL UNIQUE REFERENCES freights(id),
    transporter_id  UUID        NOT NULL REFERENCES transporters(id),
    vehicle_id      UUID        NOT NULL REFERENCES vehicles(id),
    status          ride_status NOT NULL DEFAULT 'WAITING',
    accepted_at     TIMESTAMPTZ,
    arrived_at      TIMESTAMPTZ,
    collected_at    TIMESTAMPTZ,
    delivered_at    TIMESTAMPTZ,
    cancelled_at    TIMESTAMPTZ,
    cancel_reason   TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rides_freight_id     ON freight_rides(freight_id);
CREATE INDEX idx_rides_transporter_id ON freight_rides(transporter_id);
CREATE INDEX idx_rides_status         ON freight_rides(status);
-- Consultar corridas ativas de um transportador
CREATE INDEX idx_rides_transporter_active
    ON freight_rides(transporter_id, status)
    WHERE status NOT IN ('DELIVERED', 'CANCELLED');

COMMENT ON TABLE  freight_rides IS 'Corrida criada quando um transportador aceita um frete.';
COMMENT ON COLUMN freight_rides.status IS 'Ciclo de vida: WAITING → COMING → COLLECTED → IN_TRANSIT → DELIVERED ou CANCELLED.';
