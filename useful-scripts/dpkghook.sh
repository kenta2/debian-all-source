#!/bin/bash
# keeps a history of dpkg in git in /var/lib
# user must initialize /var/lib/debianallsource as a git repo and check in an initial dpkg.out, ok if empty

# install dpkg hook:
# /etc/apt/apt.conf.d/04debianallsource
#DPkg::Post-Invoke      { "bash /path/to/debian-all-source/useful-scripts/dpkghook.sh" ; };
set -e
cd /var/lib/debianallsource
dpkg-query -W -f='(${db:Status-Abbrev}) ${binary:Package} ${Version} ${source:Package} ${source:Version}\n' > dpkg.out
git commit -a -m "$0" || true
# git fail if nothing to commit
