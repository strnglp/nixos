{ stdenv }:

stdenv.mkDerivation {
  pname = "ProfanityFE";
  version = "0.1";
  src = stdenv.fetchFromGitHub {
    owner = "elanthia-online";
    repo = "ProfanityFE";
    rev = "041e19f";
    sha256 = "00000000000000000000000000000000000000000000";
  };
}
