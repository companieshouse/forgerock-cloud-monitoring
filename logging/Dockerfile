FROM node:17-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install -g npm

RUN npm install

COPY . .

CMD [ "case $LOG_SOURCE in 'AM') ./tail_am;; 'IDM') ./tail_idm;; ; esac" ]