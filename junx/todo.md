# EthioShop Flutter Enterprise Project Setup

## Task 1: Fix Android folder according to google-services.json
- [x] Update package name from `com.ethioshop.app` to `com.ethio.shop` in build.gradle
- [x] Update namespace in build.gradle
- [x] Update AndroidManifest.xml package attribute
- [x] Fix MainActivity.kt package and move to correct directory structure
- [x] Clean up duplicate MainActivity.kt files

## Task 2: Place launcher icons in correct mipmap and drawable directories
- [x] Copy launcher icons to mipmap directories (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- [x] Copy adaptive icon foreground images to mipmap directories
- [x] Copy adaptive icon background images to mipmap directories
- [x] Create adaptive icon XML files in drawable directories
- [x] Create round icon versions

## Task 3: Create build workflow for APK and debug APK
- [x] Create .github/workflows/build.yml for CI/CD
- [x] Configure debug APK build workflow
- [x] Configure release APK build workflow
- [x] Add build signing configuration

## Task 4: Deploy on idx.google.com (Project IDX setup)
- [x] Create dev.nix configuration file
- [x] Create .idx/configuration.json
- [x] Verify and update .mcp folder configuration
- [x] Create idx.yaml

## Additional files needed for Android
- [x] Create colors.xml for notification color
- [x] Create file_paths.xml for FileProvider
- [x] Create strings.xml for Facebook configuration
- [x] Create ic_notification drawable
- [x] Create styles.xml with NormalTheme