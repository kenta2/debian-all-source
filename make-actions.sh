#!/bin/bash
set -euvx
set -o pipefail
if [ -z "${1-}" ]
then echo need old file 1>&2
exit 1
fi
old=$1
if [ -z "${2-}" ]
then echo need new file 1>&2
exit 1
fi
new=$2
if [ -z "${3-}" ]
then echo need target 1>&2
exit 1
fi
target=$3
comm --check-order -23 "$old" "$new" > "$target"/remove
comm --check-order -13 "$old" "$new" > "$target"/fetch
comm --check-order -12 "$old" "$new" > "$target"/keep
