{ sources ? import ./sources.nix, system ? builtins.currentSystem }:     
with
  { overlay = self: super:
      { niv = import sources.niv {};    
        dhall-haskell = import sources.dhall-haskell;
        testScript = super.writeScriptBin "test-script-nix" ''
          echo "I'm from Nix!"
        '';
        nix-container-overlay = (import "${sources.nix-container-images}/overlay.nix");
        testScriptWithDeps = 
          let
            name = "test-script-with-deps-nix";
            destination = "/bin/${name}";
            text = ''
              ${super.figlet}/bin/figlet test
            '';
          in
            super.runCommand "${name}" {
              executable = true; 
              buildInputs = [super.figlet];
            } ''
              n=$out${destination}
              mkdir -p "$(dirname "$n")"
              echo -n "${text}" > "$n"
            '';
      };
  };
import sources.nixpkgs
  { 
    inherit system;
    overlays = [ overlay ] ; 
  }