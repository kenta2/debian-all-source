#!perl -nlwa
die unless defined($target=$ENV{target});
die unless @F==2;
$result=system('bash','get1.sh',$F[0],$F[1],$target);
if($result){
    die "$?"
}
