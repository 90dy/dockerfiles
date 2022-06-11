FROM node:16-alpine AS ccxt-rest
RUN apk add --update --no-cache \
			python3 \
			py3-pip \
			make \
			alpine-sdk \
			&& ln -sf python3 /usr/bin/python
RUN npm install -g ccxt-rest
EXPOSE 3000
VOLUME $HOME/ccxt-rest
ENTRYPOINT ["ccxt-rest"]
