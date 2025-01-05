FROM node:16 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

COPY .env .

FROM node:16-alpine

WORKDIR /app

COPY --from=builder /app .

EXPOSE 3000

CMD ["node", "server.js"]
