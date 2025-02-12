
{
  CC,
  stdenvNoCC,
  fetchzip
}:

stdenvNoCC.mkDerivation {
  pname = "os161-binutils";
  version = "2.24+2.1";

  enableParallelBuilding = true;

  src = fetchzip {
    url = "http://os161.org/download/binutils-2.24+os161-2.1.tar.gz";
    sha256 = "sPskjubDFXH7Hjcxnuf3kvdjTbwPAvYL7sKQqo6stmg=";
  };

  nativeBuildInputs = [
    CC
  ];

  dontDisableStatic = true;

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/blob/release-21.11/pkgs/build-support/setup-hooks/update-autotools-gnu-config-scripts.sh
    export dontUpdateAutotoolsGnuConfigScripts="yes"
  '';

  preConfigure = ''
    find . -name '*.info' | xargs touch
    touch intl/plural.c
  '';
  

  configureFlags = ["--nfp" "--disable-werror" "--target=mips-harvard-os161"];

  postInstall = ''
    cd $out/bin
    sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'
  '';
}