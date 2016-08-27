package rise::core::object::class;
use strict;
use warnings;
use utf8;
use	rise::core::object::class::ext;
# use	parent 'rise::core::object::class::ext';
use rise::core::ops::commands;
use feature 'say';
#use Data::Dump 'dump';

#use autobox::Core;

our $VERSION 	= '0.01';

my $ENV_CLASS		= {
	this_class		=> 'rise::core::object::class',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

sub import { no strict "refs";

	# strict		->import;
	# warnings	->import;

	my $caller              = caller(0);
	my $self                = shift;
	my ($parent)			= $caller =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;
	push @{$caller.'::ISA'}, $parent, 'rise::core::object::class::ext';
	*{$caller."::super"}	= sub {${$caller.'::ISA'}[2]};
	*{$caller."::self"}		= sub {$caller};

	$caller->strict::import;
	$caller->warnings::import;
	$caller->utf8::import;
	$caller->rise::core::ops::commands::init;
}

sub DESTROY {}

1;
