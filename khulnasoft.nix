{ stdenv, lib, fetchurl, autoPatchelfHook }:
let
  release = import ./release.nix;
in
stdenv.mkDerivation rec
{
  pname = "khulnasoft";
  version = release.version;
  system = {
    "x86_64-linux" = "linux_amd64";
    "x86_64-darwin" = "darwin_amd64";
    "aarch64-linux" = "linux_arm64";
    "aarch64-darwin" = "darwin_arm64";
  }.${stdenv.targetPlatform.system};

  checksum = release.checksums.${system};

  src = fetchurl {
    url = "https://d2f391esomvqpi.cloudfront.net/${pname}-${version}-${system}.tar.gz";
    sha256 = checksum;
  };

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [ ];

  unpackPhase = ''
    tar -C ./ -xzf ${src}
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/runtimes
    mkdir -p $out/khulnasoft-go

    cp -r ./bin/* $out/bin/
    cp -r ./runtimes/* $out/runtimes/
    cp -r ./khulnasoft-go/* $out/khulnasoft-go/
  '';

  meta = {
    description = "khulnasoft cli";
    homepage = "https://khulnasoft.com";
    license = lib.licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
