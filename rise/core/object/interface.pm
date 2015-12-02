package rise::core::object::interface;
use strict;
use warnings;
use utf8;
use	parent 'rise::core::object::interface::ext';
#use Data::Dump 'dump';

my $ERROR_MESSAGES		= '';

sub import { no strict "refs";

	# strict		->import;
	# warnings	->import;

	my $caller              = caller(0);
	my $self                = shift;
	my ($parent)			= $caller =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;
	push @{$caller.'::ISA'}, $parent, 'rise::core::object::interface::ext';
	# *{$caller."::super"}	= sub {${$caller.'::ISA'}[2]};
	# *{$caller."::self"}		= sub {$caller};

	$caller->strict::import;
	$caller->warnings::import;
	$caller->utf8::import;
	# $caller->rise::core::ops::commands::init;
}

sub DESTROY {}

1;
