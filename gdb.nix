
{
  CC,
  stdenvNoCC,
  fetchzip,
  ncurses5,
  readline
}:

stdenvNoCC.mkDerivation {
  pname = "os161-gdb";
  version = "7.8+2.1";

  enableParallelBuilding = true;

  src = fetchzip {
    url = "http://os161.org/download/gdb-7.8+os161-2.1.tar.gz";
    sha256 = "w2tXm8zBo3KGyDg8xFEJl6XQo/IO65wwnLxKLBdsabs=";
  };

  dontDisableStatic = true;

  buildInputs = [
    readline
    ncurses5
  ];

  nativeBuildInputs = [
    CC
  ];

  patches = [
    ./os161-gdb.patch # https://sourceware.org/bugzilla/show_bug.cgi?id=16827
  ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/blob/release-21.11/pkgs/build-support/setup-hooks/update-autotools-gnu-config-scripts.sh
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

    "--with-system-readline"
  ];

  postInstall = ''
    cd $out/bin
    sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'
  '';
}