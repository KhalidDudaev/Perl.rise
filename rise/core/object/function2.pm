package rise::core::object::function2;
use strict;
use warnings;
use utf8;
use feature 'say';

use vars qw($VERSION);
$VERSION = '0.001';

# use rise::core::ops::commands;

sub import {
	my $obj					= caller(0);
	my $self				= shift;
	my ($parent, $fn_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

    # { no strict 'refs'; ${$obj.'::__SELF__'} = $self; }
	# $fn_name = 'code';

	# say '--------- func ---------';
	# say "caller -> $obj";
	# say "self   -> $fn_name";

    { no strict 'refs';
        *{$obj} = *{"$obj::$fn_name"};
    }
	########################################################################
		# push @{$obj.'::ISA'}, $parent;
        $obj->strict::import;
    	$obj->warnings::import;
		# $obj->rise::core::ops::commands::init;
	########################################################################

}


1;
