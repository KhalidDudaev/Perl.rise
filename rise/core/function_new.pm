package rise::core::function_new;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.001';

#use rise::core::commands;

sub import {
	my $obj					= caller(0);
	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;
	
	no strict 'refs';
	push @{$obj.'::ISA'}, $parent;	
	
	strict->import;
	warnings->import;
	$obj->__RISE_COMMANDS;
	#rise::core::commands::->__RISE_COMMANDS;

#	print ">>>>>>>>
#	class	: $parent
#	object	: $obj
#	name	: $fn_name
#<<<<<<<<<\n";

	*{$obj} = *{"$obj::$fn_name"};
}


1;