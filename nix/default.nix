{ sources ? import ./sources.nix }:     
with
  { overlay = self: super:
      { niv = import sources.niv {};    
        dhall-haskell = import sources.dhall-haskell;
        testScript = super.writeScriptBin "test-script-nix" ''
          echo "I'm from Nix!"
        '';
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
  { overlays = [ overlay ] ; config = {}; }