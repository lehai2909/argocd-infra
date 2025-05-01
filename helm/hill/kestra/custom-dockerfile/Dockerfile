# Use the base image
FROM kestra/kestra

# Set the working directory
WORKDIR /app

USER root

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip3 install --no-cache-dir requests jaydebeapi

USER kestra

EXPOSE 8080
# Set the command to run the server in standalone mode
CMD ["server", "local"]