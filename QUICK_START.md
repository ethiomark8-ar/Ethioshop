# EthioShop - Quick Start Guide

Get EthioShop up and running in minutes with this quick start guide.

## 🚀 Prerequisites Check

Before starting, ensure you have:
- [ ] Flutter SDK 3.22+ installed
- [ ] Dart SDK 3.4+ installed
- [ ] Android Studio or VS Code with Flutter extension
- [ ] A Firebase account
- [ ] Git installed

## ⚡ Quick Setup (5 Minutes)

### 1. Get the Code

```bash
git clone https://github.com/yourusername/ethioshop.git
cd ethioshop
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device/emulator
flutter run
```

**That's it!** The app should now be running on your device.

## 🔥 Basic Usage

### For Testing Without Firebase

The app includes mock data providers, so you can test the UI without Firebase:

1. **Home Screen**: Browse featured and trending products
2. **Product Detail**: Tap any product to see details
3. **Search**: Use the search icon to find products
4. **Cart**: Add products to cart from product detail
5. **Wishlist**: Tap the heart icon to save products
6. **Notifications**: View sample notifications
7. **Profile**: View profile screen

### Navigation

- **Home**: Main dashboard with products
- **Cart**: Shopping cart with items
- **Search**: Find products with filters
- **Wishlist**: Saved products
- **Notifications**: Alerts and updates
- **Profile**: User settings and account

## 🔧 Minimal Firebase Setup (15 Minutes)

To enable real functionality, set up Firebase:

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name it "ethioshop"
4. Follow the setup wizard

### 2. Add Android App

1. In Firebase Console, click Android icon
2. Package name: `com.ethioshop.app`
3. Download `google-services.json`
4. Place in `android/app/`
5. Follow the setup instructions

### 3. Enable Services

Enable these services in Firebase Console:

**Authentication**:
- Go to Authentication > Sign-in method
- Enable "Email/Password"

**Firestore Database**:
- Go to Firestore Database
- Click "Create database"
- Choose a location
- Start in "Test mode" for development

**Storage**:
- Go to Storage
- Click "Get Started"
- Choose "Start in Test mode"

**Cloud Messaging**:
- Go to Cloud Messaging
- Note your Sender ID

### 4. Update Firebase Config

Edit `lib/core/config/firebase_options.dart`:

Replace placeholder values with your actual Firebase configuration keys from the Firebase Console.

### 5. Run Again

```bash
flutter run
```

Now the app will use real Firebase services!

## 📱 Testing on Different Platforms

### Android

```bash
# Run on connected Android device
flutter run -d android

# Build APK
flutter build apk --release

# Install APK
flutter install
```

### iOS (macOS only)

```bash
cd ios
pod install
cd ..
flutter run -d ios
```

### Web

```bash
flutter run -d chrome
```

## 🎨 Customization

### Change App Name

Edit `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Change Theme Colors

Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryGreen = Color(0xFFYOUR_COLOR);
```

### Change Currency

Edit `lib/core/constants/app_constants.dart`:
```dart
static const String currency = 'YOUR_CURRENCY';
static const String currencySymbol = 'YOUR_SYMBOL';
```

## 🔍 Debugging

### Enable Logging

The app uses the `logger` package. Check the console for logs.

### Common Issues

**Issue: "flutter pub get" fails**
```bash
# Clean and retry
flutter clean
flutter pub get
```

**Issue: Firebase not connecting**
- Check internet connection
- Verify `google-services.json` is in correct location
- Check Firebase Console for configuration

**Issue: App crashes on startup**
- Check Flutter version: `flutter --version`
- Update Flutter: `flutter upgrade`
- Check device logs: `flutter logs`

## 📚 Next Steps

After basic setup:

1. **Read the full documentation**: Check [README.md](README.md)
2. **Explore the code**: Look at the folder structure
3. **Customize features**: Modify screens and providers
4. **Add Firebase**: Enable real backend services
5. **Test thoroughly**: Try all features

## 🆘 Need Help?

- **Documentation**: [README.md](README.md)
- **Project Status**: [PROJECT_STATUS.md](PROJECT_STATUS.md)
- **Issues**: Open an issue on GitHub
- **Community**: Join our Discord server

## ✅ Checklist

Before deploying to production:

- [ ] All dependencies updated
- [ ] Firebase properly configured
- [ ] All features tested
- [ ] Error handling implemented
- [ ] Security rules configured
- [ ] Performance optimized
- [ ] User testing completed
- [ ] Documentation updated

## 🎯 What's Included in This Build

### Core Features ✅
- Beautiful Material 3 UI
- Home screen with products
- Product detail pages
- Shopping cart
- Wishlist
- Search with filters
- User profile
- Notifications

### Architecture ✅
- Clean Architecture
- Riverpod state management
- Go Router navigation
- Firebase integration ready
- Offline support with Hive

### What's Coming 🔜
- Checkout and payments
- Order tracking
- Chat system
- Reviews
- Admin dashboard
- Seller features

---

**Ready to build something amazing? Start coding!** 🚀