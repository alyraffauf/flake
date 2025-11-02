{self, ...}: {
  flake = {
    templates.default = {
      path = self;
      description = "Fully-features flake template with batteries included.";

      welcomeText = ''
        # Aly's Flake Template
        ## Intended usage
        Ideal for multi-output flakes that need to support NixOS, nix-darwin, home-manager, or software projects making extensive use of Nix, formatters, edconfig, etc.
      '';
    };
  };
}
