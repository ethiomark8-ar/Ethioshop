{ pkgs, ... }: {
  channel = "unstable";
  
  packages = [
    # Core SDKs
    pkgs.flutter
    pkgs.jdk17
    
    # Node & Firebase for MCP and Backend
    pkgs.nodejs_20
    pkgs.nodePackages.firebase-tools
    
    # Linux/FFI Build Toolchain (Strictly required for packages like geolocator, path_provider, and hive)
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.glib
  ];

  env = {};

  idx = {
    extensions = [
      "dart-code.flutter"
      "dart-code.dart-code"
      "ubuntu.ubuntu-theme" 
    ];
    
    workspace = {
      # Runs once when the workspace is first created
      onCreate = {
        pub-get = "flutter pub get";
        setup-mcp = "cd .mcp-server && npm install";
      };
      # Runs every time the workspace is spun up
      onStart = {
        build-mcp = "cd .mcp-server && npm run build";
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
  };
}
