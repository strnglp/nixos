{ vimUtils, fetchFromGitHub }:
let
src = fetchFromGitHub {
  owner = "strnglp";
  repo = "auto-dark-mode.nvim";
  rev = "e1a8f11";
  sha256 = "iS7x3kiny6IgRK+v5mlKdtQ4+99swsUQhyNGtt6+fKo=";
};
in
vimUtils.buildVimPluginFrom2Nix {
  pname = "auto-dark-mode-nvim";
  version = "1.0";
  src = src;
}
