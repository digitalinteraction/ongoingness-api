# Download Docker image, Node.js running on Alpine
FROM node:alpine


# Make an app directory to hold the server files.
RUN mkdir /app


# Set the working directory to app.
WORKDIR /app


COPY ./package.json /app/package.json


# Install npm packages.
RUN npm install


# Install nodemon
RUN npm install -g nodemon typescript apidoc

COPY .env /app/.env
COPY app.ts /app/app.ts
COPY tsconfig.json /app/tsconfig.json
COPY web /app/web
COPY test /app/test
COPY test.jpg /app/test.jpg
RUN mkdir uploads
RUN mkdir -p /app/static/apidoc

# Create docs
RUN apidoc -i /app/web -o /app/static

RUN npm run build

# Expose port 80
EXPOSE 80


# Start the server.
CMD nodemon dist/app.js