#!perl
#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use lib qw|
    C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise
|;

use rise::lib::tman ':simple';

plugin 'notify';
plugin 'copy';

task 'copy' => sub {
    tman
        # ->src('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.pm')
	    ->copy('c:/_programs/development/Strawberry/perl/vendor/lib/')
        ->notify('copy to ...' . tman->ref_path . tman->dst_file);
};

task 'watch' => sub {
	tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.pm', ['copy']);
};

task 'default', ['watch'];

start;

1;
