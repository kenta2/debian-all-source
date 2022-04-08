#!/bin/bash
set -vxeu
set -o pipefail
if [ -z "${1-}" ]
then echo need target 1>&2
exit 1
fi
target=$1
mkdir "$target"
d1=$target/dpkg.out
bash dpkgdump.sh > "$d1"
perl linuxhardcode.pl "$d1" > "$target/hardcode"
sourcesandversions=$target/sourcesandversions
hardcode=$target/hardcode perl sourcesandversions.pl "$d1" | sort > "$sourcesandversions"
mkdir "$target/packages"
#head -2 "$sourcesandversions" |
cat "$sourcesandversions" | target=$target/packages perl getall.pl

true All done $0
