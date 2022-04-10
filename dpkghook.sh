#!/bin/bash
# /etc/apt/apt.conf.d/04debianallsource
#DPkg::Post-Invoke      { "bash /path/to/debian-all-source/dpkghook.sh" ; };
set -e
cd /var/lib/debianallsource
dpkg-query -W -f='(${db:Status-Abbrev}) ${binary:Package} ${Version} ${source:Package} ${source:Version}\n' > dpkg.out
git commit -a -m "$0" || true
