package rise::core::function;
use strict;
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
1;