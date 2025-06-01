{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = {
        nixpkgs,
        flake-utils,
        ...
    }: flake-utils.lib.eachSystem ["x86_64-linux"] (system:
        let
            pkgs = import nixpkgs {
                inherit system;
            };

            slstatus = (with pkgs; stdenv.mkDerivation {
                pname = "slstatus";
                version = "1.1";

                src = ./.;
               
                nativeBuildInputs = [ pkg-config ];
                buildInputs = with xorg; [
                  libX11
                  libXau
                  libXdmcp
                ];
               
                installFlags = [ "PREFIX=$(out)" ];
               
                passthru.updateScript = gitUpdater { };
            });
        in {
          defaultPackage = slstatus;
        }
    );
}
