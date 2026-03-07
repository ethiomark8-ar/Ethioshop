{ pkgs, ... }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
    buildToolsVersions = [ "34.0.0" ];
    abiVersions = [ "x86_64" ];
    includeNDK = true;
  };
in
{
  packages = with pkgs; [

    # Flutter SDK
    flutter
    dart

    # Firebase ecosystem
    nodejs_20
    firebase-tools

    # Android build system
    jdk17
    gradle_8

    # Android SDK
    androidSdk.androidsdk
    androidSdk.platform-tools
    androidSdk.build-tools
    androidSdk.ndk

    # Development tools
    git
    curl
    unzip
    which
    bash
    jq
  ];

  env = {

    # Java
    JAVA_HOME = "${pkgs.jdk17}";

    # Android SDK
    ANDROID_HOME = "${androidSdk.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk.androidsdk}/libexec/android-sdk";

    # Flutter performance
    FLUTTER_WEB_USE_SKIA = "true";

    # Cache optimization
    PUB_CACHE = "$HOME/.pub-cache";
    GRADLE_USER_HOME = "$HOME/.gradle";

    # Gradle optimization
    GRADLE_OPTS = "-Dorg.gradle.daemon=true -Dorg.gradle.parallel=true -Dorg.gradle.jvmargs=-Xmx3g";
  };

  idx = {

    workspace = {

      onCreate = {

        # Check Flutter
        flutter-doctor = "flutter doctor -v";

        # Download Flutter artifacts
        flutter-precache = "flutter precache";

        # Install dependencies
        pub-get = "flutter pub get";

        # Code generation
        build-runner = "dart run build_runner build --delete-conflicting-outputs || true";

      };

      onStart = {

        # Ensure packages installed
        pub-get = "flutter pub get";

      };
    };

    previews = {
      enable = true;

      previews = {

        flutter-web = {
          command = [
            "flutter"
            "run"
            "-d"
            "web-server"
            "--web-port"
            "8080"
            "--web-hostname"
            "0.0.0.0"
          ];
          manager = "web";
        };

      };
    };
  };
}
