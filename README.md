
# Batch Transcribe Audiofiles using Whisper running on GPU with Docker

If you are looking for the [non-GPU version look here](https://github.com/florianbuetow/batch-transcribe-with-whisper-local-cpu).

This project uses [OpenAI's Whisper](https://github.com/openai/whisper) model to transcribe audio files inside a Docker container. The audio files are organized into a directory structure (`todo`, `processing`, `done`, and `transcripts`), and the Whisper model is selected by placing files into corresponding subfolders.

## Project Structure

```bash
.
├── Dockerfile
├── README.md
├── docker_run.sh
├── docker_delete.sh
├── transcribe_all.sh
├── data
│   ├── todo
│   │   ├── base
│   │   ├── base.en
│   │   ├── large
│   │   ├── medium
│   │   ├── medium.en
│   │   ├── small
│   │   ├── small.en
│   │   ├── tiny
│   │   ├── tiny.en
│   │   └── turbo
│   ├── processing
│   ├── done
│   └── transcripts
├── generate_example_audio.sh
├── example_audio_en.mp3
└── requirements.txt
```

- `Dockerfile`: Defines the Docker image with Whisper and all necessary dependencies.
- `docker_run.sh`: Script to build the Docker image (if needed) and run the Docker container.
- `docker_delete.sh`: Script to remove the Docker image once no longer needed.
- `transcribe_all.sh`: Script that handles the transcription process, moving files between `todo`, `processing`, and `done` directories, and placing transcripts in the `transcripts` directory.
- `generate_example_audio.sh`: A macOS-specific script to generate example audio using the `say` command and convert it to `.mp3`.
- `data/todo`: Directory where you place audio files to be processed, organized by model subfolders.
- `data/processing`: Directory where files are temporarily moved during transcription.
- `data/done`: Directory where the processed audio files are stored after transcription is completed.
- `data/transcripts`: Directory where transcription results are saved, organized by model subfolder.

## Whisper Model Information

For details about the differences between Whisper models, refer to the official [Whisper repository](https://github.com/openai/whisper).

## Prerequisites

- **Docker**: Ensure Docker is installed on your machine. Check Docker installation with:
  ```bash
  docker --version
  ```

## Setup and Usage

### 1. Place Audio Files

Place the audio files (`.wav` or `.mp3`) into the appropriate subdirectory under `data/todo`, based on the model you'd like to use for transcription. For example:

```bash
cp example_audio_en.mp3 ./data/todo/tiny.en/
```

### 2. Build and Run the Docker Container

Run the `docker_run.sh` script to build the Docker image (if it doesn't exist) and run the container:

```bash
./docker_run.sh
```

Note that the building of the container can take some time during first run.
Similarly, when a model is used for the first time it will be downloaded and cached, which can also take some time. 

- The `docker_run.sh` script mounts your `data` folder into the Docker container so the transcription process can access the audio files and write the results back to your local machine.
- The container will automatically transcribe all `.wav` and `.mp3` files in the `data/todo` subfolders, move them to `data/processing` during transcription, and finally move the processed audio to `data/done` while the transcription results are saved in the `data/transcripts` directory.

### 3. View Transcription Results

After the process completes, you will find the transcribed files in the `data/transcripts` directory and the processed audio files in the `data/done` directory.

For example:
```bash
data/transcripts/tiny.en/
    ├── example_audio_en.txt  # Transcription result
data/done/tiny.en/
    ├── example_audio_en.mp3  # Original audio file
```

### 4. Generate Example Audio (macOS only)

If you're using macOS, you can generate an example audio file using the `generate_example_audio.sh` script. This will create a sample `.mp3` file in the project directory:

```bash
./generate_example_audio.sh
```

### 5. Clean Up Docker Image

If you need to remove the Docker image after use, run the `docker_delete.sh` script:

```bash
./docker_delete.sh
```

### 6. Example Workflow

1. Add your audio files to the appropriate model folder in `data/todo`:
   ```bash
   mv example.wav ./data/todo/base/
   ```

2. Run the transcription process:
   ```bash
   ./docker_run.sh
   ```

3. Once the transcription is complete, check the `data/transcripts` folder for transcription results and the `data/done` folder for the processed audio files:
   ```bash
   ls ./data/transcripts/base/
   ls ./data/done/base/
   ```

## Troubleshooting

- **Debugging**: If you create a virtual environment, you can run the `transcribe_all.sh` script directly to see any issues without docker in the way. Just ensure to `pip install -r requirements.txt` first and edit the `transcribe_all.sh` script to replace the absolute paths with relative ones. See inside the script for more details.
- **File format**: Ensure that your audio files are in `.wav` or `.mp3` format. Other formats may not be supported by Whisper.
- **Docker issues**: Ensure Docker is properly installed and running. Verify by checking the Docker version with `docker --version`.

## Notes

- **Automatic container cleanup**: The Docker container will automatically terminate once transcription is complete.
- **File organization**: The `transcribe_all.sh` script handles file movement between `todo`, `processing`, `done`, and `transcripts`, ensuring an organized workflow.
