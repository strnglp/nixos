self: super:
{
  ProfanityFE = self.pkgs.stdenv.mkDerivation {
    pname = "ProfanityFE";
    version = "0.1";
    src = self.fetchFromGitHub {
      owner = "elanthia-online";
      repo = "ProfanityFE";
      rev = "041e19f";
      sha256 = "9W7Y7ASZdT5FNBplS4yPY3CLzQkVZu35eHdZ7ajYpuo=";
    };
    buildInputs = [ self.pkgs.ruby ];
    propogatedBuildInputs = [ self.pkgs.ruby ];
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
    activationScript = ''
      mkdir -p $HOME/scripts
      ln -sfn $(readlink $HOME/.nix-profile)/bin/ProfanityFE $HOME/scripts/ProfanityFE
  
    '';
  };
}
