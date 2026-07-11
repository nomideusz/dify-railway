# pgvector image serves triple duty: Dify's main DB, its vector store
# (VECTOR_STORE=pgvector — no separate Weaviate service), and the plugin
# daemon's DB (dify_plugin, created by the init script).
FROM pgvector/pgvector:pg16

# PGDATA one level below the mount: Railway volumes arrive with lost+found,
# which initdb refuses to initialize into.
ENV POSTGRES_USER=dify \
    POSTGRES_DB=dify \
    PGDATA=/var/lib/postgresql/data/pgdata

COPY init-dify.sh /docker-entrypoint-initdb.d/init-dify.sh
