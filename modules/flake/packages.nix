_: {
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    packages = {
      gen-files = pkgs.writeShellApplication {
        name = "render-files";

        text = ''
          ${lib.getExe config.files.writer.drv}
        '';
      };
    };
  };
}
