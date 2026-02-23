# ---- Stage 1: Builder ----
FROM node:20-alpine AS builder

RUN npm install -g pnpm

WORKDIR /usr/src/app

# Configure pnpm to avoid hardlinks (prevents overlayfs extraction failures on VM)
RUN echo "node-linker=hoisted" > .npmrc

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

# 1. Copy workspace config files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./

# 2. Copy package.json files for dependency resolution
COPY apps/ws-server/package.json ./apps/ws-server/package.json
COPY packages/database/package.json ./packages/database/package.json
COPY packages/config-typescript/ ./packages/config-typescript/
COPY packages/config-eslint/package.json ./packages/config-eslint/package.json

# 3. Install dependencies
RUN pnpm install

# 4. Copy source code
COPY packages/database/ ./packages/database/
COPY apps/ws-server/ ./apps/ws-server/

# 5. Generate Prisma client
RUN pnpm run db:generate

# 6. Build
RUN pnpm turbo run build --filter=ws-server


# ---- Stage 2: Runtime ----
FROM node:20-alpine

WORKDIR /usr/src/app

# Copy built app from builder (COPY --from dereferences all hardlinks)
COPY --from=builder /usr/src/app ./

# Remove build-time DATABASE_URL
ENV DATABASE_URL=""

EXPOSE 8080

CMD ["node", "apps/ws-server/dist/index.js"]