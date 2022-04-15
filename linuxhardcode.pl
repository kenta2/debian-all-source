#!perl -lw

# If you have two binaries installed which come from the same source,
# but different versions of that source, things go wrong.  Here is
# logic to hardcode the desired source version for two packages for
# which it is common to have multiple versions simultaneously
# installed.

open FI,"/etc/os-release" or die;
while(<FI>){
    die unless ($key,$value)=/^\s*(\S+?)\s*=\s*(.*)/;
    if($value =~ /^"([^\\]*)"$/){
        $value=$1;  # no backslashes in quotes, so not a weird string
    }
    $os{$key}=$value;
}
die unless defined($os{ID});
while(<>){
    die unless ($installed,$binary,$version,$source)=m/^\(.(.).\) (\S+) (\S+) (\S+ \S+)$/;
    next unless $installed eq 'i';
    die if defined$bs{$binary}; #multiple versions of the same binary
    $bs{$binary}=$source;
    die if defined$bversion{$binary};
    $bversion{$binary}=$version;
}

if($os{ID}eq"debian"){
    # The desired version of the "linux-signed-amd64" source package may
    # be deduced by looking at the version corresponding to the
    # "linux-headers-amd64" binary package (which would need to be
    # installed).  Similarly, the "linux" source package is the source for
    # multiple versions "linux-headers-$VERSION-amd64 (seen on Debian
    # bullseye).  Deduce the desired version from "linux-libc-dev:amd64".
    # This is a hack.
    push@emit,$_ if defined($_=$bs{'linux-headers-amd64'});
    push@emit,$_ if defined($_=$bs{'linux-libc-dev:amd64'});
    &searchandprint('linux-image-.*-amd64',"linux-image-amd64");
    &searchandprint('linux-headers-.*-amd64',"linux-headers-generic");
}
elsif($os{ID}eq"ubuntu"){
    die unless defined$os{VERSION_ID};
    &searchandprint('linux-image-.*-generic',"linux-image-generic-hwe-".$os{VERSION_ID});
    &searchandprint('linux-image-.*-generic',"linux-image-generic");
    &searchandprint('linux-headers-.*-generic',"linux-headers-generic-hwe-".$os{VERSION_ID});
    &searchandprint('linux-headers-.*-generic',"linux-headers-generic");
}
else{
    die "unrecognized ID $os{ID}";
}

# check that there are no conflicting duplicates
for(@emit){
    @F=split;
    die unless@F==2;
    if(defined($v=$already{$F[0]})){
        die unless$F[1]eq$v;
    } else {
        print;
        $already{$F[0]}=$F[1];
    }
}
sub getdepends {
    my$p=shift;
    my$version=shift;
    my$regex=shift;
    # need version
    #print STDERR "looking for $p=$version, $regex";
    open FI,"apt-cache show $p=$version|" or die;
    my$found;
    while(<FI>){
        my$l;
        next unless ($l)=/^Depends: (.*)/;
        my@F=split /,\s*/,$l;
        for(@F){
            #print STDERR "examine ($_)";
            if(/^($regex)\b/){ # debian appends a version in parentheses: "Depends: linux-image-5.10.0-12-amd64 (= 5.10.103-1)"
                die if$found;
                $found=$1;
            }
        }
    }
    die unless$found;
    $found;
}

sub searchandprint {
    my $regex=shift or die;
    my $p=shift or die;
    if(defined$bs{$p}){
        $i=&getdepends($p,$bversion{$p},$regex);
        die unless defined$bs{$i};
        #print STDERR "found $bs{$i}";
        push@emit,$bs{$i};
    }
}
