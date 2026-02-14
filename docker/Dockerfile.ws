from node:alpine

workdir /user/src/app

COPY  ./packages ./packages
COPY  ./package.json ./package.json
COPY  ./turbo.json ./turbo.json

COPY  ./apps/ws-server ./apps/ws-server

RUN npm install -g pnpm 
RUN pnpm install --frozen-lockfile

RUN pnpm run generate
RUN pnpm run build

EXPOSE 8080

CMD ["pnpm", "run", "start:ws"]


