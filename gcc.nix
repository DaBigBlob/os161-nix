
{
  CC,
  stdenvNoCC,
  fetchzip,
  binutils,
  gmp,
  mpfr,
  libmpc
}:

stdenvNoCC.mkDerivation {
  pname = "gcc+os161";
  version = "4.8.3+2.1";

  enableParallelBuilding = true;

  src = fetchzip {
    url = "http://os161.org/download/gcc-4.8.3+os161-2.1.tar.gz";
    sha256 = "ec1EBFtTGnNuY6jg6jg8GExFq7yxgJxPRLZzqT4P1y0=";
  };

  dontDisableStatic = true;

  buildInputs = [
    binutils
  ];

  nativeBuildInputs = [
    CC
    gmp
    mpfr
    libmpc
  ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/blob/release-21.11/pkgs/build-support/setup-hooks/update-autotools-gnu-config-scripts.sh
    export dontUpdateAutotoolsGnuConfigScripts="yes"
  '';

  hardeningDisable = [ "format" ];

  preConfigure = ''
    find . -name '*.info' | xargs touch
    touch intl/plural.c

    sed -i '96,97d' gcc/config.host   # remove darwin prebuilts

    mkdir -p ../buildgcc
    cd ../buildgcc

    export CXXFLAGS="-std=c++98"
  '';

  configureScript = ''
    ../source/configure
  '';

  configureFlags = [
    "--enable-languages=c,lto"
    "--nfp" "--disable-shared" "--disable-threads"
    "--disable-libmudflap" "--disable-libssp"
    "--disable-libstdcxx" "--disable-nls"
    "--target=mips-harvard-os161"
    "--with-gmp=${gmp}"
	  "--with-mpfr=${mpfr}"
	  "--with-mpc=${libmpc}"
  ];

  postInstall = ''
    cd $out/bin
    sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'
  '';
}