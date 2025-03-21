FROM ghcr.io/danny-avila/librechat-dev:latest
LABEL org.opencontainers.image.source=https://github.com/danieldjupvik/librechat-custom
# Override the logo with your custom asset
COPY client/public/assets/logo.svg /app/client/public/assets/logo.svg
COPY client/public/assets/logo.svg /app/client/dist/assets/logo.svg
# Add more COPY commands if needed for other assets