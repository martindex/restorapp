# Production stage (Ultra-Lightweight)
FROM nginx:stable-alpine

# Copy the pre-built files from the host's dist folder
# This makes the build instant and the image very small
COPY dist /usr/share/nginx/html

# Custom nginx config for React Router
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
