#!/bin/bash
set -euvx
set -o pipefail
if [ -z "${1-}" ]
then echo need target 1>&2
     exit 1
fi
target=$1
perl linuxhardcode.pl "$target/dpkg.out" > "$target/hardcode"
sourcesandversions=$target/sourcesandversions
t=$(mktemp -d)
pushd $target
# just in case an updated version is sticking around
git checkout sourcesandversions-pruned
popd

hardcode=$target/hardcode perl sourcesandversions.pl "$target/dpkg.out" | sort > "$sourcesandversions"
bash make-actions.sh "$sourcesandversions-pruned" "$sourcesandversions" "$t"
pushd $target/packages
perl -nlwae 'print$F[0]if(-e$F[0])' "$t/remove" > "$t/gitremove"
if [ "$(wc -c < "$t/gitremove")" != "0" ]
then time xargs git rm -r < "$t/gitremove"
     xargs rm -fr < "$t/gitremove"
fi
popd
target=$target/packages perl getall.pl < "$t/fetch"
#20min
pushd $target
perl -nlwae 'print if(-e "packages/$F[0]")' sourcesandversions > sourcesandversions-pruned

time git add .
time git commit -m "$0"
#13min
git status --ignored
popd
# 41m to do everything
