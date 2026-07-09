-- ════════════════════════════════════════════════════════════════════════════════
-- V7: Avaliações Mútuas (Cliente ↔ Transportador)
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE ratings (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    freight_ride_id UUID        NOT NULL REFERENCES freight_rides(id),
    rater_id        UUID        NOT NULL REFERENCES users(id),
    rated_id        UUID        NOT NULL REFERENCES users(id),
    score           SMALLINT    NOT NULL,
    comment         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_ratings_score   CHECK (score BETWEEN 1 AND 5),
    CONSTRAINT chk_ratings_no_self CHECK (rater_id <> rated_id),
    -- Garante 1 avaliação por usuário por corrida
    CONSTRAINT uq_ratings_ride_rater UNIQUE (freight_ride_id, rater_id)
);

CREATE INDEX idx_ratings_rated_id ON ratings(rated_id);
CREATE INDEX idx_ratings_ride_id  ON ratings(freight_ride_id);
CREATE INDEX idx_ratings_rater_id ON ratings(rater_id);

COMMENT ON TABLE ratings IS 'Avaliações bidirecionals após conclusão de frete. Cliente avalia transportador e vice-versa.';
