FROM node:16 AS build
WORKDIR /app

# Nur package-Dateien zuerst, damit npm ci gecacht werden kann
COPY package*.json ./
RUN npm ci

# Rest vom Code
COPY . .
RUN npm run build

# Nginx-Stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /app/build .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

