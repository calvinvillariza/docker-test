
## 1
FROM node:10-alpine as crank

COPY package.json package-lock.json ./

RUN npm i && mkdir /app && mv ./node_modules ./app

WORKDIR /app

COPY . .

## artifacts
RUN npm run release


## 2
FROM nginx:1.14.1-alpine

COPY nginx/.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=crank /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]