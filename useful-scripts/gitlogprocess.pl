#! perl -plw
# simplify the log output so that only modified directories get printed
# git log --numstat | perl gitlogprocess.pl | uniq

if(m,((?:(?:-|\d+)\t){2})"(.*)"$,){
    # git puts quotation marks around filenames with unicode or other weird characters
    $_="$1$2";
}
if(m,^(?:(?:-|\d+)\t){2}packages/\{.*=> ([^/}]+),){
    # renamed files have "=>" syntax
    $_="$1"
}elsif(m,^(?:(?:-|\d+)\t){2}packages/([^/]+),){
    $_="$1"
}
