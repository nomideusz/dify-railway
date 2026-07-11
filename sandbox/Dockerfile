# Isolated code-execution service for workflow Code nodes. Go/Gin listens
# on :8194 (dual-stack, IPv6-fine). Outbound traffic is forced through the
# ssrf-proxy service via HTTP(S)_PROXY set in the template composer.
FROM langgenius/dify-sandbox:0.2.15

ENV GIN_MODE=release \
    WORKER_TIMEOUT=15 \
    ENABLE_NETWORK=true \
    SANDBOX_PORT=8194
