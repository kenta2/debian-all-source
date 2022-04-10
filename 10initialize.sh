#!/bin/bash
set -vxeu
set -o pipefail
if [ -z "${1-}" ]
then echo need target 1>&2
exit 1
fi
target=$1
d1=$target/dpkg.out

if ! [ -e "$d1" ]
then echo put the output of dpkgdump.sh into "$d1" 1>&2
     exit 1
fi

pushd "$target"
git init
# needed by update script, ok if empty
touch sourcesandversions-pruned
git add dpkg.out sourcesandversions-pruned
git commit -m initial
mkdir packages
popd
bash 20update.sh "$target"
