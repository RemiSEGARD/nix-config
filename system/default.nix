{ pkgs, lib, system, ... }:
{
  laptopn5 = lib.nixosSystem {
    inherit system;
    modules = [ ./laptopn5/configuration.nix ];
  };
  vm = lib.nixosSystem {
    inherit system;
    modules = [ ./vm/configuration.nix ];
  };
}
