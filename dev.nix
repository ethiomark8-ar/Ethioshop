{
  description = "EthioShop Development Environment for Firebase Studio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    firebase-tools = {
      url = "github:GoogleCloudPlatform/firebase-tools-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, android-nixpkgs, firebase-tools }:
    flake-utils.lib.eachDefaultSystemMap (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        android = android-nixpkgs.packages.${system};
        
        # Flutter version configuration
        flutterVersion = "3.24.0";
        dartVersion = "3.5.0";
        
        # Android SDK configuration
        androidComposition = android.sdk (
          pkgs.androidenv.composeAndroidPackages {
            buildToolsVersions = [ "34.0.0" "33.0.0" ];
            platformVersions = [ "34" "33" ];
            abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" ];
            includeEmulator = true;
            includeNDK = true;
            includeSystemImages = true;
            cmakeVersions = [ "3.22.1" ];
          }
        );
        
        # Firebase Tools integration
        firebaseShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Flutter and Dart
            flutter
            dart
            
            # Android development
            androidComposition.androidsdk
            jdk17
            
            # Firebase Tools
            firebase-tools.packages.${system}.firebase-tools
            
            # Build tools
            gradle_7
            cmake
            ninja
            pkg-config
            
            # Version control
            git
            git-lfs
            
            # Code quality
            dartfmt
            dartfix
            
            # Testing
            flutter.unwrapped.test
            
            # Web development
            nodejs_20
            npm
            
            # Firebase specific tools
            firebase-tools
            
            # Utilities
            curl
            wget
            unzip
            zip
            which
            file
            ripgrep
            fd
            jq
            yq
            fzf
            bat
            eza
            zoxide
          ];
          
          shellHook = ''
            # Set up environment variables
            export ANDROID_HOME="${androidComposition.androidsdk}/libexec/android-sdk"
            export ANDROID_SDK_ROOT="$ANDROID_HOME"
            export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/25.2.9519653"
            export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"
            
            # Flutter environment
            export FLUTTER_ROOT="${pkgs.flutter}"
            export PATH="$FLUTTER_ROOT/bin:$PATH"
            
            # Dart environment
            export DART_ROOT="${pkgs.dart}"
            export PATH="$DART_ROOT/bin:$PATH"
            
            # Java environment for Android builds
            export JAVA_HOME="${pkgs.jdk17}"
            export PATH="$JAVA_HOME/bin:$PATH"
            
            # Firebase Tools
            export FIREBASE_PROJECT_ID="ethioshop-production"
            export FIREBASE_DEFAULT_REGION="europe-west1"
            
            # Enable Gradle daemon for faster builds
            export GRADLE_OPTS="-Dorg.gradle.daemon=true -Dorg.gradle.parallel=true -Dorg.gradle.caching=true"
            
            # EthioShop specific environment
            export ETHIOSHOP_ENV="development"
            export ETHIOSHOP_VERSION="1.0.0"
            
            # Development tools
            export EDITOR="vim"
            export VISUAL="vim"
            
            # Firebase Studio Integration
            export FIREBASE_STUDIO_ENABLED="true"
            export FIREBASE_INDEXING_ENABLED="true"
            
            # Path additions
            export PATH="$PATH:$HOME/.local/bin"
            
            echo "🇪🇹 Welcome to EthioShop Development Environment!"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "Flutter: ${flutterVersion}"
            echo "Dart: ${dartVersion}"
            echo "Java: ${pkgs.jdk17.version}"
            echo "Android SDK: Ready"
            echo "Firebase Tools: Ready"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "Available commands:"
            echo "  • firebase           - Firebase CLI"
            echo "  • flutter           - Flutter CLI"
            echo "  • dart              - Dart CLI"
            echo "  • adb               - Android Debug Bridge"
            echo "  • gradle            - Gradle build tool"
            echo "  • emulator          - Android Emulator"
            echo ""
            echo "Firebase commands:"
            echo "  • firebase init     - Initialize Firebase project"
            echo "  • firebase deploy   - Deploy to Firebase"
            echo "  • firebase serve    - Serve locally"
            echo "  • firebase functions:shell - Functions shell"
            echo ""
            echo "Flutter commands:"
            echo "  • flutter run       - Run app"
            echo "  • flutter build     - Build app"
            echo "  • flutter test      - Run tests"
            echo "  • flutter analyze   - Analyze code"
            echo ""
            echo "Development aliases (defined in shell):"
            echo "  • ethio-clean       - Clean build artifacts"
            echo "  • ethio-deps        - Install dependencies"
            echo "  • ethio-test        - Run tests"
            echo "  • ethio-build       - Build release"
            echo "  • ethio-deploy      - Deploy to Firebase"
            echo ""
            
            # Custom aliases
            alias ethio-clean='flutter clean && rm -rf build/ .dart_tool/'
            alias ethio-deps='flutter pub get'
            alias ethio-test='flutter test --coverage'
            alias ethio-analyze='flutter analyze --fatal-infos --fatal-warnings'
            alias ethio-build-android='flutter build apk --release'
            alias ethio-build-web='flutter build web --release'
            alias ethio-deploy='firebase deploy'
            alias ethio-serve='firebase serve'
            alias ethio-emulator='firebase emulators:start'
            alias ethio-functions='firebase functions:shell'
            alias ethio-logs='firebase functions:log'
            alias ethio-status='firebase status'
          '';
        };
      in
      {
        devShells.default = firebaseShell;
        
        # Firebase deployment apps
        apps = {
          firebase-deploy = {
            type = "app";
            program = toString (pkgs.writeShellScriptBin "firebase-deploy" ''
              echo "🚀 Deploying EthioShop to Firebase..."
              firebase deploy --only hosting,functions,firestore,storage
              echo "✅ Deployment completed!"
            '');
          };
          
          firebase-emulate = {
            type = "app";
            program = toString (pkgs.writeShellScriptBin "firebase-emulate" ''
              echo "🔥 Starting Firebase Emulators..."
              firebase emulators:start --import=./firebase-emulator-data
            '');
          };
          
          firebase-logs = {
            type = "app";
            program = toString (pkgs.writeShellScriptBin "firebase-logs" ''
              echo "📋 Viewing Firebase Logs..."
              firebase functions:log --only ethioshop-production
            '');
          };
        };
      }
    );
}