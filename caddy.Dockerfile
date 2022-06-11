FROM caddy:builder AS caddy-builder

RUN xcaddy build \
	--with github.com/abiosoft/caddy-json-parse

FROM caddy:latest AS caddy

COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

VOLUME /etc/caddy/Caddyfile
VOLUME /data/caddy
VOLUME /config/caddy
