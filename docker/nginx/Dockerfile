FROM nginx:alpine

ARG UID
ARG GID

RUN addgroup -g "$GID" sail \
    && adduser -G sail -u "$UID" sail -D

