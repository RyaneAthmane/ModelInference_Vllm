LLM_DEFAULT=mistralai/Mistral-7B-Instruct-v0.1
CONTAINER_DEFAULT=vllm-mistral-1x

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 <model> <container_name>"
    echo "Example: $0 mistralai/Mistral-7B-Instruct-v0.1 vllm-mistral-1"
    exit 0
fi

if [[ ! -z "$1" && ! -z "$2" ]]; then
    LLM=$1
    CONTAINER=$2
fi

if [[ -z "${LLM}" ]]; then
    LLM=$LLM_DEFAULT
    CONTAINER=$CONTAINER_DEFAULT
fi

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
  -e NUM_GPU=1 \
  -e SERVED_MODEL_NAME=tinyllm \
  -e HF_HOME=/app/models \
  -v $PWD/models:/app/models \
  --restart unless-stopped \
  --name $CONTAINER \
  vllm

echo "Printing logs (^C to quit)..."

docker logs $CONTAINER -f
