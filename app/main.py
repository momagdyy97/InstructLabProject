from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
import uvicorn
import logging

# Initialize structured logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Initialize FastAPI app
app = FastAPI(title="SQLCoder API", version="1.0.0")

# Add CORS middleware for external access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict this to specific origins in production
    allow_methods=["*"],
    allow_headers=["*"],
)

# Root endpoint
@app.get("/")
async def root():
    return {"message": "✅ SQLCoder is running successfully!"}

# Run the app when executed directly
if __name__ == "__main__":
    try:
        port = int(os.getenv("API_PORT", "8000"))  # Use environment variable for flexibility
        uvicorn.run(app, host="0.0.0.0", port=port, log_level="info")
    except Exception as e:
        logging.error(f"Error starting the server: {e}")
