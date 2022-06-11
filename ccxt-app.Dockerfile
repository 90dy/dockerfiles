FROM node:16 AS ccxt-app-cloner
ARG SSH_PRIVATE_KEY
RUN \
	mkdir -p /root/.ssh \
	&& echo "${SSH_PRIVATE_KEY}" > /root/.ssh/key \
	&& echo "IdentityFile /root/.ssh/key" >> /root/.ssh/config \
 	&& echo "StrictHostKeyChecking no" >> /root/.ssh/config \
 	&& chmod 400 /root/.ssh/key /root/.ssh/config \
 	&& touch /root/.ssh/known_hosts \
 	&& ssh-keyscan github.com >> /root/.ssh/known_host
RUN git clone git@github.com:90dy/ccxt-app -vvvv

FROM node:16 AS ccxt-app
RUN curl -f https://get.pnpm.io/v6.32.js | node - add --global pnpm

ARG PORT=3000
ENV WEBHOOK_TOKEN=
ENV SESSION_SECRET_KEY=
VOLUME data
EXPOSE ${PORT}

WORKDIR /usr/src/app
COPY --from=ccxt-app-cloner ccxt-app /usr/src/app

RUN pnpm install --frozen-lockfile
RUN pnpm run build

CMD pnpm blitz migrate deploy && pnpm run start -p ${PORT}

