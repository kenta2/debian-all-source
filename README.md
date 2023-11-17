# debian-all-source

Scripts to maintain a local git repository of source code to all
Debian packages on a system

## Running for the first time

Be sure you have `deb-src` lines in /etc/apt/sources.list .  The local
git repository will be created in `~/target` .

```
cd debian-all-source
mkdir ~/target
bash dpkgdump.sh > ~/target/dpkg.out
bash 10initialize.sh ~/target
```

This took about 40 minutes on my system, and created a git repository
of about 50 GB.  The `git add` and `git commit` operations took over
10 minutes.

## Updating

```
sudo apt update && sudo apt full-upgrade
cd debian-all-source
bash dpkgdump.sh > ~/target/dpkg.out
bash 20update.sh ~/target
```

If you have installed binaries corresponding to two different versions
of the same source, things will fail.  In Debian Sid (maybe others),
this can happen "naturally" as packages gradually migrate dependencies
to a new version.  To prevent the script from failing, put a source
and version to ignore in a file:

file: ignoreversions.txt
```
# Debian Bullseye transition from icu67 to icu71
icu 67.1-7
```

Then, provide the filename using the `ignoreversions` environment
variable to the 20update or 10initialize script.  For example, in
`bash`:

```
ignoreversions=~/target/ignoreversions.txt bash 20update.sh ~/target
```

## Additional commentary

`dpkgdump.sh` uses `dpkq-query` to look up the important mapping from
binary package to source package name.

The files `.gitignore` and `.gitattributes`, if present in the source
code, interfere with the functioning of this script, so they are
automatically renamed `.gitignore.renamed-das` and
`.gitattributes.renamed-das` ("das" = "Debian All Source") by the
`get1.sh` script.

There are some useful scripts in `useful-scripts/'` including how to
install a dpkg hook so that some of this can happen automatically, and
various hints for navigating a huge repository with git.

It is common to have installed more than one Linux kernel, and related
packages like headers.  This would cause the script to fail, so
`linuxhardcode.pl` deals with this by choosing only one Linux source
version.

Once a binary package gets updated, its old source code disappears
from package servers, so you cannot delay very much between upgrading
your system (`apt full-upgrade`) and updating the source code.
