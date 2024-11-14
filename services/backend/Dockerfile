# ref: https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
FROM node:18-bullseye

# Install ping and curl
RUN apt-get update && \
    apt-get install -y iputils-ping curl postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install NPM requisites
WORKDIR /opt/backend

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./package*.json ./

RUN npm ci && npm cache clean --force

# Copy app source
COPY . .

EXPOSE 8080

# Start up and run indefinitely
CMD ["npm", "start"]
