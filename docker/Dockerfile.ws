FROM node:alpine

RUN npm install -g pnpm

WORKDIR /usr/src/app

ARG DATABASE_URL
# Make DATABASE_URL available as an env var in ALL RUN commands
ENV DATABASE_URL=$DATABASE_URL

# 1. Copy workspace config files first (needed for pnpm install)
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./
COPY turbo.json ./

# 2. Copy ALL workspace package.json files so pnpm can resolve dependencies
COPY apps/ws-server/package.json ./apps/ws-server/package.json
COPY packages/database/package.json ./packages/database/package.json
COPY packages/config-typescript/ ./packages/config-typescript/
COPY packages/config-eslint/package.json ./packages/config-eslint/package.json

# 3. Install dependencies
RUN pnpm install

# 4. Copy the actual source code
COPY packages/database/ ./packages/database/
COPY apps/ws-server/ ./apps/ws-server/

# 5. Generate Prisma client
RUN pnpm run db:generate

# 6. Build only the ws-server (and its dependencies)
RUN pnpm turbo run build --filter=ws-server

# 7. Remove build-time DATABASE_URL so it's not baked into the image
# The real DATABASE_URL should be provided at runtime via docker run -e or docker-compose
ENV DATABASE_URL=""

EXPOSE 8080

CMD ["pnpm", "run", "start:ws"]