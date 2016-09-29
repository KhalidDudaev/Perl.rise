#!perl
#!/usr/bin/env perl
use strict;
use warnings;
use lib qw|
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/
|;

use rise {
    debug    => 1,
    info    => 1,
    compile => [qw'
        fs
		fs/dirWorker
		fs/fileWorker
		fs/infoWorker
		fs/pathWorker
    ']
};
# MakeBot
# fmm

# use ftask;

1;
