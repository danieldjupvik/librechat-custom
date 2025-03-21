LABEL org.opencontainers.image.source=https://github.com/danieldjupvik/librechat-custom
FROM ghcr.io/danny-avila/librechat-dev:latest
# Override the logo with your custom asset
COPY client/public/assets/logo.svg /app/client/public/assets/logo.svg
# Add more COPY commands if needed for other assets