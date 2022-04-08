#!/bin/bash
set -x
dpkg-query -W -f='(${db:Status-Abbrev}) ${binary:Package} ${Version} ${source:Package} ${source:Version}\n'
