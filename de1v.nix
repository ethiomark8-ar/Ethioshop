{ pkgs, ... }: {
  channel = "unstable"; # [cite: 12]

  packages = with pkgs; [
    flutter
    dart
    nodejs_20
    firebase-tools
    jdk17
    gradle_8
    # System Utilities
    git
    curl
    unzip
    jq
    yq
    fzf
    zoxide
    eza
  ]; # [cite: 13, 14]

  env = {
    JAVA_HOME = "${pkgs.jdk17}"; # [cite: 15]
    # Use standard IDX paths instead of derived Nix paths
    ANDROID_HOME = "/home/user/Android/Sdk";
    ANDROID_SDK_ROOT = "/home/user/Android/Sdk";
    FIREBASE_PROJECT_ID = "ethioshop-production"; # [cite: 17]
    ETHIOSHOP_ENV = "development"; # [cite: 19]
  };

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
      "sweatless.riverpod-snippets"
      "hilleer.freezed-snippets"
    ]; # [cite: 27]

    workspace = {
      onCreate = {
        pub-get = "flutter pub get"; # [cite: 28]
      };
      onStart = {
        pub-get = "flutter pub get"; 
      };
    };

    previews = {
      enable = true; # [cite: 30]
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter"; # [cite: 31, 32]
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "android"];
          manager = "flutter"; # [cite: 33]
        };
      };
    };
  };

  shellHook = ''
    echo "🇪🇹 Welcome to EthioShop Development Environment!"
    eval "$(zoxide init bash)"
    
    # Fixed Aliases
    alias ethio-clean='flutter clean && rm -rf build/ .dart_tool/'
    alias ethio-deps='flutter pub get'
    alias ethio-emulator='firebase emulators:start'
    alias ethio-deploy='firebase deploy'
    
    echo "✅ Custom 'ethio-*' aliases ready."
  ''; # [cite: 23, 24, 25, 26]
}
