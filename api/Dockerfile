FROM langgenius/dify-api:1.18.0

# Railway private networking is IPv6-only; gunicorn accepts the bracketed
# form ([::]:5001 dual-stack). The entrypoint also exports HOST from this.
# RESPECT_XFORWARD_HEADERS_ENABLED: the gateway sends the visitor's address as
# the only X-Forwarded-For hop (1.18 trusts exactly one), so per-IP limits work.
ENV MODE=api \
    RESPECT_XFORWARD_HEADERS_ENABLED=true \
    DIFY_BIND_ADDRESS=[::] \
    DIFY_PORT=5001 \
    MIGRATION_ENABLED=true \
    DB_PORT=5432 \
    DB_USERNAME=dify \
    DB_DATABASE=dify \
    REDIS_PORT=6379 \
    VECTOR_STORE=pgvector \
    PGVECTOR_PORT=5432 \
    PGVECTOR_USER=dify \
    PGVECTOR_DATABASE=dify \
    STORAGE_TYPE=s3 \
    S3_ADDRESS_STYLE=virtual
