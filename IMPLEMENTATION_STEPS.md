# Implementation Steps for AgriCure

Follow these steps in order to successfully implement the AgriCure plant disease detection app.

## Phase 1: Backend Setup & Model Training (Day 1)

### Step 1.1: Install Python & Dependencies
```bash
# Navigate to backend folder
cd backend

# Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies
pip install -r requirements.txt
```

### Step 1.2: Prepare Dataset
1. **Download Dataset**
   - Go to [Kaggle: New Plant Diseases Dataset](https://www.kaggle.com/datasets/vipoooool/new-plant-diseases-dataset-augmented)
   - Download the dataset (~3-4 GB)
   - Extract to get `train/` and `valid/` folders

2. **Upload to Google Drive**
   - Create a public folder on Google Drive
   - Upload `train/` and `valid/` folders
   - Copy the folder ID from URL (e.g., `1ABC123XYZ` from `https://drive.google.com/drive/folders/1ABC123XYZ`)

3. **Update Configuration**
   - Open `backend/train_model.py`
   - Find line: `DRIVE_FOLDER_ID = 'YOUR_DRIVE_FOLDER_ID_HERE'`
   - Replace with your actual folder ID

### Step 1.3: Train the Model
```bash
# Run training script
python backend/train_model.py

# Expected output:
# ✓ Model trained!
# ✓ TFLite model saved: ../flutter_app/assets/model.tflite
# ✓ Labels saved: ../flutter_app/assets/labels.txt
# ✓ Remedies saved: ../flutter_app/assets/remedies.json
```

**Training Time**: ~30-60 minutes depending on GPU
**Output Files**:
- `flutter_app/assets/model.tflite` (15-20 MB)
- `flutter_app/assets/labels.txt` (disease names)
- `flutter_app/assets/remedies.json` (treatment recommendations)
- `flutter_app/assets/accuracy_graph.png` (training metrics)
- `flutter_app/assets/loss_graph.png` (loss metrics)

### Step 1.4: Test Backend API
```bash
# Start API server
uvicorn app:app --reload --port 8000

# Test endpoint (in another terminal)
curl http://localhost:8000/health
# Expected: {"status":"healthy"}

# Upload test image to /predict endpoint
# Response: {"disease": "...", "confidence": ..., "remedy": "..."}
```

## Phase 2: Flutter App Setup (Day 2)

### Step 2.1: Flutter Installation
```bash
# Verify Flutter installation
flutter --version

# If not installed, download from https://flutter.dev
```

### Step 2.2: Create Flutter Project
```bash
# Navigate to parent directory
cd ..

# Create Flutter project
flutter create flutter_app

# Navigate into project
cd flutter_app

# Get dependencies
flutter pub get
```

### Step 2.3: Update pubspec.yaml
- All dependencies are already configured in the template
- Run: `flutter pub get` to install

### Step 2.4: Firebase Configuration

#### Android Setup:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project or select existing
3. Click "Add app" → Select Android
4. Download `google-services.json`
5. Place in `android/app/google-services.json`
6. Run: `flutterfire configure`

#### iOS Setup:
1. In Firebase Console, add iOS app
2. Download `GoogleService-Info.plist`
3. Open Xcode: `ios/Runner.xcworkspace`
4. Drag & drop plist file into Xcode

#### Update Firebase Options:
```dart
// lib/firebase_options.dart
// Fill in credentials from Firebase Console
class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    // ... other fields
  );
}
```

### Step 2.5: Get OpenWeatherMap API Key
1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for free account
3. Get free API key
4. Update in `lib/services/weather_service.dart`:
```dart
static const String API_KEY = 'YOUR_OPENWEATHER_API_KEY';
```

### Step 2.6: Verify Asset Files
```bash
# Check that these files exist in flutter_app/assets/
ls assets/
# Should show:
# - model.tflite
# - labels.txt
# - remedies.json
# - accuracy_graph.png
# - loss_graph.png
```

## Phase 3: Testing & Deployment (Day 3)

### Step 3.1: Android Testing

#### On Emulator:
```bash
# Start Android emulator
# (from Android Studio or: emulator -avd <emulator_name>)

# Run app
flutter run

# Or run on specific device
flutter devices
flutter run -d <device_id>
```

#### On Physical Device:
1. Enable Developer Mode (Settings > About > tap Build Number 7x)
2. Enable USB Debugging
3. Connect via USB
4. Update API endpoint for your IP:
```dart
// lib/services/api_service.dart
static const String BASE_URL = 'http://YOUR_IP:8000';
```
5. Run: `flutter run`

### Step 3.2: iOS Testing

```bash
# Get iOS pods
cd ios
pod install
cd ..

# Run on simulator
flutter run -d "iPhone 14"

# Or on physical device (requires Apple Developer account)
```

### Step 3.3: Test Features

#### 1. **Authentication**
- Tap "Create Account"
- Enter email and password
- Verify Firebase accepts credentials
- Login with created credentials

#### 2. **Disease Detection (Offline)**
- Navigate to Home tab
- Tap "Camera" to capture leaf photo
- Should see prediction without internet

#### 3. **Disease Detection (Online)**
- Start backend server: `uvicorn app:app --reload`
- Update API endpoint
- Test online prediction

#### 4. **Weather**
- Navigate to Weather tab
- Grant location permission
- Should display current weather and recommendations

#### 5. **Scheduler**
- Navigate to Schedule tab
- Add watering reminder
- Check notifications appear at scheduled time

#### 6. **Profile**
- View user email
- Test logout functionality

### Step 3.4: Build for Release

#### Android:
```bash
# Build APK
flutter build apk --release

# Or App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/
```

#### iOS:
```bash
# Build IPA
flutter build ios --release

# Output: build/ios/Release-iphoneos/
```

## Phase 4: Deployment (Optional)

### Deploy Backend

#### Option A: Heroku (Free tier deprecated, use Railway)

1. **Create Railway Account**
   - Go to https://railway.app
   - Sign up with GitHub

2. **Deploy**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git push railway main
   ```

3. **Update Flutter App**
   ```dart
   // lib/services/api_service.dart
   static const String BASE_URL = 'https://your-railway-url.up.railway.app';
   ```

#### Option B: AWS, Google Cloud, or Azure
- Upload backend to respective cloud platforms
- Update API endpoint in Flutter app

### Deploy Flutter App

#### Google Play Store:
1. Create developer account ($25)
2. Build signed APK/Bundle
3. Upload to Play Store Console
4. Fill store listing details
5. Submit for review (~24-48 hours)

#### Apple App Store:
1. Create Apple Developer account ($99/year)
2. Build signed IPA
3. Upload via App Store Connect
4. Fill app details
5. Submit for review (~24-48 hours)

## Troubleshooting

### Common Issues & Solutions

#### Model Loading Errors
```
Error: Failed to load model
```
**Solution**: Ensure assets exist in `flutter_app/assets/` and `pubspec.yaml` has correct paths

#### Firebase Initialization Errors
```
Error: Firebase initialization failed
```
**Solution**: Run `flutterfire configure` and verify google-services.json

#### TFLite Interpreter Errors
```
Error: Model not allocated
```
**Solution**: Call `_tflite.loadModel()` in initState before using

#### API Connection Errors
```
Error: Connection refused
```
**Solution**: 
- Verify backend is running
- Check correct IP/URL for your device type
- Ensure device can reach backend IP

#### Permission Denied Errors
```
Error: Camera permission denied
```
**Solution**: 
- Grant permissions in app settings
- For emulator: adb shell pm grant package_name permission_name

#### Weather API Errors
```
Error: Failed to load weather
```
**Solution**: 
- Verify API key is correct
- Check internet connectivity
- Ensure location permissions granted

## Next Steps

1. **Test thoroughly** with different plant images
2. **Gather user feedback** on accuracy and UX
3. **Fine-tune model** with new/better dataset if needed
4. **Add more disease types** by retraining with larger dataset
5. **Implement Firestore database** for storing user predictions
6. **Add social features** (share results, community tips)
7. **Optimize for battery** (reduce model size, inference frequency)

## Support Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [TensorFlow Lite Guide](https://www.tensorflow.org/lite/guide)
- [Firebase Setup](https://firebase.flutter.dev/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

---

**Happy coding! 🌱**
