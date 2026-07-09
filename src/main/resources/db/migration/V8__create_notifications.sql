-- ════════════════════════════════════════════════════════════════════════════════
-- V8: Notificações In-App
-- ════════════════════════════════════════════════════════════════════════════════

CREATE TABLE notifications (
    id          UUID              PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID              NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(255)      NOT NULL,
    body        TEXT              NOT NULL,
    type        notification_type NOT NULL,
    payload     JSONB             NOT NULL DEFAULT '{}',
    is_read     BOOLEAN           NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_created ON notifications(user_id, created_at DESC);
-- Índice parcial para busca de não lidas (query mais comum)
CREATE INDEX idx_notifications_unread
    ON notifications(user_id, created_at DESC)
    WHERE is_read = FALSE;

COMMENT ON TABLE  notifications IS 'Notificações persistidas in-app. Push via Firebase é complementar.';
COMMENT ON COLUMN notifications.payload IS 'Dados extras (ex: freight_id, ride_id) para deep link no app.';
