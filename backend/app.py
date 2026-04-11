from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import tensorflow as tf
import numpy as np
from PIL import Image
import io
import json
import uvicorn
import os

app = FastAPI(title="AgriCure API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load TFLite model
MODEL_PATH = 'flutter_app/assets/model.tflite'
LABELS_PATH = 'flutter_app/assets/labels.txt'
REMEDIES_PATH = 'flutter_app/assets/remedies.json'

try:
    interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    with open(LABELS_PATH, 'r') as f:
        labels = [line.strip() for line in f.readlines()]
    
    with open(REMEDIES_PATH, 'r') as f:
        remedies = json.load(f)
    
    print("✓ Model loaded successfully")
except Exception as e:
    print(f"Error loading model: {e}")
    print("Make sure model files exist in flutter_app/assets/")

IMG_SIZE = (224, 224)

@app.get("/")
async def root():
    return {
        "message": "AgriCure API - Plant Disease Detection",
        "version": "1.0.0",
        "endpoints": {
            "predict": "POST /predict (upload image)",
            "health": "GET /health"
        }
    }

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    Predict plant disease from image.
    
    Args:
        file: Image file (JPG, PNG, etc.)
    
    Returns:
        {
            "disease": str,
            "confidence": float,
            "remedy": str
        }
    """
    try:
        # Read file
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert('RGB')
        
        # Resize to model input size
        image = image.resize(IMG_SIZE)
        
        # Normalize
        image_array = np.array(image, dtype=np.float32) / 255.0
        image_array = np.expand_dims(image_array, axis=0)
        
        # Predict
        interpreter.set_tensor(input_details[0]['index'], image_array)
        interpreter.invoke()
        predictions = interpreter.get_tensor(output_details[0]['index'])[0]
        
        # Get top prediction
        predicted_idx = np.argmax(predictions)
        confidence = float(predictions[predicted_idx])
        disease = labels[predicted_idx]
        
        return {
            "disease": disease,
            "confidence": confidence,
            "remedy": remedies.get(disease, "Consult an agricultural expert.")
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/predict_batch")
async def predict_batch(files: list[UploadFile] = File(...)):
    """Predict for multiple images"""
    results = []
    for file in files:
        try:
            contents = await file.read()
            image = Image.open(io.BytesIO(contents)).convert('RGB')
            image = image.resize(IMG_SIZE)
            image_array = np.array(image, dtype=np.float32) / 255.0
            image_array = np.expand_dims(image_array, axis=0)
            
            interpreter.set_tensor(input_details[0]['index'], image_array)
            interpreter.invoke()
            predictions = interpreter.get_tensor(output_details[0]['index'])[0]
            
            predicted_idx = np.argmax(predictions)
            confidence = float(predictions[predicted_idx])
            disease = labels[predicted_idx]
            
            results.append({
                "filename": file.filename,
                "disease": disease,
                "confidence": confidence,
                "remedy": remedies.get(disease, "Consult an agricultural expert.")
            })
        except Exception as e:
            results.append({"filename": file.filename, "error": str(e)})
    
    return results

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
