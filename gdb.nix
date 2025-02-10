
{
  CC,
  stdenvNoCC,
  fetchzip,
  ncurses5
}:

stdenvNoCC.mkDerivation {
  pname = "gdb+os161";
  version = "7.8+2.1";

  enableParallelBuilding = true;

  src = fetchzip {
    url = "http://os161.org/download/gdb-7.8+os161-2.1.tar.gz";
    sha256 = "w2tXm8zBo3KGyDg8xFEJl6XQo/IO65wwnLxKLBdsabs=";
  };

  dontDisableStatic = true;

  nativeBuildInputs = [
    CC
    ncurses5
  ];

  patches = [
    ./gdb-os161.patch # https://sourceware.org/bugzilla/show_bug.cgi?id=16827
  ];

  postPatch = ''
    export dontUpdateAutotoolsGnuConfigScripts="yes"
  '';

  preConfigure = ''
    find . -name '*.info' | xargs touch
    touch intl/plural.c

    export CXXFLAGS="-std=c++98"
    export CFLAGS="-fcommon"
  '';

  configureFlags = [
    "--target=mips-harvard-os161"
  ];

  postInstall = ''
    cd $out/bin
    sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'
  '';
}