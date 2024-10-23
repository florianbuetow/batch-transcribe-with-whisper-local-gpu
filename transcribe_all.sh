#!/bin/bash

# Directory paths
INPUT_DIR="/app/data/todo"
PROCESSING_DIR="/app/data/processing"
TRANSCRIPTS_DIR="/app/data/transcripts"
DONE_DIR="/app/data/done"

# If you want to test this script locally inside a venv, you can use the following relative paths:
#INPUT_DIR="./data/todo"
#PROCESSING_DIR="./data/processing"
#TRANSCRIPTS_DIR="./data/transcripts"
#DONE_DIR="./data/done"

# Create directories if they don't exist
mkdir -p "$INPUT_DIR"
mkdir -p "$PROCESSING_DIR"
mkdir -p "$TRANSCRIPTS_DIR"
mkdir -p "$DONE_DIR"

# Loop through all subfolders (model names) in the 'todo' directory
for model_path in "$INPUT_DIR"/*; do
  model=$(basename "$model_path")
  echo "FOUND PROCESSING JOB(S) FOR MODEL $model in $INPUT_DIR/$model/"
  if [ -d "$INPUT_DIR/$model" ]; then
    # Create corresponding processing and done subfolders for the model

    # Loop through all .wav and .mp3 files in the model's "todo" directory
    find "$INPUT_DIR/$model" -type f \( -iname "*.wav" -o -iname "*.mp3" \) | while read -r file; do
      if [ -f "$file" ]; then

        mkdir -p "$DONE_DIR/$model"
        mkdir -p "$PROCESSING_DIR/$model"

        # Move file to processing directory
        mv "$file" "$PROCESSING_DIR/$model/"
        FILENAME=$(basename "$file")

        # Transcribe the file using the model
        echo "Processing \"$FILENAME\" with model $model..."
        whisper "$PROCESSING_DIR/$model/$FILENAME" --model "$model" --output_format all --output_dir "$TRANSCRIPTS_DIR/$model/"

        # Move the processed file to the 'done' directory
        mv "$PROCESSING_DIR/$model/$FILENAME" "$DONE_DIR/$model/"
      fi
    done
  fi
done

# End the script
echo "Transcription completed!"
