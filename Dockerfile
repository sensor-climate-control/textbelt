FROM node:18
WORKDIR /usr/app
COPY . .
RUN npm install
EXPOSE 9090
CMD ["npm", "start"]
