FROM langgenius/dify-web:1.15.0

# Next.js standalone server binds HOSTNAME; :: makes it reachable over
# Railway's IPv6-only private network (the gateway is its only caller).
ENV HOSTNAME=:: \
    PORT=3000
