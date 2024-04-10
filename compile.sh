echo "Cloning vLLM source..."
git clone https://github.com/vllm-project/vllm.git
cd vllm

echo "Copying helpful files..."
mv Dockerfile Dockerfile.orig       
cp ../Dockerfile.source Dockerfile
cp ../entrypoint.sh entrypoint.sh 
cp ../run-pascal.sh run.sh
cp ../build.sh build.sh
cp ../setup.py.patch setup.py.patch

echo "Patching source code..."
cp setup.py setup.py.orig           
patch setup.py setup.py.patch

echo "Building docker image..."
./build.sh

echo "Creating models directory..."
mkdir models
echo "Models will be stored in ${PWD}/models."

echo "Build complete."
echo "To run vLLM, execute: ./run.sh"
