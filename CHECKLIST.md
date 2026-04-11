# AgriCure - Implementation Checklist

Use this checklist to track your progress through the AgriCure setup.

## 📋 Pre-Requisites

- [ ] Python 3.8+ installed
- [ ] Flutter 3.0+ installed
- [ ] Git installed (for version control)
- [ ] Android Studio OR Xcode installed
- [ ] Internet connection (stable)
- [ ] Kaggle account (for dataset)
- [ ] Google account (for Drive + Firebase)
- [ ] OpenWeatherMap account

## Phase 1: Environment Setup

### Python Environment
- [ ] Python installed and verified (`python --version`)
- [ ] pip updated (`pip install --upgrade pip`)
- [ ] Virtual environment created (`python -m venv backend/venv`)
- [ ] Virtual environment activated

### Flutter Environment
- [ ] Flutter installed (`flutter --version`)
- [ ] Dart installed (comes with Flutter)
- [ ] Android SDK installed (via Android Studio)
- [ ] iOS SDK installed (macOS only)
- [ ] XCode Command Line Tools installed (macOS)
- [ ] `flutter doctor` shows no critical errors

## Phase 2: Backend Setup

### Dataset Preparation
- [ ] Kaggle account created
- [ ] New Plant Diseases Dataset downloaded (~3-4 GB)
- [ ] Dataset extracted (train/ and valid/ folders)
- [ ] Google Drive account verified
- [ ] Public folder created on Google Drive
- [ ] train/ and valid/ folders uploaded to Drive
- [ ] Folder ID copied from Drive URL

### Backend Configuration
- [ ] `backend/` directory created
- [ ] `requirements.txt` file present
- [ ] `train_model.py` file present
- [ ] `app.py` file present
- [ ] `DRIVE_FOLDER_ID` updated in `train_model.py`
- [ ] All dependencies installed (`pip install -r requirements.txt`)

### Model Training
- [ ] Training script started (`python train_model.py`)
- [ ] Dataset downloading... (wait 5-10 min)
- [ ] Training started (GPU recommended)
- [ ] Training completed (~30-60 min)
- [ ] Training graphs generated
- [ ] No errors in console
- [ ] Output files verified:
  - [ ] `flutter_app/assets/model.tflite` (~15-20 MB)
  - [ ] `flutter_app/assets/labels.txt`
  - [ ] `flutter_app/assets/remedies.json`
  - [ ] `flutter_app/assets/accuracy_graph.png`
  - [ ] `flutter_app/assets/loss_graph.png`

### Backend Server
- [ ] Backend server started (`uvicorn app:app --reload`)
- [ ] Server running on port 8000
- [ ] Health check working (`curl http://localhost:8000/health`)
- [ ] API documentation accessible (`http://localhost:8000/docs`)

## Phase 3: Firebase Setup

### Firebase Project
- [ ] Firebase project created (console.firebase.google.com)
- [ ] Project named appropriately
- [ ] Billing account connected (if needed)
- [ ] Firebase Authentication enabled
- [ ] Email/Password auth method enabled

### Android Configuration
- [ ] Android app added to Firebase
- [ ] Package name set: `com.example.agricare`
- [ ] `google-services.json` downloaded
- [ ] File placed in `android/app/google-services.json`
- [ ] `flutterfire_cli` installed (`dart pub global activate flutterfire_cli`)
- [ ] `flutterfire configure` completed

### iOS Configuration
- [ ] iOS app added to Firebase (macOS only)
- [ ] Bundle ID: `com.example.agricare`
- [ ] `GoogleService-Info.plist` downloaded
- [ ] File added to Xcode project
- [ ] `flutterfire configure --platforms ios` completed

### Firebase Options
- [ ] `lib/firebase_options.dart` updated with credentials
- [ ] All required fields filled in:
  - [ ] apiKey
  - [ ] appId
  - [ ] messagingSenderId
  - [ ] projectId
  - [ ] authDomain
  - [ ] databaseURL
  - [ ] storageBucket

## Phase 4: Flutter Setup

### Project Structure
- [ ] `flutter_app/` directory verified
- [ ] `lib/` directory present
- [ ] `assets/` directory present
- [ ] `pubspec.yaml` file present
- [ ] All service files present:
  - [ ] `services/auth_service.dart`
  - [ ] `services/tflite_service.dart`
  - [ ] `services/weather_service.dart`
  - [ ] `services/api_service.dart`
  - [ ] `services/scheduler_service.dart`
- [ ] All screen files present:
  - [ ] `screens/auth_wrapper.dart`
  - [ ] `screens/login_screen.dart`
  - [ ] `screens/home_screen.dart`
  - [ ] `screens/profile_screen.dart`
  - [ ] `screens/scheduler_screen.dart`
  - [ ] `screens/weather_screen.dart`
  - [ ] `screens/main_tabs.dart`

### Dependencies
- [ ] `flutter pub get` completed
- [ ] No dependency conflicts
- [ ] All packages installed:
  - [ ] firebase_core
  - [ ] firebase_auth
  - [ ] tflite_flutter
  - [ ] image_picker
  - [ ] camera
  - [ ] flutter_local_notifications
  - [ ] http
  - [ ] geolocator
  - [ ] permission_handler

### API Configuration
- [ ] OpenWeatherMap account created
- [ ] API key obtained
- [ ] `weather_service.dart` updated with API key
- [ ] Backend URL verified in `api_service.dart`
- [ ] URL updated for your setup:
  - [ ] Emulator: `http://10.0.2.2:8000`
  - [ ] Device: `http://YOUR_IP:8000`

### Asset Files
- [ ] `assets/model.tflite` present
- [ ] `assets/labels.txt` present
- [ ] `assets/remedies.json` present
- [ ] `assets/accuracy_graph.png` present (optional)
- [ ] `assets/loss_graph.png` present (optional)
- [ ] `pubspec.yaml` asset paths correct

## Phase 5: Platform Setup

### Android Setup
- [ ] Android emulator created or device connected
- [ ] Minimum SDK set to API 21
- [ ] Target SDK set to API 34
- [ ] Permissions configured in AndroidManifest.xml:
  - [ ] Camera
  - [ ] Internet
  - [ ] Location
  - [ ] Storage
- [ ] Development signing certificate created

### iOS Setup (macOS only)
- [ ] iOS simulator available or device connected
- [ ] Xcode Command Line Tools installed
- [ ] `pod install` completed
- [ ] iOS deployment target set to 11.0+
- [ ] Signing team configured

## Phase 6: Testing

### Pre-Flight Checks
- [ ] `flutter doctor` shows no errors
- [ ] All configurations saved
- [ ] Backend server still running (if testing online mode)
- [ ] Device/emulator ready

### App Launch
- [ ] `flutter run` executed
- [ ] App launches without crashes
- [ ] Splash screen appears
- [ ] Login screen loads

### Feature Testing - Authentication
- [ ] Signup with new email/password works
- [ ] Firebase creates user account
- [ ] User is authenticated and logged in
- [ ] Login screen navigates to main app
- [ ] Logout works
- [ ] Can login with existing credentials

### Feature Testing - Disease Detection
- [ ] Home screen loads
- [ ] Camera button works (requires camera permission)
- [ ] Gallery button works
- [ ] Can take/select leaf photo
- [ ] Photo displays in preview
- [ ] TFLite inference runs
- [ ] Disease name displayed
- [ ] Confidence percentage shown
- [ ] Remedy text displayed

### Feature Testing - Profile
- [ ] Profile screen loads
- [ ] User email displayed correctly
- [ ] User ID shown
- [ ] Account creation date shown
- [ ] Logout button works
- [ ] App returns to login screen

### Feature Testing - Scheduler
- [ ] Schedule screen loads
- [ ] Add schedule button works
- [ ] Date/time picker opens
- [ ] Can enter task name
- [ ] Can select date and time
- [ ] Schedule added to list
- [ ] Notification scheduled
- [ ] Delete button works
- [ ] Schedule removed

### Feature Testing - Weather
- [ ] Weather screen loads
- [ ] Location permission requested (if first time)
- [ ] Location permission granted
- [ ] Current weather displayed
- [ ] Temperature shown in °C
- [ ] Humidity percentage shown
- [ ] Wind speed shown
- [ ] Care recommendations displayed
- [ ] Refresh button works

### Feature Testing - Navigation
- [ ] All 4 tabs accessible
- [ ] Switching tabs works
- [ ] App state preserved when switching tabs
- [ ] Bottom navigation bar shows current tab

## Phase 7: Build & Release

### Android Build
- [ ] Debug APK builds: `flutter build apk --debug`
- [ ] APK transfers to device
- [ ] App installs successfully
- [ ] App runs without crashes
- [ ] Release APK builds: `flutter build apk --release`
- [ ] Release APK verified (~50 MB)

### iOS Build (macOS)
- [ ] Debug IPA builds: `flutter build ios --debug`
- [ ] Build succeeds
- [ ] Release IPA builds: `flutter build ios --release`
- [ ] Release IPA verified

### Play Store Preparation
- [ ] Google Play Developer account created ($25)
- [ ] App listing created
- [ ] App name, description, screenshots ready
- [ ] Privacy policy prepared
- [ ] Signing key generated and stored safely
- [ ] Release APK built and signed
- [ ] Ready for upload to Play Store

### App Store Preparation (iOS)
- [ ] Apple Developer account created ($99/year)
- [ ] App ID created
- [ ] App listing created
- [ ] App screenshots and preview prepared
- [ ] Privacy policy updated
- [ ] Signing certificates and provisioning profiles created
- [ ] App built for distribution
- [ ] Ready for upload to App Store

## Phase 8: Deployment (Optional)

### Backend Deployment
- [ ] Railway account created (or preferred platform)
- [ ] Repository pushed to GitHub
- [ ] Backend connected to Railway
- [ ] Environment variables configured
- [ ] Backend deployed successfully
- [ ] Deployment URL obtained
- [ ] Health check working on deployed URL
- [ ] Flutter app updated with new backend URL

### Play Store Publication
- [ ] App uploaded to Play Store Console
- [ ] Store listing completed
- [ ] All required fields filled
- [ ] Screenshots and description added
- [ ] Content rating questionnaire completed
- [ ] App submitted for review
- [ ] Waiting for approval (~24-48 hours)

### App Store Publication (iOS)
- [ ] App uploaded via App Store Connect
- [ ] Store listing completed
- [ ] Screenshots and preview added
- [ ] Content rating questionnaire completed
- [ ] Privacy policy provided
- [ ] App submitted for review
- [ ] Waiting for approval (~24-48 hours)

## Phase 9: Post-Launch

### Monitoring
- [ ] Firebase Analytics configured
- [ ] Crash reporting enabled
- [ ] Error logs monitored
- [ ] User feedback collected

### Maintenance
- [ ] Bug reports tracked
- [ ] Performance monitored
- [ ] User ratings reviewed
- [ ] Feedback implemented

### Enhancement
- [ ] New disease types added (retrain model)
- [ ] UI/UX improvements
- [ ] Additional features planned
- [ ] Community feedback incorporated

## 📊 Progress Summary

Total Items: 150+
- [ ] Completed: ___/150
- [ ] In Progress: ___
- [ ] Not Started: ___

## 📝 Notes

Use this space for your notes and observations:

```
Date Started: ________________
Date Completed: ________________

Backend Training Time: ________________
Issues Encountered: ________________

Customizations Made: ________________

Model Accuracy: ________________%
Test Results: ________________
```

---

## 🎯 Quick Reference

**Starting Point**: QUICK_START.md or IMPLEMENTATION_STEPS.md
**Current Phase**: ___________________
**Next Action**: ___________________
**Blocked By**: ___________________

**Support Files**:
- README.md - Project overview
- QUICK_START.md - 3-step quick guide
- IMPLEMENTATION_STEPS.md - Detailed guide
- BACKEND_SETUP.md - Backend config
- FLUTTER_SETUP.md - Flutter config
- SETUP_SUMMARY.md - Complete summary

---

**Good luck! Mark items as you complete them to track progress. 🌱**
