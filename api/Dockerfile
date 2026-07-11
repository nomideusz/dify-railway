FROM langgenius/dify-api:1.15.0

# Railway private networking is IPv6-only; gunicorn accepts the bracketed
# form ([::]:5001 dual-stack). The entrypoint also exports HOST from this.
ENV MODE=api \
    DIFY_BIND_ADDRESS=[::] \
    DIFY_PORT=5001 \
    MIGRATION_ENABLED=true
