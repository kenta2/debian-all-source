#!perl -nlw
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
