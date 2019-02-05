SUDO_COMMAND=""
OPAM_COMMAND="$SUDO_COMMAND opam"
INSTALL_COMMAND="$SUDO_COMMAND apt-get install -y"

#Run As Root
$SUDO_COMMAND dpkg --configure -a

$INSTALL_COMMAND curl

#Optional for OPAM Main Program
$INSTALL_COMMAND make
$INSTALL_COMMAND m4
$INSTALL_COMMAND cc
$INSTALL_COMMAND gcc

#Optional for OPAM Features
$INSTALL_COMMAND rsync
$INSTALL_COMMAND git
$INSTALL_COMMAND hg
$INSTALL_COMMAND darcs

#Required for OPAM
$INSTALL_COMMAND patch
$INSTALL_COMMAND unzip
$INSTALL_COMMAND bubblewrap

#Install OPAM
$SUDO_COMMAND sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

#Initialize OPAM
$OPAM_COMMAND init
$OPAM_COMMAND update
$OPAM_COMMAND install depext
$OPAM_COMMAND install google-drive-ocamlfuse
