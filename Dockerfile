# ==========================
# 🚀 Stage 1: Build Environment
# ==========================
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS build-env

# Set environment variables
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    VENV_PATH=/opt/venv

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    cmake \
    python3-dev \
    python3-venv \
    libssl-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python3 -m venv ${VENV_PATH}
ENV PATH="${VENV_PATH}/bin:$PATH"

# Set working directory
WORKDIR /workspace

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir ollama vllm 

# Copy application code
COPY ./app /workspace/app

# ==========================
# 🚀 Stage 2: Runtime Environment
# ==========================
FROM python:3.10-slim AS runtime-env

# Set environment variables
ENV LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# Add NVIDIA CUDA repository for Debian
RUN apt-get update && apt-get install -y --no-install-recommends wget && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=8.7.0.*-1+cuda11.8 \
    libssl-dev \
    libffi-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy application and dependencies from build stage
WORKDIR /workspace
COPY --from=build-env /workspace /workspace
COPY --from=build-env /opt/venv /opt/venv

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port and set entrypoint
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
