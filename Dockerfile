# Start with NVIDIA CUDA base image
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    python3-dev \
    ffmpeg \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install PyTorch with CUDA support
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Install Whisper
RUN pip3 install --no-cache-dir openai-whisper

# Copy the requirements.txt file into the container
COPY requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the transcribe script into the container
COPY transcribe_all.sh /app/transcribe_all.sh
RUN chmod +x /app/transcribe_all.sh

# Default command to run when the container starts
CMD ["/app/transcribe_all.sh"]
