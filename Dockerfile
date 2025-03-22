# Start with the base image
FROM ghcr.io/danny-avila/librechat-dev:latest as base

# Create a temporary stage for modifications
FROM base as modify
# Install any tools needed for text processing if not already present
RUN apk add --no-cache sed

# Extract the original index.html
RUN cp /app/client/dist/index.html /tmp/original-index.html

# Modify the title and description using sed
RUN sed -i 's/<title>.*<\/title>/<title>Daniel AI Override<\/title>/' /tmp/original-index.html && \
    sed -i 's/<meta name="description" content=".*"/<meta name="description" content="Daniel AI - We speak human (with a little AI magic)"/' /tmp/original-index.html

# Final stage
FROM base
# Copy the modified index.html from the modify stage
COPY --from=modify /tmp/original-index.html /app/client/dist/index.html

# Override the logo with your custom asset
# COPY assets/new_index.html /app/client/dist/index.html
COPY assets/logo.svg /app/client/public/assets/logo.svg
COPY assets/logo.svg /app/client/dist/assets/logo.svg
COPY assets/favicon-16x16.png /app/client/public/assets/favicon-16x16.png
COPY assets/favicon-16x16.png /app/client/dist/assets/favicon-16x16.png
COPY assets/favicon-32x32.png /app/client/public/assets/favicon-32x32.png
COPY assets/favicon-32x32.png /app/client/dist/assets/favicon-32x32.png
COPY assets/apple-touch-icon-180x180.png /app/client/public/assets/apple-touch-icon-180x180.png
COPY assets/apple-touch-icon-180x180.png /app/client/dist/assets/apple-touch-icon-180x180.png
COPY assets/icon-192x192.png /app/client/public/assets/icon-192x192.png
COPY assets/icon-192x192.png /app/client/dist/assets/icon-192x192.png
COPY assets/maskable-icon.png /app/client/public/assets/maskable-icon.png
COPY assets/maskable-icon.png /app/client/dist/assets/maskable-icon.png
COPY assets/manifest.webmanifest /app/client/dist/manifest.webmanifest

