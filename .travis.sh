#!/bin/sh

set -e

# Functions to separate actions in travis jobs
fold_start () { printf 'travis_fold:start:%s\r\033[33;1m%s\033[0m\n' "$1" "$2"; }
fold_end () { printf 'travis_fold:end:%s\r' "$1"; }


# Install opam with the most recent version
fold_start install_opam 'Install OPAM'
mkdir -p ~/.local/bin
wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - \
    | sh -s ~/.local/bin system
export PATH=~/.local/bin:$PATH
fold_end install_opam


# Prepare opam with the right ocaml version
fold_start prepare_opam 'Prepare OPAM'
if [ -z "$OCAML_VERSION" ]
then
    printf 'No OCaml version provided in $OCAML_VERSION, using system.\n'
    OCAML_VERSION=system
fi
opam switch "$OCAML_VERSION"
eval $(opam config env)
fold_end prepare_opam


# Install dependse by the distar
fold_start install_dependencies 'Install dependencies'
opam install -y jbuilder cmdliner
fold_end install_dependencies


# Run tests
fold_start make_check 'Run tests with make check'
make check
fold_end make_check
