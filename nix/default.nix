
let 
  sources = import ./sources.nix;
in
import sources.nixpkgs
  # { 
  #   overlays = [ overlay ] ; 
  #   # config = {}; 
  #   }