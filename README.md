# debian-all-source
scripts to maintain a local git repository of sources of all Debian packages on a system

## Running for the first time

Be sure you have `deb-src` lines in /etc/apt/sources.list .

```
cd debian-all-source
mkdir ~/target
bash dpkgdump.sh > ~/target/dpkg.out
bash 10initialize.sh ~/target
```

This took about 40 minutes on my system, and created a git repository of about 50 GB.  The `git add` and `git commit` operations took over 10 minutes.

## Updating

```
cd debian-all-source
bash dpkgdump.sh > ~/target/dpkg.out
bash 20update.sh ~/target
```

If you have installed binaries corresponding to two different versions
of the same source, things will fail.  First, put the source and
version to ignore in a file:

file: toignore
```
# Debian Bullseye transition from icu67 to icu71
icu 67.1-7
```

Then, provide the filename using the `ignoreversions` environment
variable to the 20update or 10initialize script.  For example, in
`bash`:

```
ignoreversions=~/target/toignore bash 20update.sh ~/target
```
