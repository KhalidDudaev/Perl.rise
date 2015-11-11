package rise::core::object::funcdecl;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.001';

#use rise::core::ops::commands;

sub import { no strict 'refs';
	my $obj					= caller(0);
	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

	########################################################################
		push @{$obj.'::ISA'}, $parent, 'rise::core::object::object';
		strict		->import;
		warnings	->import;
		$obj		->__RISE_COMMANDS;
	########################################################################

	*{$obj} = *{"$obj::$fn_name"};
}


1;
