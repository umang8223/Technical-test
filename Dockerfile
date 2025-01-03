# Use the official NGINX image from Docker Hub
FROM nginx:latest

# Expose port 80 (default port for HTTP)
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]

