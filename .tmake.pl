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
# plugin 'ftp';
plugin 'notify';
# plugin 'copy';

task 'compile' => sub {
    tman
        # ->src('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma')
		->puma({ debug => 1, info  => 0 })
	    ->dst('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/')
        ->notify('puma compile ...' . tman->ref_path . tman->dst_file);
        # ->notify('puma compile ...' . tman->ref_path);
        # ->copy('c:/_programs/development/Strawberry/perl/vendor/lib/')
        # ->notify('copy to ...' . tman->ref_path . tman->dst_file);
};

# task 'copy' => sub {
#     tman->src('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.pm')
# 	    ->copy('c:/_programs/development/Strawberry/perl/vendor/lib/')
#         ->notify('copy to ...' . tman->ref_path . tman->dst_file);
# };

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
	# tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma', ['copy']);
	# tman->watch('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.pm', ['ftp']);
};

task 'default', ['watch'];

start;

1;
