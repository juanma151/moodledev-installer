{
  pkgs ? (import <nixpkgs>) {},
  phpPkg ? pkgs.php84           or pkgs.php,
  apachePkg ? pkgs.apacheHttpd_2_4 or pkgs.apacheHttpd,
  mariadbPkg ? pkgs.mariadb_114     or pkgs.mariadb,
  moodlePkg ? pkgs.moodle,
  zshPkg ? pkgs.zsh,
  sedPkg ? pkgs.gnused,
  ...
}: let
  moodlePhpEnv = phpPkg.buildEnv {
    extensions = {
      all,
      enabled,
    }:
      enabled
      ++ (with all; [
        ctype
        curl
        dom
        exif
        fileinfo
        filter
        gd
        iconv
        intl
        mbstring
        mysqli
        mysqlnd
        opcache
        openssl
        pdo_mysql
        simplexml
        soap
        sodium
        tokenizer
        xmlreader
        zip
        zlib
      ]);

    extraConfig = "max_input_vars=5000";
  };

  moodleDevInstaller = pkgs.stdenv.mkDerivation {
    pname = "moodledev-installer";
    version = "0.2.0";
    src = ./src;

    dontBuild = true;

    propagatedBuildInputs = [
      moodlePkg
      apachePkg
      mariadbPkg
      moodlePhpEnv
      zshPkg
      sedPkg
    ];

    installPhase = ''
      ## templates
      # bin
      mkdir -p $out/share/moodledev-installer/templates/bin

      cp templates/bin/* $out/share/moodledev-installer/templates/bin/

      for f in $out/share/moodledev-installer/templates/bin/*; do
        substituteInPlace "$f" \
          --replace "@SITE-ROOT@"      "${moodlePkg}/share/moodle" \
          --replace "@APACHE-MODULES@" "${apachePkg}/modules"
      done

      # conf
      mkdir -p $out/share/moodledev-installer/templates/conf

      cp templates/conf/* $out/share/moodledev-installer/templates/conf/

      for f in $out/share/moodledev-installer/templates/conf/*; do
        substituteInPlace "$f" \
          --replace "@SITE-ROOT@"    "${moodlePkg}/share/moodle" \
          --replace "@APACHE-MODULES@" "${apachePkg}/modules"
      done

      ## 1st level binaries
      mkdir -p $out/bin

      cp bin/* $out/bin/

      for f in $out/bin/*; do
        substituteInPlace "$f" \
          --replace "@SITE-ROOT@"    "${moodlePkg}/share/moodle" \
          --replace "@APACHE-MODULES@" "${apachePkg}/modules" \
          --replace "@TEMPLATES@"      "$out/share/moodledev-installer/templates"

        chmod +x "$f"
      done
    '';
  };

  moodleDevInstallerShell = pkgs.mkShell {
    name = "moodledev-installer-shell";
    version = "0.2.0";
    packages = [moodleDevInstaller];
  };
in {
  inherit moodleDevInstaller moodleDevInstallerShell;
}
