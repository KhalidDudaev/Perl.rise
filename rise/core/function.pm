package rise::core::function;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.001';

sub import { no strict;
    my $child		= caller(0);
	#my $parent		= $child;
	my ($fn_name)	= $child =~ /(?:\w+::)*(\w+)/;
	
	#$parent			=~ s/\:\:CODE\:\:/::/;
	
	#print ">>>>>>>> $fn_name <<<<<<<<<\n";
	
	#*{$child} = \&{$child."::code"};
	*{$child} = \&{"$child::$fn_name"};
}


#use rise::core::commands;

#sub import {
#	my $obj			= caller(0);
#
#	strict->import;
#	warnings->import;
#	rise::core::commands::->__RISE_COMMANDS($obj);
#
#	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;
#	
##	print ">>>>>>>>
##	class	: $parent
##	object	: $obj
##	name	: $fn_name
##<<<<<<<<<\n";
#
#	no strict 'refs';
#	push @{$obj.'::ISA'}, $parent;
#
#	*{$obj} = *{"$obj::$fn_name"};
#}


1;