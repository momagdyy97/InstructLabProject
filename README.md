📌 Deploying, Training, and Running a Pretrained Model for SQL & Database Research in GGUF Format
Project Objectives:

✅ Identify a Pretrained Model for SQL and Database Research
✅ Set Up InstructLab on an NVIDIA GPU-Powered System
✅ Download and Prepare the Model for Use
✅ Train the Model with Custom SQL Data
✅ Convert and Deploy the Model in GGUF Format
✅ Execute and Assess Model Performance

🚀 SQLCoder API - CUDA-Optimized Deployment
This repository provides an SQLCoder API powered by FastAPI, optimized for CUDA acceleration on NVIDIA GPUs. It supports SQL-based NLP tasks using the ollama and vllm frameworks, leveraging PyTorch and Hugging Face transformers.

🔧 Setup Instructions

1️⃣ Install Dependencies

Ensure the following components are installed:

✅ Docker (latest version)
✅ NVIDIA Drivers (for GPU acceleration)
✅ NVIDIA Container Toolkit (for GPU-enabled Docker)
✅ At least 16GB RAM (to ensure smooth execution)

To confirm NVIDIA drivers are correctly installed, run:

nvidia-smi

If successful, your GPU details should be displayed.

2️⃣ Build & Launch the Docker Container

Build the Image:

docker-compose build --no-cache

Start the Container:

docker-compose up -d

3️⃣ Validate the Model & API

Test FastAPI Server:

📌 API Documentation: http://127.0.0.1:8000/docs

📌 OpenAPI JSON Spec: http://127.0.0.1:8000/openapi.json

Verify CUDA is Enabled Inside the Container:

docker exec -it sqlcoder python3 -c "import torch; print(torch.cuda.is_available())"

✅ If True, CUDA is correctly set up.

❌ If False, check the NVIDIA driver and CUDA installation.

🧠 Manually Installing & Training SQLCoder Inside the Container

As downloading and training large models can be time-consuming, it’s best to install them inside the running container.

1️⃣ Access the Running Container

docker exec -it sqlcoder /bin/bash

2️⃣ Download SQLCoder-7B Model

mkdir -p /root/.local/share/instructlab/checkpoints
wget -O /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
https://example.com/path-to-your-model/sqlcoder-trained-Q4_K_M.gguf

This ensures the model is properly downloaded and avoids build-time failures.

Using SQLCoder Inside the Container

1️⃣ Test the Model in a Chat Session

docker exec -it sqlcoder ilab model chat \
    -m /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf

2️⃣ Evaluate Model Performance

docker exec -it sqlcoder ilab model evaluate --benchmark mmlu_branch \
    --model /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
    --base-model ~/.cache/instructlab/models/sqlcoder-7b.gguf

🛠 Ensuring Persistent Model Storage

To retain SQLCoder models across container restarts, modify docker-compose.yml to include:

volumes:
  - ./models:/root/.local/share/instructlab/checkpoints:rw

This prevents model files from being deleted when the container stops.

📜 Optimizations & Cleanup

1️⃣ Remove All Docker Data (Optional)

To clean up old Docker images and volumes:

docker system prune -a --volumes

2️⃣ Rebuild the Image

docker-compose build --no-cache

3️⃣ Restart the Container

docker-compose up -d

🚀 This should result in a significantly faster build process.

📌 Training SQLCoder on Custom SQL Datasets

1️⃣ Clone the InstructLab Taxonomy Repository

git clone --depth=1 https://github.com/instructlab/taxonomy.git

cd taxonomy

2️⃣ Create a Custom Training Dataset

mkdir -p knowledge/computer_science/databases/sql/qna
echo -e "question: 'What is an index in a database?'\nanswer: 'An index improves query performance by allowing faster lookups.'" \
> knowledge/computer_science/databases/sql/qna.yaml

3️⃣ Train SQLCoder on Custom Data

# Activate virtual environment

source /opt/venv/bin/activate

# Start training

ilab model train --pipeline accelerated --device cuda --data-path ~/.local/share/instructlab/datasets/

🔥 This fine-tunes SQLCoder using GPU acceleration.

💾 Saving the Trained Model to a New Docker Image

To persist your trained model and dependencies:

docker commit sqlcoder my-sqlcoder-image

docker tag my-sqlcoder-image my-repo/sqlcoder:latest

🚀 Now, models won’t need to be redownloaded on each container start.

🚀 Converting & Deploying the Model in GGUF Format

After training SQLCoder with custom SQL datasets, converting it to GGUF format ensures optimized deployment.

1️⃣ Convert Model to GGUF Format

Inside the running container, execute:

docker exec -it sqlcoder bash

ilab model convert --input /root/.local/share/instructlab/checkpoints/sqlcoder-trained.bin \
                    --output /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
                    --format gguf

This process converts the model to GGUF, improving inference efficiency.

2️⃣ Verify Model Conversion

Check if the .gguf file is present:


ls -lh /root/.local/share/instructlab/checkpoints/

3️⃣ Serve the GGUF Model for Inference

To start the API service inside the container:

uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4

Running & Evaluating the Model

1️⃣ Start a Chat Session with the Trained Model

docker exec -it sqlcoder ilab model chat \
    -m /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf

2️⃣ Benchmark the Model Performance

Evaluate performance on the MMLU dataset:

docker exec -it sqlcoder ilab model evaluate --benchmark mmlu_branch \
    --model /root/.local/share/instructlab/checkpoints/sqlcoder-trained-Q4_K_M.gguf \
    --base-model ~/.cache/instructlab/models/sqlcoder-7b.gguf

3️⃣ Review Performance Metrics

After running the evaluation, analyze accuracy, latency, and execution speed.

🔗 Useful Resources

🔹 SQLCoder Repository: GitHub

🔹 FastAPI Documentation: FastAPI Docs

🔹 NVIDIA Container Toolkit Setup: Installation Guide

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
