# Squid egress proxy for the sandbox: blocks requests to private networks so
# user-authored workflow code can't probe Railway's internal network (SSRF).
# Config and entrypoint are vendored verbatim from dify v1.15.0
# docker/ssrf_proxy/ — the stock acls already permit fc00::/7 clients, which
# covers Railway's private-network range.
FROM ubuntu/squid:latest

ENV HTTP_PORT=3128 \
    COREDUMP_DIR=/var/spool/squid

COPY squid.conf.template /etc/squid/squid.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i 's/\r$//' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
