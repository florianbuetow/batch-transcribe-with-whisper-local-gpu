#!/bin/bash

# Set the image name
IMAGE_NAME="batch-transcribe-with-whisper-gpu"

# Check if the Docker image exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" != "" ]]; then
  echo "Deleting Docker image: $IMAGE_NAME..."

  # Remove the Docker image
  docker rmi $IMAGE_NAME

  echo "Docker image $IMAGE_NAME has been removed."
else
  echo "Docker image $IMAGE_NAME does not exist."
fi
