FROM langgenius/dify-api:1.15.0

# Celery beat: schedules periodic tasks (dataset cleanup, trace syncing).
# Tiny footprint — one process, no queue consumption.
ENV MODE=beat
