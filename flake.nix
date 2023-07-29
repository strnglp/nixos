{
  description = "strangeloop - root flake.nix";

# nixConfig is an attribute set of values which reflect the values given to nix.conf. 
# This can extend the normal behavior of a user's nix experience by adding flake-specific configuration, 
# such as a binary cache.
  nixConfig = {
# Enable flakes
    experimental-features = [ "nix-command" "flakes" ];
# Nixos packages binary cache
    subbstituters = [ "https://cache.nixos.org" ];
  };

# inputs is an attribute set of all the dependencies of the flake
# All flake/channel dependencies must be defined here.
  inputs = {
# Let packages move forward beyond the most recent nixos release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
# Use Home Manager for per user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };


# outputs is a function of one argument that takes an attribute set of all the realized inputs, 
# and outputs another attribute
  outputs = { nixpkgs, ... } @inputs: 
    let
    lib = nixpkgs.lib;
  in
  {

    nixosConfigurations = {
# Define a host and related system+user configurations. Build using a flake command.
# e.g. (/etc/nixos)$ sudo nixos-rebuild switch --flake .#thinkpad
      thinkpad = lib.nixosSystem {
        system = "x68_64-linux";
# Passes through a defined set to all modules
        specialArgs = { inherit inputs; };
# Make inputs and the flake itself accessible as module parameters.
# Technically, adding the inputs is redundant as they can be also
# accessed with flake-self.inputs.X, but adding them individually
# allows to only pass what is needed to each module.
#        specialArgs = { flake-self = self; } // inputs;

# Define all modules to load for this system
        modules = [
# hardware specific configuration
          ./host/thinkpad
# system base configuration
            ./system/gnome
# add strangeloop user
            ./user/strangeloop
        ];
      };
    };
  };
}
