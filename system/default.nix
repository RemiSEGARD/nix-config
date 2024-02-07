{ pkgs, lib, system, inputs, ... }:
{
  laptopn5 = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit pkgs lib system inputs; };
    modules = [ ./laptopn5/configuration.nix ];
  };
  vm = lib.nixosSystem {
    inherit system;
    modules = [ ./vm/configuration.nix ];
  };
}
