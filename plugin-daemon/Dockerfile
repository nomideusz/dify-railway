# Runs marketplace plugins as subprocesses; installed plugin virtualenvs
# live on a Railway volume at /app/storage so reinstalls survive redeploys.
FROM langgenius/dify-plugin-daemon:0.6.3-local

ENV SERVER_PORT=5002 \
    PLUGIN_WORKING_PATH=/app/storage/cwd \
    PLUGIN_STORAGE_TYPE=local \
    PLUGIN_STORAGE_LOCAL_ROOT=/app/storage \
    PLUGIN_INSTALLED_PATH=plugin \
    PLUGIN_PACKAGE_CACHE_PATH=plugin_packages \
    PLUGIN_MEDIA_CACHE_PATH=assets \
    FORCE_VERIFYING_SIGNATURE=true \
    DB_SSL_MODE=disable
