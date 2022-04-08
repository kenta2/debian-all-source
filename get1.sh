#!/bin/bash
set -euvx
set -o pipefail
if [ -z "${1-}" ]
then echo need source package 1>&2
exit 1
fi
source=$1
if [ -z "${2-}" ]
then echo need version 1>&2
exit 1
fi
version=$2
if [ -z "${3-}" ]
then echo need target 1>&2
exit 1
fi
target=$3
d=`mktemp -d`
set +e
pushd "$d"
apt-get source "$source=$version"
popd
if [ "$(find "$d" -mindepth 1 -maxdepth 1 -type d | wc -l)" = 1 ]
then find "$d" -mindepth 1 -maxdepth 1 -type d -exec mv '{}' "$target/$source" \;
fi
rm -fr "$d"