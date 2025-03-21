FROM node:18-bullseye-slim

# Label for GitHub container registry
LABEL org.opencontainers.image.source=https://github.com/danieldjupvik/librechat-custom

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the LibreChat repository (latest version)
RUN git clone https://github.com/danny-avila/LibreChat.git .

# Copy our custom logo to replace the default one
COPY assets/logo.svg /app/client/public/assets/logo.svg

# Install dependencies and build the application
RUN npm install
RUN npm run build

# Expose port (default for LibreChat)
EXPOSE 3080

# Start the application
CMD ["npm", "start"]