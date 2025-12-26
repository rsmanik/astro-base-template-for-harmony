# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the Astro site
RUN npm run build

# Production stage - serve static files
FROM node:20-alpine AS production

WORKDIR /app

# Install serve to host static files
RUN npm install -g serve

# Copy built files from build stage
COPY --from=build /app/dist ./dist

# Expose port 8080 (Fly.io default)
EXPOSE 8080

# Serve the static files
CMD ["serve", "-s", "dist", "-l", "8080"]
