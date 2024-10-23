#!/bin/bash

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "This script is designed to run only on macOS."
  exit 1
fi

# Remove any existing audio file
rm -f example_audio_en.mp3

# Use the `say` command to generate audio from text
say -r 160 "This project uses Open A.I.'s Whisper models to transcribe wave and mp3 audio files using a Docker container. The processing of the audio files is managed through a directory structure of to-do, processing, done and transcript folders. To select the size of the whisper model to transcribe an audio file, simply put the audio file into the to-do folder and the subdirectory by the name of the model that should be used." -o example_audio_en.aiff

# Convert the AIFF file to MP3 using ffmpeg
ffmpeg -i example_audio_en.aiff -acodec libmp3lame -b:a 128k -ac 1 example_audio_en.mp3

# Remove the temporary AIFF file
rm -f example_audio_en.aiff

# Play the generated MP3 file using afplay (default player on macOS)
afplay example_audio_en.mp3
