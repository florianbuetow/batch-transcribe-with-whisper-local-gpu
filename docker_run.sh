#!/bin/bash

# Set the image name
IMAGE_NAME="batch-transcribe-with-whisper-gpu"

# Check if the Docker image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "Building Docker image..."
  docker build -t $IMAGE_NAME .
fi

# Run the container with the data folder mounted
echo "Running Docker container..."
docker run --rm -v "$(pwd)/data:/app/data" $IMAGE_NAME
