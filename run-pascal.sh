#!/bin/bash
# Run vllm docker image
# 
# Author: Jason A. Cox,
# Date: 27-Jan-2024
# https://github.com/jasonacox/TinyLLM

LLM=mistralai/Mistral-7B-Instruct-v0.1
CONTAINER=vllm-mistral-1

echo "Stopping and removing any previous $CONTAINER instance..."
docker stop $CONTAINER
docker rm $CONTAINER

echo "Starting new $CONTAINER instance..."

docker run -d \
  -p 8000:8000 \
  --shm-size=10.24gb \
  --gpus all \
  -e MODEL=$LLM \
  -e PORT=8000 \
  -e GPU_MEMORY_UTILIZATION=0.95 \
  -e DTYPE=float \
  -e MAX_MODEL_LEN=20000 \
  -e NUM_GPU=1 \
  -e SERVED_MODEL_NAME=tinyllm \
  -e HF_HOME=/app/models \
  -v $PWD/models:/app/models \
  --restart unless-stopped \
  --name $CONTAINER \
  vllm

echo "Printing logs (^C to quit)..."

docker logs $CONTAINER -f
