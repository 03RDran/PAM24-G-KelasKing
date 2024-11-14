{
  pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
  name="dev-environment";
  buildInputs = [
    # Node.js
    pkgs.nodejs-18_x

    # Formatters
    pkgs.nodePackages.prettier
  ];
  shellHook =
  ''
    echo "Node.js 18";
    echo "Start developing...";
  '';
}
