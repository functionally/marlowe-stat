{
  pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let

  loopScript = pkgs.writeTextDir "app/loop.sh" (builtins.readFile ./loop.sh);
  allScript = pkgs.writeTextDir "app/all-stats.R" (builtins.readFile ./all-stats.R);
  extScript = pkgs.writeTextDir "app/external-stats.R" (builtins.readFile ./external-stats.R);
  allIndex = pkgs.writeTextDir "app/all/index.html" (builtins.readFile ./index-all.html);
  extIndex = pkgs.writeTextDir "app/ext/index.html" (builtins.readFile ./index-external.html);
  rEnv = with pkgs; rWrapper.override {
    packages = with rPackages; [
      RPostgreSQL
      data_table
      ggplot2
      jsonlite
      lubridate
      scales
    ];
  };

in 

  pkgs.dockerTools.buildImage {
    name = "marlowe-stat";
    tag = "latest";
    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      pathsToLink = [ "/bin" "/app" ];
      paths = [
        loopScript
        allScript
        allIndex
        extScript
        extIndex
        rEnv
        pkgs.bash
        pkgs.coreutils
        pkgs.getent
        pkgs.kubo
      ];
    };
    config = {
      Cmd = [ "${pkgs.bash}/bin/bash" "loop.sh" ];
      WorkingDir = "/app";
    };
  }
