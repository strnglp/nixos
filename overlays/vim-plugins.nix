self: super:
{
  vimPlugins = super.vimPlugins // {
    auto-dark-mode-nvim = self.vimUtils.buildVimPluginFrom2Nix {
      pname = "auto-dark-mode-nvim";
      version = "0.1";
      src = self.fetchFromGitHub {
        owner = "strnglp";
        repo = "auto-dark-mode.nvim";
        rev = "e1a8f11";
        sha256 = "iS7x3kiny6IgRK+v5mlKdtQ4+99swsUQhyNGtt6+fKo=";
      };
    };
  };
}
