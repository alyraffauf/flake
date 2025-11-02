{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.default = ../nixos;

    nixosConfigurations = let
      modules = self.nixosModules;
    in
      inputs.nixpkgs.lib.genAttrs [
        # Put hostnames here.
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ../../hosts/${host}
              inputs.home-manager.nixosModules.home-manager
              modules.default

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit self;};
                  backupFileExtension = "backup";
                };

                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = [self.overlays.default];
                };
              }
            ];

            specialArgs = {inherit self;};
          }
      );
  };
}
