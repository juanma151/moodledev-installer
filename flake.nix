{
  description = "Moodle dev environment (Apache + PHP-FPM + MariaDB)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {pkgs, ...}: let
        phpPkg = pkgs.php84 or pkgs.php;
        apachePkg = pkgs.apacheHttpd_2_4 or pkgs.apacheHttpd;
        mariadbPkg = pkgs.mariadb_114 or pkgs.mariadb;
        moodlePkg = pkgs.moodle;
        zshPkg = pkgs.zsh;
        sedPkg = pkgs.gnused;

        top = pkgs.callPackage ./default.nix {
          inherit phpPkg apachePkg mariadbPkg moodlePkg zshPkg sedPkg;
        };
      in {

        packages = {
          moodleDevInstaller = top.moodleDevInstaller;
          default = top.moodleDevInstaller;
        };

        devShells = {
          moodleDevInstaller = top.moodleDevInstallerShell;
          default = top.moodleDevInstallerShell;
        };

        apps = rec {
          moodleDevInstall = {
            type="app";
            program="${top.moodleDevInstaller}/bin/moodle-install";
          };
          default = moodleDevInstall;
        };
      };
    };
}
