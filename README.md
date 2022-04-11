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
