FROM node:lts-alpine

WORKDIR /home/node/api

COPY package.json .
COPY api.mjs .

RUN npm install

CMD [ "npm", "start" ]

EXPOSE 3000
