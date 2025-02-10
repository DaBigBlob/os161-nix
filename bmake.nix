
{
  CC,
  stdenvNoCC,
  fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "bmake";
  version = "20101215";

  enableParallelBuilding = true;

  src = fetchzip {
    url = "http://os161.org/download/${pname}-${version}.tar.gz";
    sha256 = "XskeEH8rV9qtd3I7NPWgX4xOfkrxjGn0MYq6ay+gSlk=";
  };

  srcmk = fetchzip {
    url = "http://os161.org/download/mk-20100612.tar.gz";
    sha256 = "oT1Ov8YNVXQpnRMBPsN79lJoZnqqDFqIVe3i4aHTFLU=";
  };

  nativeBuildInputs = [
    CC
  ];

  dontDisableStatic = true;

  postPatch = ''
    export dontUpdateAutotoolsGnuConfigScripts="yes"
  '';

  preConfigure = ''
    cp -r ${srcmk} mk

    export CFLAGS="-fcommon"
  '';

  configureFlags = ["--with-default-sys-path=$out/share/mk"];

  buildPhase = ''
    chmod +x ./make-bootstrap.sh
    ./make-bootstrap.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/mk
    cp bmake $out/bin/
    cp bmake.1 $out/share/man/man1/
    ./mk/install-mk $out/share/mk
  '';
}