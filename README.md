
SQLCoder API - CUDA-Optimized Deployment
This repository provides a FastAPI-based SQLCoder API optimized for CUDA acceleration with NVIDIA GPUs. It supports SQL-based NLP tasks using the ollama and vllm frameworks, backed by torch and transformers.

🔧 Setup Instructions

1️⃣ Install Required Dependencies
Ensure you have the following installed:

✅ Docker (latest version)
✅ NVIDIA Drivers (for GPU acceleration)
✅ NVIDIA Container Toolkit (for GPU-enabled Docker containers)
✅ Minimum 16GB RAM (for efficient model execution)
Verify NVIDIA Drivers
Check if your GPU is detected:


nvidia-smi
You should see your GPU details if the setup is correct.

2️⃣ Build & Run the Docker Container
Build the Image

docker-compose build --no-cache
Start the Container

docker-compose up -d

3️⃣ Verify the Model & API
Test the FastAPI Server
Once the container is running, check the API Swagger UI: 
📌 Swagger UI Docs: http://127.0.0.1:8000/docs
📌 Alternative OpenAPI JSON: http://127.0.0.1:8000/openapi.json

Check if CUDA is Enabled
Run inside the container:


docker exec -it sqlcoder python3 -c "import torch; print(torch.cuda.is_available())"
✅ If True, CUDA is working.
❌ If False, check your NVIDIA drivers & CUDA installation.

🧠 How to Install & Train SQLCoder Manually Inside the Container
Since downloading and training models can be time-consuming, it's best to install them manually inside the container after it is running.

1️⃣ Access the Running Container

docker exec -it sqlcoder /bin/bash

2️⃣ Manually Download SQLCoder-7B Model

mkdir -p /root/.local/share/instructlab/checkpoints
wget -O /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
https://example.com/path-to-your-model/sqlcoder-trained-Q4_K_M.gguf
This ensures the model is downloaded properly without causing build-time failures.

Using SQLCoder Inside the Container

1️⃣ Test the Model in a Chat Session

docker exec -it sqlcoder ilab model chat \
    -m /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf
    
2️⃣ Evaluate Model Performance

docker exec -it sqlcoder ilab model evaluate --benchmark mmlu_branch \
    --model /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
    --base-model ~/.cache/instructlab/models/sqlcoder-7b.gguf
    
🛠 Persistent Model Storage

If you want to persist the SQLCoder models across runs, ensure the /models volume is mounted properly in docker-compose.yml:

volumes:
  - ./models:/root/.local/share/instructlab/checkpoints:rw
This way, models won't get deleted when the container stops.

📜 # Final Cleanup & Optimizations

1️⃣ Delete All Docker Data (Optional)

If you want a fresh build:

docker system prune -a --volumes

2️⃣ Rebuild the Docker Image

docker-compose build --no-cache

3️⃣ Restart the Container

docker-compose up -d

Your build should be MUCH faster now!

Optional: Training SQLCoder on Custom Data
To train SQLCoder on your own dataset, follow these steps:

1️⃣ Clone the InstructLab Taxonomy Repository

git clone --depth=1 https://github.com/instructlab/taxonomy.git
cd taxonomy
2️⃣ Create a Custom Dataset

mkdir -p knowledge/computer_science/databases/sql/qna
echo -e "question: 'What is an index in a database?'\nanswer: 'An index improves query performance by allowing faster lookups.'" \
> knowledge/computer_science/databases/sql/qna.yaml

3️⃣ Train SQLCoder with Custom Data

# Activate virtual environment
source /opt/venv/bin/activate

# Train the model
ilab model train --pipeline accelerated --device cuda --data-path ~/.local/share/instructlab/datasets/
This will fine-tune SQLCoder on your dataset using GPU acceleration.

Saving Changes to a New Docker Image
If you want to save all installed dependencies & models inside the container:

docker commit sqlcoder my-sqlcoder-image
docker tag my-sqlcoder-image my-repo/sqlcoder:latest
Now, you won't need to re-download models every time.

🔗 Useful Resources
🔹 SQLCoder Repository: [GitHub](https://github.com/defog-ai/sqlcoder)
🔹 FastAPI Documentation: [FastAPI Docs](https://fastapi.tiangolo.com/)
🔹 NVIDIA Container Toolkit: Setup Guide https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html


