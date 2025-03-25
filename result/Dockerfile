# Use the base image Node.js 18 slim
FROM node:18-slim

# Set the working directory to /usr/local/app
WORKDIR /usr/local/app

# Copy package.json and package-lock.json (or npm-shrinkwrap.json)
COPY package*.json ./

# Install nodemon globally
RUN npm install -g nodemon

# Install dependencies using npm ci
RUN npm ci

# Clean npm cache to reduce image size
RUN npm cache clean --force

# Move node_modules to a shared location
RUN mv /usr/local/app/node_modules /node_modules

# Copy the rest of the application code
COPY . .

# Set the PORT environment variable
ENV PORT=4000

# Expose the port the app will run on
EXPOSE $PORT

# Run the application
CMD ["node", "server.js"]