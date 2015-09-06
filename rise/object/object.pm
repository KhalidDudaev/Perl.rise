package rise::object::object;
use strict;
use warnings;
use utf8;

use parent qw/
	rise::object::error
	rise::core::commands
/;

our $VERSION = '0.01';

our $caller = 'rise::object::object';

my $ENV_CLASS		= {
	this_class		=> 'rise::object::object',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

my $VARS		= {};

sub new {
	#my $class					= ref $_[0] || $_[0];
	return bless($ENV_CLASS, (ref $_[0] || $_[0]));
}

sub obj {
	my $self	= shift;
	my $caller	= caller(0);
	return { self => $self, caller => $caller };
}

sub __RISE_ENV { shift->new }

sub DESTROY {}

1;

