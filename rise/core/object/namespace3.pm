package rise::core::object::namespace3;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

sub import {
	my $caller              = caller(0);
	$caller->strict::import;
	$caller->warnings::import;
	$caller->utf8::import;
}

sub DESTROY {}

1;
