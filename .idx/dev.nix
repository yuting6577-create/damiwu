
{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = [
    pkgs.flutter
    pkgs.firebase-tools
  ];
  idx.extensions = [ "dart-code.flutter" ];
  idx.workspace = {
    onCreate = {
      configure-firebase = "flutterfire configure";
    };
  };
  idx.previews = {
    enable = true;
    previews = {
      web = {
        command = ["flutter" "run" "--machine" "-d" "web-server" "--web-port" "$PORT" "--web-hostname" "0.0.0.0"];
        manager = "flutter";
      };
    };
  };
}
