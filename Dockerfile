FROM node:20-alpine

# Label for GitHub container registry
LABEL org.opencontainers.image.source=https://github.com/danieldjupvik/librechat-custom

# Install required dependencies
RUN apk --no-cache add curl

RUN mkdir -p /app && chown node:node /app
WORKDIR /app

USER node

# Clone the LibreChat repository
RUN apk --no-cache add git && \
    git clone https://github.com/danny-avila/LibreChat.git . && \
    apk del git

# Copy our custom logo over the default one
COPY --chown=node:node assets/logo.svg /app/client/public/assets/logo.svg

# Build the application following LibreChat's official process
RUN touch .env && \
    mkdir -p /app/client/public/images /app/api/logs && \
    npm config set fetch-retry-maxtimeout 600000 && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 15000 && \
    npm install --no-audit && \
    NODE_OPTIONS="--max-old-space-size=2048" npm run frontend && \
    npm prune --production && \
    npm cache clean --force

# Expose port (default for LibreChat)
EXPOSE 3080
ENV HOST=0.0.0.0

# Start the application (backend only since frontend is pre-built)
CMD ["npm", "run", "backend"]