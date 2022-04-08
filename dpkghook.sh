#!/bin/bash
set -e
cd /var/lib/debianallsource
dpkg-query -W -f='(${db:Status-Abbrev}) ${binary:Package} ${Version} ${source:Package} ${source:Version}\n' > dpkg.out
git commit -a -m "$0"
