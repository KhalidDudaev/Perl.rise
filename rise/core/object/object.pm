package rise::core::object::object;
use strict;
use warnings;
use utf8;

use parent qw/
	rise::core::object::error
/;
	# rise::core::ops::commands

our $VERSION = '0.01';

# our $caller = 'rise::core::object::object';

my $ENV_CLASS		= {
	this_class		=> 'rise::core::object::object',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

my $VARS		= {};

# sub new {
# 	# return bless($ENV_CLASS, (ref $_[0] || $_[0]));
# 	my ($class, $args)	= (ref $_[0] || $_[0], $_[1]);
# 	%$args				= (%$ENV_CLASS, %$args);
# 	return bless {}, $class;
# }

# sub import {
# 	print "############# OBJECT ##############\n";
# }

sub obj {
	my $self	= shift;
	my $caller	= caller(1);
	return { self => $self, caller => $caller };
}

sub __RISE_ENV { shift->new }

sub DESTROY {}

1;
