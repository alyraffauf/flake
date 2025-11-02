{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinModules.default = ../darwin;

    nixosConfigurations =
      inputs.nixpkgs.lib.genAttrs [
        # Put hostnames here.
      ] (
        host:
          inputs.nix-darwin.lib.darwinSystem {
            modules = [
              ../../hosts/${host}
              inputs.home-manager.nixosModules.home-manager
              self.darwinModules.default

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
