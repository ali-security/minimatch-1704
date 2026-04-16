FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

ADD --chmod=755 https://github.com/seal-community/cli/releases/download/latest/seal-linux-amd64-latest seal
ENV SEAL_PROJECT="minimatch-1704"
RUN --mount=type=secret,id=SEAL_TOKEN export SEAL_TOKEN=$(cat /run/secrets/SEAL_TOKEN) && ./seal fix --mode all --remove-cli

COPY . .

RUN npm run prepare
