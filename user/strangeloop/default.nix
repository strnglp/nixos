{ pkgs, lib, home-manager, ...}:
let
# Define the username once
  user = "strangeloop";
  auto-dark-mode-nvim = pkgs.callPackage ../../packages/vim-plugins {};
in
{
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "123";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
# Per-user Home Manager configuration.
  home-manager.users.${user} = { config, lib, ...}:
  {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "23.05";
      packages = with pkgs; [
# Neovim or programming related
        bundix
        go
        ruby
        rustc
        cargo
        php
        nodejs_20
        zulu
        luajitPackages.luarocks
        python310Packages.pip
        tree-sitter
        gcc_multi
        ripgrep
        nixpkgs-fmt
# Tools
        inotify-tools
        sqlite
# Applications
        discord
      ];
    };

    programs.home-manager.enable = true;

    programs.nix-index =
    {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ./fish/config.fish;
      shellAbbrs = {
        ls = "exa --color=always --icons";
        ll = "exa -al --color=always --icons";
        v = "nvim";
        g = "grep";
        o = "open";
        screenshot = "gnome-screenshot";
      };
    };

    programs.wezterm = {
      enable = true;
      colorSchemes = {
        ModifiedPencilDark = {
          foreground = "#f1f1f1";
          background = "#212121";
          cursor_bg = "#20bbfc";
          cursor_border = "#20bbfc";
          cursor_fg = "#f1f1f1";
          selection_bg = "#b6d6fd";
          selection_fg = "#f1f1f1";

          ansi = [ "#212121" "#c30771" "#10a778" "#a89c14" "#008ec4" "#523c79" "#20a5ba" "#d9d9d9" ];
          brights = [ "#424242" "#fb007a" "#5fd7af" "#f3e430" "#20bbfc" "#6855de" "#4fb8cc" "#f1f1f1" ];

        };
        ModifiedPencilLight = {
          foreground = "#424242";
          background = "#f1f1f1";
          cursor_bg = "#20bbfc";
          cursor_border = "#20bbfc";
          cursor_fg = "#424242";
          selection_bg = "#b6d6fd";
          selection_fg = "#424242";

          ansi = [ "#212121" "#c30771" "#10a778" "#E66E19" "#008ec4" "#523c79" "#20a5ba" "#d9d9d9" ];
          brights = [ "#424242" "#fb007a" "#5fd7af" "#FF6900" "#20bbfc" "#6855de" "#4fb8cc" "#f1f1f1" ];
        };
      };
      extraConfig = builtins.readFile ./wezterm/config.lua;
    };

    programs.neovim = {
      enable = true;
      plugins = [
          auto-dark-mode-nvim
      ] ++ (with pkgs.vimPlugins; [
          nvim-web-devicons
          lsp-format-nvim
          lsp-status-nvim
          mason-nvim
          mason-lspconfig-nvim
          nvim-lspconfig
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          nvim-cmp
          luasnip
          cmp_luasnip
          lspkind-nvim
          plenary-nvim
          null-ls-nvim
          telescope-nvim
          nvim-colorizer-lua
          gitsigns-nvim
          nvim-autopairs
          nvim-treesitter
          nvim-tree-lua
          vim-startify
          lualine-nvim
          vim-colorschemes
          ]);
      extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };

  };

# This has to be defined so Nix adds the correct PATHs
# This is also enabled in the home-manager for the user account
# for setting config via home-manager, there may be a better way
  programs.fish.enable = true;

}
