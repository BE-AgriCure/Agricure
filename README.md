# AgriCure: AI-Powered Plant Disease Detection App

A production-ready Flutter application for plant disease detection using MobileNetV2 and TensorFlow Lite with online Python FastAPI backend support.

## 🎯 Features

- **Offline Detection**: TFLite model bundled in assets for instant predictions
- **Online Mode**: Upload to Python API for server-side inference
- **Firebase Auth**: Email/password authentication
- **Disease Detection**: Real-time plant disease identification via camera or gallery
- **Care Scheduler**: Local notifications for watering and plant care reminders
- **Weather Integration**: OpenWeatherMap API for weather-based recommendations
- **Training Graphs**: Accuracy/Loss visualization from model training

## 📁 Project Structure

```
AgriCure/
├── backend/              # Python FastAPI server
│   ├── train_model.py   # MobileNetV2 training script
│   ├── app.py           # FastAPI inference server
│   └── requirements.txt  # Python dependencies
│
└── flutter_app/         # Flutter mobile app
    ├── assets/          # model.tflite, labels.txt, remedies.json
    ├── lib/
    │   ├── main.dart
    │   ├── services/    # TFLite, Auth, Weather, API, Scheduler
    │   └── screens/     # UI screens
    └── pubspec.yaml
```

## 🚀 Quick Start

### Step 1: Backend Setup

#### Install Python Dependencies
```bash
cd backend
pip install -r requirements.txt
```

#### Configure Dataset
1. Download from [Kaggle: New Plant Diseases Dataset](https://www.kaggle.com/datasets/vipoooool/new-plant-diseases-dataset-augmented)
2. Upload `train/` and `valid/` folders to a public Google Drive folder
3. Copy the folder ID from the URL (e.g., `https://drive.google.com/drive/folders/{FOLDER_ID}`)
4. Update `DRIVE_FOLDER_ID` in `backend/train_model.py`

#### Train Model
```bash
python backend/train_model.py
```

This will:
- Download dataset from Google Drive
- Train MobileNetV2 model (~10 epochs + fine-tuning)
- Generate `model.tflite`, `labels.txt`, `remedies.json`
- Create accuracy/loss graphs
- Output all files to `flutter_app/assets/`

### Step 2: Flutter App Setup

#### Create Flutter Project
```bash
flutter create flutter_app
```

#### Copy Files
Copy all generated files from `backend/` output to your Flutter app.

#### Install Dependencies
```bash
cd flutter_app
flutter pub get
```

#### Firebase Configuration
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Add Android and iOS apps
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Place them in appropriate directories
6. Run: `flutterfire configure`

#### OpenWeatherMap API Key
1. Get free API key from [OpenWeatherMap](https://openweathermap.org/api)
2. Update `API_KEY` in `lib/services/weather_service.dart`

#### Run the App
```bash
flutter run
```

### Step 3: Backend Server (Optional - for online predictions)

```bash
cd backend
uvicorn app:app --reload --port 8000
```

Update API endpoint in `lib/services/api_service.dart`:
- **Emulator**: `http://10.0.2.2:8000`
- **Physical Device**: `http://{YOUR_IP}:8000`

## 📊 Model Details

- **Architecture**: MobileNetV2 (pretrained on ImageNet)
- **Input Size**: 224×224 RGB
- **Output**: Disease class + confidence score
- **Expected Accuracy**: ~95% on PlantVillage dataset
- **Model Size**: ~15-20MB (TFLite)

## 🔧 Configuration

### Firebase Setup
Edit `lib/firebase_options.dart` with your Firebase credentials:
```dart
class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    databaseURL: 'YOUR_DATABASE_URL',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
```

### API Backend
Edit `lib/services/api_service.dart` base URL:
```dart
static const String BASE_URL = 'http://10.0.2.2:8000'; // for emulator
```

### Weather API
Edit `lib/services/weather_service.dart`:
```dart
static const String API_KEY = 'YOUR_OPENWEATHER_API_KEY';
```

## 📱 Android Permissions

Required permissions are configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## 🎨 App Screens

### 1. **Home Screen** (Disease Detection)
- Camera/Gallery image picker
- Real-time TFLite inference
- Display disease name, confidence, and remedy

### 2. **Profile Screen**
- User account information
- Logout functionality

### 3. **Scheduler Screen**
- Create care schedules (watering, fertilizing, etc.)
- Local push notifications
- Schedule management

### 4. **Weather Screen**
- Current weather at device location
- Temperature, humidity, wind speed
- Care recommendations based on weather

## 🔌 API Endpoints (Backend)

### POST `/predict`
Upload an image for disease prediction.

**Request**: Multipart form-data (image file)

**Response**:
```json
{
  "disease": "Early blight",
  "confidence": 0.95,
  "remedy": "Apply fungicide, ensure proper drainage..."
}
```

### POST `/predict_batch`
Predict multiple images at once.

### GET `/health`
Health check endpoint.

## 🛠️ Troubleshooting

### Model not loading in Flutter
- Ensure `model.tflite`, `labels.txt`, `remedies.json` are in `flutter_app/assets/`
- Verify `pubspec.yaml` asset paths

### Firebase errors
- Run `flutterfire configure` again
- Check Firebase Console credentials
- Ensure internet connectivity

### Weather permission denied
- Grant location permission when prompted
- Check phone Settings > Apps > AgriCure > Permissions

### Backend connection issues
- Ensure backend is running: `uvicorn app:app --reload`
- Check IP address for physical device
- Verify firewall settings

## 📈 Model Training

### Dataset Info
- **Source**: PlantVillage (Kaggle)
- **Size**: ~54,000 images
- **Classes**: 38 plant diseases
- **Train/Val/Test**: 70/15/15 split

### Training Process
1. Download dataset from Google Drive
2. Data augmentation (rotation, flip, brightness)
3. Transfer learning with frozen MobileNetV2 base
4. Fine-tuning with low learning rate
5. Convert to TFLite with optimizations

### Performance
- Training Accuracy: ~97-99%
- Validation Accuracy: ~95-96%
- Test Accuracy: ~94-95%
- Inference Time: ~50-100ms per image (on-device)

## 📚 Technologies Used

- **Framework**: Flutter 3.x, Dart
- **ML**: TensorFlow 2.15, TFLite
- **Backend**: FastAPI, Python
- **Auth**: Firebase Authentication
- **Database**: Firebase Firestore (optional)
- **Notifications**: flutter_local_notifications
- **Weather**: OpenWeatherMap API
- **Camera**: image_picker, camera plugins

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Backend (Heroku/Railway)
1. Push code to Git repository
2. Deploy with Procfile:
```
web: uvicorn backend.app:app --host 0.0.0.0 --port $PORT
```

## 📝 License

This project is open-source and available under the MIT License.

## 🤝 Contributing

Contributions welcome! Please fork and submit pull requests.

## 📧 Support

For issues or questions, open an issue on GitHub or contact the development team.

---

**AgriCure**: Empowering farmers with AI-powered plant health monitoring! 🌱
