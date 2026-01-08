# Development stage
FROM node:20-alpine AS development

WORKDIR /app

# Copy all files
COPY . .

# Install dependencies
RUN npm install

# Expose port
EXPOSE 3000

# Start development server with host binding
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
