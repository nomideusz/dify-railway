FROM nginx:alpine

ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=1

COPY 05-default-port.envsh /docker-entrypoint.d/05-default-port.envsh
COPY default.conf.template /etc/nginx/templates/default.conf.template
