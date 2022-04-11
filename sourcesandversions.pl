#!perl -nlw
BEGIN{
    die unless defined$ENV{hardcode};
    open FI,$ENV{hardcode} or die;
    # when same source, two different versions, hardcode the correct one
    while(<FI>){
        @F=split;
        die unless @F==2;
        $hardcode{$F[0]}=$F[1];
    }
}
die unless ($installed,$binary,$source,$ver)=m/^\(.(.).\) (\S+ \S+) (\S+) (\S+)$/;
next unless $installed eq 'i';
unless(defined$s{$source}){
    $s{$source}="$ver $binary";
} else {
    $_=$s{$source};
    die unless ($v2,$others)=/^(\S+) (.*)/;
    if($v2 eq $ver){
        $s{$source}.=" $binary";
    } else {
        unless(defined$hardcode{$source}){
            die "many versions: source=$source $ver($binary), $v2($others)";
        }
    }
}
END{
    for(sort keys%hardcode){
        print"$_ $hardcode{$_}";
    }
    for$p(sort keys%s){
        $_=$s{$p};
        die unless ($v)=/^(\S+)/;
        print"$p $v";
    }
}
