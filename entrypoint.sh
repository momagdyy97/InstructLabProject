#!/bin/bash

# Exit on error
set -e

# Activate virtual environment
source /opt/venv/bin/activate

# Start FastAPI server
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
