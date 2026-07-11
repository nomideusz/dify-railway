FROM langgenius/dify-api:1.15.0

# Celery beat: schedules periodic tasks (dataset cleanup, trace syncing).
# Tiny footprint — one process, no queue consumption.
ENV MODE=beat \
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
