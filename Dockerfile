FROM node:14-alpine
WORKDIR /app

COPY . .
RUN npm ci

CMD ["npm", "start"]
