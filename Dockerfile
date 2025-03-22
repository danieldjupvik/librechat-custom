FROM ghcr.io/danny-avila/librechat-dev:latest
# Override the logo with your custom asset
COPY assets/logo.svg /app/client/public/assets/logo.svg
COPY assets/logo.svg /app/client/dist/assets/logo.svg
