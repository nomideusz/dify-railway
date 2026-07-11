# Deploy and Host Dify on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/rUfGyE?utm_medium=integration&utm_source=button&utm_campaign=dify)

[Dify](https://dify.ai/) is an open-source LLM app development platform: build AI workflows, agents, and RAG pipelines visually, connect any model provider (OpenAI, Anthropic, local models), publish them as chatbots or APIs, and observe everything — a self-hosted alternative to hosted agent builders.

## About Hosting Dify

Dify 1.15 is a genuinely multi-service stack — API, celery workers, a Next.js console, an isolated code-execution sandbox behind an SSRF proxy, and a plugin daemon for marketplace plugins. This template decomposes it into 10 Railway services wired over private networking, replacing the stock nginx compose ingress with a small gateway that replicates its routing (`/console/api`, `/api`, `/v1`, `/files` → API; `/e/` → plugin daemon; everything else → web). PostgreSQL runs the pgvector image and serves triple duty — main database, vector store (`VECTOR_STORE=pgvector`, so no separate Weaviate), and the plugin daemon's database — while user files go to a **Railway bucket over S3**. Every service binds IPv6 explicitly, since Railway private networking is IPv6-only (the footgun that breaks most naive multi-service templates). First boot runs migrations in about a minute; then open your gateway domain and create the admin account (first signup owns the instance).

## Common Use Cases

- Visual builder for AI workflows, agents, and RAG chatbots published as APIs or web apps
- Self-hosted alternative to hosted agent platforms — your prompts, datasets, and API keys stay on your infrastructure
- Team workspace for prototyping LLM apps across providers with built-in observability

## Dependencies for Dify Hosting

- All bundled: PostgreSQL 16 (pgvector), Redis, sandbox, SSRF proxy, and plugin daemon are provisioned by the template
- A Railway bucket for file storage (provisioned by the template)
- Bring your own model-provider API key (OpenAI, Anthropic, etc.) — configured inside Dify after signup

### Deployment Dependencies

- [Dify documentation](https://docs.dify.ai/)
- [Template source on GitHub](https://github.com/nomideusz/dify-railway)

### Implementation Details

**Your Dify URL is the `gateway` service's domain.** Open it, create the admin account at `/install`, then add a model provider under Settings.

Service map (10 services):

| Service | Image | Role |
|---|---|---|
| gateway | `nginx:alpine` | Public entry; replicates Dify's stock nginx routing |
| api | `langgenius/dify-api` (MODE=api) | Console + service API, runs migrations on boot |
| worker | `langgenius/dify-api` (MODE=worker) | Celery worker: datasets, workflows, mail |
| worker-beat | `langgenius/dify-api` (MODE=beat) | Celery scheduler for periodic tasks |
| web | `langgenius/dify-web` | Next.js console UI |
| postgres | `pgvector/pgvector:pg16` | Main DB + vector store + plugin DB, on a volume |
| redis | `redis:6-alpine` | Celery broker + cache (ephemeral, matching upstream) |
| sandbox | `langgenius/dify-sandbox` | Isolated execution for workflow Code nodes |
| ssrf-proxy | `ubuntu/squid` | Blocks sandbox egress to private networks |
| plugin-daemon | `langgenius/dify-plugin-daemon` | Marketplace plugins, venvs on a volume |

Variable wiring (lives in the template composer; documented here for maintenance):

- **Shared by api / worker / worker-beat**: `SECRET_KEY` (generated), `DB_USERNAME=dify`, `DB_PASSWORD` (ref postgres), `DB_HOST=${{postgres.RAILWAY_PRIVATE_DOMAIN}}`, `DB_PORT=5432`, `DB_DATABASE=dify`, `REDIS_HOST=${{redis.RAILWAY_PRIVATE_DOMAIN}}`, `REDIS_PORT=6379`, `REDIS_PASSWORD` (generated), `CELERY_BROKER_URL=redis://:${{redis.REDIS_PASSWORD}}@${{redis.RAILWAY_PRIVATE_DOMAIN}}:6379/1`, `VECTOR_STORE=pgvector` + `PGVECTOR_HOST/PORT/USER/PASSWORD/DATABASE` (same postgres), `STORAGE_TYPE=s3` + `S3_ENDPOINT/S3_BUCKET_NAME/S3_ACCESS_KEY/S3_SECRET_KEY/S3_REGION` (Railway bucket, virtual-host style: `S3_ADDRESS_STYLE=virtual`), `CODE_EXECUTION_ENDPOINT=http://${{sandbox.RAILWAY_PRIVATE_DOMAIN}}:8194`, `CODE_EXECUTION_API_KEY=${{sandbox.API_KEY}}`, `SSRF_PROXY_HTTP_URL`/`SSRF_PROXY_HTTPS_URL=http://${{ssrf-proxy.RAILWAY_PRIVATE_DOMAIN}}:3128`, `PLUGIN_DAEMON_URL=http://${{plugin-daemon.RAILWAY_PRIVATE_DOMAIN}}:5002`, `PLUGIN_DAEMON_KEY` + `INNER_API_KEY_FOR_PLUGIN` (generated, must match plugin-daemon), `CONSOLE_API_URL`/`CONSOLE_WEB_URL`/`SERVICE_API_URL`/`APP_API_URL`/`APP_WEB_URL=https://${{gateway.RAILWAY_PUBLIC_DOMAIN}}`, `FILES_URL=http://${{api.RAILWAY_PRIVATE_DOMAIN}}:5001`
- **gateway**: `API_HOST=${{api.RAILWAY_PRIVATE_DOMAIN}}:5001`, `WEB_HOST=${{web.RAILWAY_PRIVATE_DOMAIN}}:3000`, `PLUGIN_DAEMON_HOST=${{plugin-daemon.RAILWAY_PRIVATE_DOMAIN}}:5002`; healthcheck path `/gateway-health`
- **web**: `CONSOLE_API_URL`/`APP_API_URL=https://${{gateway.RAILWAY_PUBLIC_DOMAIN}}`, and `PORT=3000` — must be an explicit service variable: Railway injects `PORT=8080` at runtime, which overrides the image's ENV and breaks the gateway's `web:3000` upstream
- **sandbox**: `API_KEY` (generated), `HTTP_PROXY`/`HTTPS_PROXY=http://${{ssrf-proxy.RAILWAY_PRIVATE_DOMAIN}}:3128`
- **plugin-daemon**: `SERVER_KEY=${{api.PLUGIN_DAEMON_KEY}}`, `DIFY_INNER_API_KEY=${{api.INNER_API_KEY_FOR_PLUGIN}}`, `DIFY_INNER_API_URL=http://${{api.RAILWAY_PRIVATE_DOMAIN}}:5001`, `DB_*` as api but `DB_DATABASE=dify_plugin`, `REDIS_*` as api; volume at `/app/storage`
- **postgres**: `POSTGRES_PASSWORD` (generated); volume at `/var/lib/postgresql/data`
- **redis**: `REDIS_PASSWORD` (generated)

Notes and limits:

- `/socket.io` (workflow collaboration, compose profile `collaboration`) and the optional `api_websocket` service are not deployed; add them later if multi-user canvas editing matters.
- The sandbox's outbound traffic is forced through squid, which denies private-network destinations — workflow code can't probe your Railway internals. Don't remove the proxy to "simplify".
- Plugin virtualenvs persist on the plugin-daemon volume; expect ~1–2 min installs per plugin on first use.
- Model inference happens at your providers — Railway CPU is only orchestration, embeddings via API, and the web stack. Expect roughly 2–3 GB RAM across services at idle.

## Why Deploy Dify on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Dify on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
