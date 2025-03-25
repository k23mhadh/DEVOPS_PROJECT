# Use the base image Python 3.9 slim
FROM python:3.9-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the Python script and Bash script into the container
COPY make-data.py .
COPY generate-votes.sh .
# Make the Bash script executable
RUN chmod +x generate-votes.sh

# Run the Python script to generate the required files
RUN python make-data.py

# Set the Bash script as the entrypoint
ENTRYPOINT ["./generate-votes.sh"]