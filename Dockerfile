# Build stage
FROM node:18-alpine AS build

# Create app directory
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Clone the full n8n repo
RUN apk add --no-cache git && \
    git clone https://github.com/n8n-io/n8n.git . && \
    pnpm install && \
    pnpm run build

# Production image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy built app from build stage
COPY --from=build /app /app

# Expose port
EXPOSE 5678

# Default environment
ENV N8N_PORT=5678

# Start n8n
CMD ["pnpm", "start"]
