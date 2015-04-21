package rise::core::function;
use strict;
use vars qw($VERSION);
$VERSION = '0.001';
 
sub import { no strict;
    my $child		= caller(0);
	my $parent		= $child;
	
	#$parent			=~ s/\:\:CODE\:\:/::/;
	
	#print ">>>>>>>> $child <<<<<<<<<\n";
	
	*{$child} = \&{$child."::code"};
}
1;