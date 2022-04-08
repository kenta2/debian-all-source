#!perl -nlw
die unless ($installed,$binary,$source)=m/^\(.(.).\) (\S+) \S+ (\S+ \S+)$/;
next unless $installed eq 'i';
next unless $binary eq 'linux-headers-amd64';
$c++;
print$source;
END{
die unless $c==1;
}
