# Runs marketplace plugins as subprocesses; installed plugin virtualenvs
# live on a Railway volume at /app/storage so reinstalls survive redeploys.
FROM langgenius/dify-plugin-daemon:0.6.3-local

ENV SERVER_PORT=5002 \
    PLUGIN_REMOTE_INSTALLING_HOST=0.0.0.0 \
    PLUGIN_REMOTE_INSTALLING_PORT=5003 \
    PLUGIN_WORKING_PATH=/app/storage/cwd \
    PLUGIN_STORAGE_TYPE=local \
    PLUGIN_STORAGE_LOCAL_ROOT=/app/storage \
    PLUGIN_INSTALLED_PATH=plugin \
    PLUGIN_PACKAGE_CACHE_PATH=plugin_packages \
    PLUGIN_MEDIA_CACHE_PATH=assets \
    FORCE_VERIFYING_SIGNATURE=true \
    DB_SSL_MODE=disable \
    DB_PORT=5432 \
    DB_USERNAME=dify \
    DB_DATABASE=dify_plugin \
    REDIS_PORT=6379
