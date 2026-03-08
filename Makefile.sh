# EthioShop Makefile
# Convenient commands for development and deployment

.PHONY: help clean get test analyze build-android build-web deploy-web run release

# Default target
help:
	@echo "🇪🇹 EthioShop - Ethiopia's Premier Marketplace"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Available commands:"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make get           - Install dependencies"
	@echo "  make test          - Run all tests"
	@echo "  make analyze       - Run static analysis"
	@echo "  make build-android - Build Android APK"
	@echo "  make build-web     - Build web application"
	@echo "  make deploy-web    - Deploy to production"
	@echo "  make run           - Run app in debug mode"
	@echo "  make release       - Build release APK and bundle"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf android/.gradle/
	rm -rf ios/Pods/
	rm -rf web/.dart_tool/
	@echo "✅ Clean completed!"

# Install dependencies
get:
	@echo "📦 Installing dependencies..."
	flutter pub get
	@echo "✅ Dependencies installed!"

# Run tests
test:
	@echo "🧪 Running tests..."
	flutter test --coverage
	@echo "✅ Tests completed!"
	@echo "📊 Coverage report: coverage/lcov.info"

# Run specific test
test-unit:
	@echo "🧪 Running unit tests..."
	flutter test test/unit
	@echo "✅ Unit tests completed!"

test-widget:
	@echo "🧪 Running widget tests..."
	flutter test test/widget
	@echo "✅ Widget tests completed!"

test-integration:
	@echo "🧪 Running integration tests..."
	flutter test test/integration
	@echo "✅ Integration tests completed!"

# Run static analysis
analyze:
	@echo "🔍 Running static analysis..."
	flutter analyze --fatal-infos --fatal-warnings
	@echo "✅ Analysis completed!"

# Format code
format:
	@echo "✨ Formatting code..."
	dart format .
	@echo "✅ Code formatted!"

# Build Android APK
build-android:
	@echo "🏗️  Building Android APK..."
	flutter build apk --release
	@echo "✅ Build completed!"
	@echo "📱 APK: build/app/outputs/flutter-apk/app-release.apk"

# Build Android App Bundle
build-aab:
	@echo "🏗️  Building Android App Bundle..."
	flutter build appbundle --release
	@echo "✅ Build completed!"
	@echo "📱 Bundle: build/app/outputs/bundle/release/app-release.aab"

# Build web application
build-web:
	@echo "🌐 Building web application..."
	flutter build web --release --web-renderer canvaskit
	@echo "✅ Build completed!"
	@echo "🌍 Web: build/web/"

# Build iOS (macOS only)
build-ios:
	@echo "🍎 Building iOS application..."
	flutter build ios --release
	@echo "✅ Build completed!"

# Run app in debug mode
run:
	@echo "🚀 Running app in debug mode..."
	flutter run

# Run on specific device
run-android:
	@echo "📱 Running on Android..."
	flutter run -d android

run-web:
	@echo "🌐 Running on web..."
	flutter run -d chrome

# Install dependencies for all platforms
deps:
	@echo "📦 Installing all dependencies..."
	flutter pub get
	cd android && ./gradlew build
	cd ios && pod install
	@echo "✅ All dependencies installed!"

# Check for outdated dependencies
outdated:
	@echo "📋 Checking for outdated dependencies..."
	flutter pub outdated

# Upgrade dependencies
upgrade:
	@echo "⬆️  Upgrading dependencies..."
	flutter pub upgrade
	@echo "✅ Dependencies upgraded!"

# Generate code
generate:
	@echo "🔧 Generating code..."
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "✅ Code generated!"

# Run code generation watch
generate-watch:
	@echo "👀 Watching for code changes..."
	flutter pub run build_runner watch --delete-conflicting-outputs

# Build Docker image
docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t ethioshop:latest .
	@echo "✅ Docker image built!"

# Run Docker container
docker-run:
	@echo "🐳 Running Docker container..."
	docker run -p 80:80 ethioshop:latest

# Deploy to production
deploy-web:
	@echo "🚀 Deploying to production..."
	flutter build web --release
	@echo "✅ Ready for deployment!"
	@echo "📦 Upload build/web/ to your hosting provider"

# Create release
release: clean get test analyze build-android build-aab
	@echo "🎉 Release build completed!"
	@echo "📦 APK and AAB are ready for distribution"

# Show project stats
stats:
	@echo "📊 Project Statistics:"
	@echo "Lines of Dart code: $$(find lib -name '*.dart' | xargs wc -l | tail -1 | awk '{print $$1}')"
	@echo "Number of Dart files: $$(find lib -name '*.dart' | wc -l)"
	@echo "Number of tests: $$(find test -name '*.dart' | wc -l)"