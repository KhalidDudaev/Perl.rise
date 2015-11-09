package rise::core::object::thread::thread;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.001';

use Data::Dump 'dump';

my @methods = qw/
    join
/;

sub import { no strict;
    my $obj		= caller(0);
	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

	strict		->import;
	warnings	->import;

    # print "\n########### $obj #############\n";

	*{$obj} = \&{"$obj::$fn_name"};
    # *{$fn_name . '::' . $_} = \&{'rise::core::object::thread::' . $_} foreach @methods;
    *{$fn_name . '::'} = *{'rise::core::object::thread::'}
}

1;
