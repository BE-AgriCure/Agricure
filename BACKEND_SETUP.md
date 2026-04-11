# Backend Configuration Guide

## Backend Structure

```
backend/
├── train_model.py      # Model training script
├── app.py              # FastAPI server
├── requirements.txt    # Python dependencies
└── dataset/            # Downloaded dataset (not in repo)
```

## Environment Setup

### 1. Python Version
- **Required**: Python 3.8 or later
- **Recommended**: Python 3.10

### 2. Virtual Environment

#### On Windows:
```bash
python -m venv venv
venv\Scripts\activate
```

#### On macOS/Linux:
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

## Configuration Files

### train_model.py

**Key Variables to Update**:

```python
# Google Drive Configuration
DRIVE_FOLDER_ID = 'YOUR_DRIVE_FOLDER_ID_HERE'

# Data paths
DATA_DIR = 'dataset'
TRAIN_DIR = os.path.join(DATA_DIR, 'train')
TEST_DIR = os.path.join(DATA_DIR, 'valid')

# Model parameters
IMG_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS = 10

# Output directory
OUTPUT_DIR = '../flutter_app/assets/'
```

### app.py

**Default Configuration**:
- **Host**: 0.0.0.0 (all interfaces)
- **Port**: 8000
- **CORS**: Enabled for all origins (change in production)

**Model Paths** (must exist before running):
```python
MODEL_PATH = 'flutter_app/assets/model.tflite'
LABELS_PATH = 'flutter_app/assets/labels.txt'
REMEDIES_PATH = 'flutter_app/assets/remedies.json'
```

## Training Guidelines

### Dataset Preparation

1. **Download from Kaggle**
   - Size: ~3-4 GB
   - Classes: 38 disease types
   - Total images: ~54,000

2. **Folder Structure Required**
   ```
   dataset/
   ├── train/
   │   ├── Apple___Apple_scab/
   │   ├── Apple___Black_rot/
   │   └── ... (other classes)
   └── valid/
       ├── Apple___Apple_scab/
       ├── Apple___Black_rot/
       └── ... (other classes)
   ```

3. **Upload to Google Drive**
   - Create public folder
   - Upload train/ and valid/ folders
   - Copy folder ID from share link

### Training Time Estimates

- **GPU (NVIDIA RTX 3090)**: ~20-30 minutes
- **GPU (NVIDIA RTX 2080)**: ~45-60 minutes
- **CPU only**: ~2-4 hours (not recommended)

### Expected Results

- Training Accuracy: 97-99%
- Validation Accuracy: 95-96%
- Test Accuracy: 94-95%
- Model Size: 15-20 MB (TFLite)

## Running the Backend

### Development Mode

```bash
# With hot-reload
uvicorn backend.app:app --reload --port 8000

# Access API docs
# http://localhost:8000/docs
# http://localhost:8000/redoc
```

### Production Mode

```bash
# Using gunicorn (more stable)
pip install gunicorn
gunicorn -w 4 -k uvicorn.workers.UvicornWorker backend.app:app

# Using uvicorn (simple deployment)
uvicorn backend.app:app --host 0.0.0.0 --port 8000 --workers 4
```

## API Endpoints

### Health Check
```
GET /
GET /health
```

**Response**:
```json
{
  "status": "healthy"
}
```

### Single Prediction
```
POST /predict
Content-Type: multipart/form-data

File: <image_file>
```

**Success Response** (200):
```json
{
  "disease": "Early blight",
  "confidence": 0.9487,
  "remedy": "Remedy for Early blight: Apply fungicide, ensure proper drainage, isolate plant from others."
}
```

**Error Response** (400):
```json
{
  "detail": "Could not decode image"
}
```

### Batch Prediction
```
POST /predict_batch
Content-Type: multipart/form-data

Files: <image_files>
```

**Response**:
```json
[
  {
    "filename": "leaf1.jpg",
    "disease": "Early blight",
    "confidence": 0.9487,
    "remedy": "..."
  },
  {
    "filename": "leaf2.jpg",
    "disease": "Late blight",
    "confidence": 0.8765,
    "remedy": "..."
  }
]
```

## Testing Backend Locally

### Using cURL

```bash
# Test health
curl http://localhost:8000/health

# Test prediction
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@/path/to/leaf.jpg"
```

### Using Python

```python
import requests

# Single prediction
files = {'file': open('leaf.jpg', 'rb')}
response = requests.post('http://localhost:8000/predict', files=files)
print(response.json())

# Batch prediction
files = [('files', open('leaf1.jpg', 'rb')), 
         ('files', open('leaf2.jpg', 'rb'))]
response = requests.post('http://localhost:8000/predict_batch', files=files)
print(response.json())
```

## Performance Optimization

### Model Optimization

1. **Quantization** (already done in conversion):
   - INT8 quantization enabled
   - Reduces model size by ~75%
   - Minimal accuracy loss

2. **Further Optimization Options**:
   ```python
   # In train_model.py
   converter.optimizations = [tf.lite.Optimize.DEFAULT]
   converter.target_spec.supported_ops = [
       tf.lite.OpsSet.TFLITE_BUILTINS_INT8
   ]
   ```

### Server Optimization

1. **Multiple Workers**
   ```bash
   uvicorn app:app --workers 4
   ```

2. **Caching Responses**
   - Add caching headers for static responses
   - Implement request deduplication

3. **Batch Processing**
   - Use `/predict_batch` for multiple images
   - More efficient than individual requests

## Troubleshooting

### Dataset Download Fails
```
Error: gdown.download_folder failed
```

**Solutions**:
- Ensure folder is public (Share → Anyone with link)
- Check internet connection
- Try manual download from Google Drive

### Model Conversion Errors
```
Error: TFLiteConverter.from_keras_model failed
```

**Solutions**:
- Verify TensorFlow version matches
- Check for custom layers (not TFLite compatible)
- Use official TF Lite supported ops only

### Out of Memory (OOM)
```
Error: ResourceExhaustedError
```

**Solutions**:
- Reduce BATCH_SIZE (32 → 16 or 8)
- Use smaller IMG_SIZE (224 → 192 or 160)
- Train on GPU instead of CPU
- Use mixed precision training

### API Port Already in Use
```
Error: Address already in use: ('0.0.0.0', 8000)
```

**Solutions**:
```bash
# Find process using port 8000
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Use different port
uvicorn app:app --port 8001
```

## Production Deployment

### Deployment Checklist

- [ ] Train model on full dataset
- [ ] Validate accuracy metrics
- [ ] Test on diverse images
- [ ] Set up CORS properly (specific origins)
- [ ] Add rate limiting
- [ ] Add logging and monitoring
- [ ] Set up automatic backups
- [ ] Configure SSL/HTTPS
- [ ] Add API authentication
- [ ] Test error handling

### Environment Variables

Create `.env` file for production:
```
FASTAPI_ENV=production
MODEL_PATH=/path/to/model.tflite
LABELS_PATH=/path/to/labels.txt
REMEDIES_PATH=/path/to/remedies.json
CORS_ORIGINS=["https://yourdomain.com"]
API_KEY=your_secret_key
```

### Deployment Platforms

- **Railway** (recommended): Simple deployment, free tier
- **AWS**: Elastic Beanstalk or Lambda
- **Google Cloud**: Cloud Run or App Engine
- **Azure**: App Service
- **Heroku**: Paid (free tier ended)

---

**For more details, see README.md and IMPLEMENTATION_STEPS.md**
