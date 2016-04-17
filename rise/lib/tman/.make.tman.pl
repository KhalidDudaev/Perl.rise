#!perl
#!/usr/bin/env perl
use strict;
use warnings;
use lib qw|
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/rise/lib/
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/rise/lib/tman/
|;

use rise {
    debug    => 1,
    info    => 0,
    compile => [qw'
		puma
		ftp
    ']
};
# MakeBot
# fmm

# use ftask;

1;