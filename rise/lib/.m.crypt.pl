#!perl
#!/usr/bin/env perl
use strict;
use warnings;
use lib qw|
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/
|;

use rise;
# use rise::lib::fs;

my $r               = new rise { debug    => 1, info    => 1 };
# my $fs              = new rise::lib::fs;

# my $source_lists    = $fs->dir->listf('C:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/**/*.puma');

$r->compile('C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\crypt.puma', 'C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\crypt.pm');
# $r->compile_list(['C:\_DATA_EXT\_data\works\Development\_PERL\_lib\librise\rise\lib\crypt.puma']);

1;
