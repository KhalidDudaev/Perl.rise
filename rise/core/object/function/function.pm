package rise::core::object::function::function;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.001';

sub import { no strict;
    my $obj		= caller(0);
	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

	strict		->import;
	warnings	->import;

	*{$obj} = \&{"$obj::$fn_name"};
}

1;
