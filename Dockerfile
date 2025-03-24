# Start with the base image
FROM ghcr.io/danny-avila/librechat-dev:latest as base

# Create a temporary stage for modifications
FROM base as modify

# Extract the original index.html
RUN cp /app/client/dist/index.html /tmp/original-index.html

# Use grep and basic shell commands that should be available by default
RUN grep -v "<title>" /tmp/original-index.html > /tmp/temp1.html && \
    awk '/<head>/ { print $0; print "    <title>Daniel AI</title>"; next }1' /tmp/temp1.html > /tmp/temp2.html && \
    grep -v '<meta name="description"' /tmp/temp2.html > /tmp/temp3.html && \
    awk '/<head>/ { print $0; \
                    print "    <meta name=\"description\" content=\"Daniel AI - We speak human (with a little AI magic)\" />"; \
                    print "    <style>"; \
                    print "      /* Hide the model icons in the sidebar */"; \
                    print "      [data-testid=\"convo-item\"] > div:first-of-type {"; \
                    print "        display: none !important;"; \
                    print "      }"; \
                    print "      /* Adjust footer padding */"; \
                    print "      div[role=\"contentinfo\"] {"; \
                    print "        padding-top: 0.9rem !important;"; \
                    print "        padding-bottom: 1rem !important;"; \
                    print "      }"; \
                    print "      /* Balance form padding */"; \
                    print "      form.mx-auto.pl-2 {"; \
                    print "        padding-right: 0.5rem"; \
                    print "      }"; \
                    print "    </style>"; \
                    next }1' /tmp/temp3.html > /tmp/modified-index.html

# Final stage
FROM base

# Copy the modified index.html from the modify stage
COPY --from=modify /tmp/modified-index.html /app/client/dist/index.html

# Remove the max_tokens parameter from the title generation options
RUN sed -i '/max_tokens: 16,/d' /app/api/app/clients/OpenAIClient.js
# Change temperature for title generation
RUN sed -i 's/temperature: 0.2,/temperature: 0.7,/' /app/api/app/clients/OpenAIClient.js
# Add emoji instructions after ${titleInstruction} but before ${convo}
# RUN sed -i 's|\${titleInstruction}|\${titleInstruction} Start the title with one emoji that fits the topic (REQUIRED), The emoji should help communicate the subject.|' /app/api/app/clients/OpenAIClient.js
RUN echo ". Start the title with one emoji that fits the topic (REQUIRED), The emoji should help communicate the subject." > /tmp/emoji_instructions.txt && \
    sed -i "/const titleInstruction =/ s/'[^']*'/'&$(cat /tmp/emoji_instructions.txt)'/" /app/api/app/clients/OpenAIClient.js

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

