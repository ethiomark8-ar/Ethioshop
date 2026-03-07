# IDX Project Configuration

## Overview

This directory contains IDX (Firebase Studio) configuration files for the EthioShop Flutter project.

## Configuration Files

- `configuration.json` - Main IDX project configuration including extensions, tasks, and debugging setup
- `gitignore` - IDX-specific ignore rules for Firebase Studio integration

## Features Configured

### Extensions
- Dart-Code.flutter - Flutter language support
- Dart-Code.dart-code - Dart language support
- eamodio.gitlens - Git integration
- esbenp.prettier-vscode - Code formatting
- usernamehw.errorlens - Inline error display
- Gruntfuggly.todo-tree - TODO tracking
- pkief.material-icon-theme - Material design icons
- yzhang.markdown-all-in-one - Markdown support

### Tasks
- **setup** - Install Flutter dependencies
- **run** - Run app in Chrome browser
- **run-android** - Run on Android emulator
- **test** - Run all tests with coverage
- **analyze** - Analyze code for issues
- **build-web** - Build web release
- **build-android** - Build Android APK
- **clean** - Clean build artifacts

### Debugging Configurations
- Flutter (debug mode)
- Flutter (profile mode)
- Flutter (release mode)

### Workspaces
- Flutter App - Main application code
- Tests - Test files and test infrastructure
- Web Assets - Web-specific files
- Resources - Images, icons, and fonts

### Ports
- **8080** - Web application preview
- **9099** - Firebase emulator
- **5037** - Android Debug Bridge

## AI Features

- Codebase context awareness
- Documentation integration
- Dependency analysis
- Code completion suggestions
- Code explanation
- Bug detection

## Environment Variables

- `ETHIOSHOP_ENV` - Development environment
- `FIREBASE_PROJECT_ID` - Firebase project identifier
- `FLUTTER_WEB_RENDERER` - Web renderer (canvaskit)

## Indexing

IDX automatically indexes:
- All Dart files in `lib/` and `test/`
- Web assets in `web/`
- Resources in `assets/`
- Excludes build artifacts and generated files

## Usage

1. Open this project in IDX (Firebase Studio)
2. IDX will automatically load the configuration
3. Use the Tasks panel to run common operations
4. Use the Debug panel to launch the app
5. Use the Extensions panel to manage VS Code extensions

## Firebase Integration

This project is configured for Firebase integration with:
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Cloud Functions
- Firebase Hosting
- Cloud Messaging

## Additional Resources

- [IDX Documentation](https://firebase.google.com/docs/studio)
- [Flutter Documentation](https://flutter.dev/docs)
- [EthioShop README](../README.md)