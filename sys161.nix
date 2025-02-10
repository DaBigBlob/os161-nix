
{
  CC,
  stdenvNoCC,
  fetchzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "sys161";
  version = "2.0.8";

  enableParallelBuilding = true;


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