#!perl
#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use lib qw|
    C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise
|;

use rise::lib::tman ':simple';

plugin 'puma';
plugin 'notify';

task 'compile' => sub {
    tman
        # ->src('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma')
		->puma({ debug => 1, info  => 0 })
	    ->dst('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/')
        ->notify('puma compile ...' . tman->ref_path . tman->dst_file);
};

task 'watch' => sub {
	tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma', ['compile']);
};

task 'default', ['watch'];

start;

1;
