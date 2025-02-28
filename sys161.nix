
{
  CC,
  stdenvNoCC,
  fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "os161-sys161";
  version = "2.0.8";

  enableParallelBuilding = true;

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/blob/release-21.11/pkgs/build-support/setup-hooks/update-autotools-gnu-config-scripts.sh
    export dontUpdateAutotoolsGnuConfigScripts="yes"
  '';

  nativeBuildInputs = [
    CC
  ];

  src = fetchzip {
    url = "http://os161.org/download/${pname}-${version}.tar.gz";
    sha256 = "0HXBLSzy86wWQ7sPh2JJaEJqC63zVrwo9Ekmq833PD8=";
  };

  preConfigure = ''
    export CFLAGS="-fcommon"
  '';

  configureFlags = ["mipseb"];
}