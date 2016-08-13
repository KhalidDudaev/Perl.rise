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
plugin 'ftp';
plugin 'notify';

task 'compile' => sub {
    tman->src('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma')
		->puma({ debug => 1, info  => 0 })
	    ->dst('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/')
		->notify('puma compile ...' . tman->ref_path . tman->dst_file);
};

# task 'ftp' => sub {
# 	tman->src('C:/_DATA_EXT/_data/works/Development/_PERL/_apps/appdist/**/*.pm')
# 		->ftp({
# 			host	=> 'ftp.infocentersupport.com',
# 			user	=> 'chechen@infocentersupport.com',
# 			pass	=> 'sanhome',
# 			path	=> '/distr'
# 		})
# 		->notify('ftp transfer ...' . tman->ref_path . tman->dst_file);
# };

task 'watch' => sub {
	tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma', ['compile']);
	# tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.pm', ['ftp']);
};

task 'default', ['watch'];

start;

1;
