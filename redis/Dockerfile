FROM redis:6-alpine

# No config file → redis binds all interfaces including IPv6 (required on
# Railway's private network). requirepass satisfies protected-mode.
# Intentionally ephemeral, matching upstream compose: a restart loses only
# queued celery tasks and cached sessions.
CMD ["sh", "-c", "redis-server --requirepass \"$REDIS_PASSWORD\""]
