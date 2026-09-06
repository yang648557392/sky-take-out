FROM node:16.20.2-bullseye AS build

WORKDIR /app

ENV CYPRESS_INSTALL_BINARY=0

COPY sky-admin-vue/package.json sky-admin-vue/package-lock.json ./

RUN npm ci --legacy-peer-deps

COPY sky-admin-vue ./

ARG VUE_APP_SOCKET_URL=wss://skytakeout.yangmingzhe.com/ws/
ENV VUE_APP_SOCKET_URL=${VUE_APP_SOCKET_URL}

RUN npm run build

FROM nginx:1.28-alpine

COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
