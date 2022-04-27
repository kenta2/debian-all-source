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
if(defined$ENV{ignoreversions}){
    # this file was inspired by the transition from libicu67 to libicu71 during development of Debian Bullseye.  binaries corresponding to different versions of the same source are installed.
    # for example, put "icu 67.1-7" in the file to indicate that that version should be ignored
    open FI,$ENV{ignoreversions} or die;
    while(<FI>){
	next if /^#/; #ignore comments
	die if /=/;
        @F=split;
        die unless @F==2;
	$ignore{"$F[0]=$F[1]"}=1;
    }
}

while(<>){
    die unless ($installed,$source,$ver)=m/^\(.(.).\) \S+ \S+ (\S+) (\S+)$/;
    next unless $installed eq 'i';
    if(defined($h=$hardcode{$source})){
        if($h ne $ver){
            print STDERR "ignoring $_ because $ver is hardcoded";
            # pretend the package is not installed.
        } else {
            if(defined($pv=$s{$source})){
                die unless$pv eq $h;
            } else {
                $s{$source}=$h; # == $ver
            }
        }
    } elsif(defined($ignore{"$source=$ver"})) {
	print STDERR "ignoring $_ as directed in ignoreversions file";
	$ignorecheck{"$source=$ver"}=1;
    } elsif(defined($pv=$s{$source})){
	unless($pv eq $ver){
	    die "collision on $source: $pv and $ver";
	}
    } else {
	$s{$source}=$ver;
    }
}

# force the file to stay up to date.  not sure if this is a good idea.
for$i(sort keys%ignore){
    unless($ignorecheck{$i}){
	die "ignoreversions has package $i but not seen in input";
    }
}
for$p(sort keys%s){
    print"$p $s{$p}";
}
