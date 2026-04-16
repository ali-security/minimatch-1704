# syntax=docker/dockerfile:1
FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

# -- Seal Security: patch vulnerable packages --
ARG SEAL_CACHE_BUST=0
ADD --chmod=755 https://github.com/seal-community/cli/releases/download/latest/seal-linux-amd64-latest?sealcache=${SEAL_CACHE_BUST} seal
RUN --mount=type=secret,id=SEAL_TOKEN export SEAL_TOKEN=$(cat /run/secrets/SEAL_TOKEN) && ./seal fix --mode all --remove-cli
# -- End Seal Security --

COPY . .

RUN npm run prepare
