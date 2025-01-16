{
  description = "My Android project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, flake-utils, android }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system}) android-sdk android-studio;
      };
    }
    //
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ] (system:
      let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            devshell.overlays.default
            self.overlay
          ];
        };

        # Define Android SDK packages
        android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
          build-tools-34-0-0
          cmdline-tools-latest
          emulator
          platform-tools
          platforms-android-34
        ]
        ++ lib.optionals (system == "aarch64-darwin") [
          system-images-android-29-default-arm64-v8a
        ]
        ++ lib.optionals (system == "x86_64-darwin" || system == "x86_64-linux") [
          # Uncomment if needed
          # system-images-android-34-google-apis-x86-64
        ]);

        # Android Studio is available only on x86_64-linux
        android-studio = lib.optionalAttrs (system == "x86_64-linux") {
          android-studio = pkgs.androidStudioPackages.stable;
        };

        # Conditional packages based on system architecture
        conditionalPackages =
          if system != "aarch64-darwin" then [ pkgs.androidStudioPackages.stable ] else [ ];
      in
      {
        packages = {
          inherit android-sdk;
        } // android-studio;

        devShell = pkgs.devshell.mkShell {
          name = "android-project";
          motd = ''
            Entered the Android app development environment.
          '';
          env = [
            {
              name = "ANDROID_HOME";
              value = "${android-sdk}/share/android-sdk";
            }
            {
              name = "ANDROID_SDK_ROOT";
              value = "${android-sdk}/share/android-sdk";
            }
            {
              name = "JAVA_HOME";
              value = pkgs.openjdk17.home;
            }
          ];

          packages = [
            android-sdk
            pkgs.gradle
            pkgs.openjdk17
          ] ++ conditionalPackages;
        };
      }
    );
}
