#!perl -lw
if(defined$ENV{linuxversion}){
    open FI,$ENV{linuxversion} or die;
    # when same source, two different versions, hardcode the correct one
    while(<FI>){
        @F=split;
        die unless @F==2;
        die if$hardcode{$F[0]};
        $hardcode{$F[0]}=$F[1];
    }
} else {
    # proceed onward, error may occur later if you have two linux versions installed
    #die "expecting ENV linuxversion";
}
while(<>){
    die unless ($installed,$source,$ver)=m/^\(.(.).\) \S+ \S+ (\S+) (\S+)$/;
    next unless $installed eq 'i';
    if(defined($h=$hardcode{$source})){
        if($h ne $ver){
            print STDERR "ignoring $_";
            # pretend the package is not installed.
        } else {
            if(defined($pv=$s{$source})){
                die unless$pv eq $h;
            } else {
                $s{$source}=$h; # == $ver
            }
        }
    } else{
        if(defined($pv=$s{$source})){
            unless($pv eq $ver){
                die "collision on $source: $pv and $ver";
            }
        } else {
            $s{$source}=$ver;
        }
    }
}

for$p(sort keys%s){
    print"$p $s{$p}";
}
