#!perl.exe -w
use strict;
use warnings;
use lib qw|
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/
|;

use rise {
    debug    => 1,
    info    => 0,
    compile => [qw'
        pipe
    ']
};
1;
