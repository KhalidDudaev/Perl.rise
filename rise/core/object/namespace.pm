package rise::core::object::namespace;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

sub import {
	strict		->import();	
	warnings	->import();
}

sub DESTROY {}

1;

