#!perl -nlw

# If you have two binaries installed which come from the same source,
# but different versions of that source, things go wrong.  Here is
# logic to hardcode the desired source version for two packages for
# which it is common to have multiple versions simultaneously
# installed.  The desired version of the "linux-signed-amd64" source
# package may be deduced by looking at the version corresponding to
# the "linux-headers-amd64" binary package (which would need to be
# installed).  Similarly, the "linux" source package is the source for
# multiple versions "linux-headers-$VERSION-amd64 (seen on Debian
# bullseye).  Deduce the desired version from "linux-libc-dev:amd64".
# This is a hack.

die unless ($installed,$binary,$source)=m/^\(.(.).\) (\S+) \S+ (\S+ \S+)$/;
next unless $installed eq 'i';
next unless $binary eq 'linux-headers-amd64' or $binary eq 'linux-libc-dev:amd64';
$c{$binary}++;
print$source;
END{
    for(keys%c){
	die unless $c{$_}==1;
    }
}
