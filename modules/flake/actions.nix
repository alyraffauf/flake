{
  lib,
  self,
  ...
}: {
  flake.actions-nix = {
    pre-commit.enable = true; # Set to true if you want pre-commit workflow generation

    workflows = {
      # build-nix.yml
      ".github/workflows/build-nix.yml" = {
        name = "build-nix";
        concurrency = {
          group = "\${{ github.workflow }}-\${{ github.ref }}";
          cancel-in-progress = true;
        };
        on = {
          push = {
            paths = [
              "flake.lock"
              "flake.nix"
              "flake/"
            ];
          };
          workflow_dispatch = {};
        };
        jobs = let
          devShells = lib.attrNames (self.devShells.x86_64-linux or {});
          packages = lib.attrNames (self.packages.x86_64-linux or {});
          devShellJobs = lib.listToAttrs (map
            (name: {
              name = "build-devShell-${name}";
              value = {
                runs-on = "ubuntu-latest";
                steps = [
                  {
                    uses = "actions/checkout@v5";
                    "with" = {fetch-depth = 1;};
                  }
                  {uses = "DeterminateSystems/nix-installer-action@main";}
                  {
                    name = "Build devShell ${name}";
                    run = "nix build --accept-flake-config --print-out-paths .#devShells.x86_64-linux.${name}";
                  }
                ];
              };
            })
            devShells);
          packageJobs = lib.listToAttrs (map
            (name: {
              name = "build-package-${name}";
              value = {
                runs-on = "ubuntu-latest";
                steps = [
                  {
                    uses = "actions/checkout@v5";
                    "with" = {fetch-depth = 1;};
                  }
                  {uses = "DeterminateSystems/nix-installer-action@main";}
                  {
                    name = "Build package ${name}";
                    run = "nix build --accept-flake-config --print-out-paths .#packages.x86_64-linux.${name}";
                  }
                ];
              };
            })
            packages);
        in
          devShellJobs // packageJobs;
      };

      # # build-home-manager.yml
      # ".github/workflows/build-home-manager.yml" = {
      #   name = "build-home-manager";
      #   concurrency = {
      #     cancel-in-progress = true;
      #     group = "\${{ github.workflow }}-\${{ github.ref }}";
      #   };
      #   on = {
      #     push = {
      #       paths-ignore = [
      #         "**/*.md"
      #         ".github/**"
      #         "_img/**"
      #       ];
      #     };
      #     workflow_dispatch = {};
      #   };
      #   jobs =
      #     lib.mapAttrs'
      #     (hostname: config: let
      #       # Auto-detect system from the home configuration
      #       inherit (config.pkgs.stdenv.hostPlatform) system;
      #       # Map system to appropriate runner
      #       runner =
      #         if lib.hasInfix "darwin" system
      #         then "macos-latest"
      #         else if system == "aarch64-linux"
      #         then "ubuntu-24.04-arm"
      #         else "ubuntu-latest";
      #       # Only include free disk space step for ubuntu x86_64
      #       needsFreeDiskSpace = system == "x86_64-linux";
      #     in {
      #       name = "build-${lib.replaceStrings ["@"] ["-"] hostname}";
      #       value = {
      #         runs-on = runner;
      #         steps = lib.flatten [
      #           (lib.optional needsFreeDiskSpace {
      #             name = "Free Disk Space (Ubuntu)";
      #             uses = "jlumbroso/free-disk-space@main";
      #           })
      #           [
      #             {
      #               name = "Checkout";
      #               uses = "actions/checkout@v5";
      #               "with" = {fetch-depth = 1;};
      #             }
      #             {
      #               name = "Install Nix";
      #               uses = "DeterminateSystems/nix-installer-action@main";
      #             }
      #             {
      #               name = "Build ${hostname}";
      #               run = "nix build --accept-flake-config --print-out-paths .#homeConfigurations.${hostname}.activationPackage";
      #             }
      #           ]
      #         ];
      #       };
      #     })
      #     self.homeConfigurations;
      # };

      # build-nixos.yml
      ".github/workflows/build-nixos.yml" = {
        name = "build-nixos";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs =
          lib.mapAttrs'
          (hostname: _: {
            name = "build-${hostname}";
            value = {
              runs-on = "ubuntu-latest";
              steps = [
                {
                  name = "Free Disk Space (Ubuntu)";
                  uses = "jlumbroso/free-disk-space@main";
                }
                {
                  name = "Checkout";
                  uses = "actions/checkout@v5";
                  "with" = {fetch-depth = 1;};
                }
                {
                  name = "Install Nix";
                  uses = "DeterminateSystems/nix-installer-action@main";
                }
                {
                  name = "Build ${hostname}";
                  run = "nix build --accept-flake-config --print-out-paths .#nixosConfigurations.${hostname}.config.system.build.toplevel";
                }
              ];
            };
          })
          self.nixosConfigurations;
      };

      # build-home-manager.yml
      ".github/workflows/build-home-manager.yml" = {
        name = "build-home-manager";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs =
          lib.mapAttrs'
          (hostname: _: {
            name = "build-${lib.replaceStrings ["@"] ["-"] hostname}";
            value = {
              runs-on = "ubuntu-latest";
              steps = [
                {
                  name = "Free Disk Space (Ubuntu)";
                  uses = "jlumbroso/free-disk-space@main";
                }
                {
                  name = "Checkout";
                  uses = "actions/checkout@v5";
                  "with" = {fetch-depth = 1;};
                }
                {
                  name = "Install Nix";
                  uses = "DeterminateSystems/nix-installer-action@main";
                }
                {
                  name = "Build ${hostname}";
                  run = "nix build --accept-flake-config --print-out-paths .#homeConfigurations.${hostname}.activationPackage";
                }
              ];
            };
          })
          self.homeConfigurations;
      };

      # check-nix.yml
      ".github/workflows/check-nix.yml" = {
        name = "check-nix";
        concurrency = {
          cancel-in-progress = true;
          group = "\${{ github.workflow }}-\${{ github.ref }}";
        };
        on = {
          push = {
            paths-ignore = [
              "**/*.md"
              ".github/**"
              "_img/**"
            ];
          };
          workflow_dispatch = {};
        };
        jobs = {
          check-flake = {
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@v5";
                "with" = {fetch-depth = 1;};
              }
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {
                name = "Check flake evaluation";
                run = "nix -Lv flake check --all-systems";
              }
            ];
          };
        };
      };
    };
  };
}
