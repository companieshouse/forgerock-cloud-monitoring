FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install -g npm

RUN npm install

COPY . .

ENTRYPOINT "./launcher.sh"