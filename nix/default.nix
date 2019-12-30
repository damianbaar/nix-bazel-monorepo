{ sources ? import ./sources.nix }:     
with
  { overlay = self: super:
      { niv = import sources.niv {};    
        testScript = super.writeScriptBin "test-script-nix" ''
          echo "I'm from Nix!"
        '';
      };
  };
import sources.nixpkgs
  { overlays = [ overlay ] ; config = {}; }