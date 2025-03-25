# Use the official Nginx image
FROM nginx

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom configuration file into the container
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8000
EXPOSE 80

# Command to start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]