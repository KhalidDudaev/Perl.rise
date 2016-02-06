package rise::core::object::thread;
use strict;
use warnings;
use utf8;
use thread;
use threads::shared;
use	rise::core::object::thread::ext;
use rise::core::ops::commands;
# use feature 'say';

use vars qw($VERSION);
$VERSION = '0.001';

use rise::core::ops::commands;

sub import { no strict 'refs';
	my $obj					= caller(0);
	my $self				= shift;
	my ($parent, $trd_name)	= $obj =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

	# $trd_name = 'code';

	# say '--------- func ---------';
	# say "caller -> $obj";
	# say "self   -> $trd_name";

	########################################################################
		push @{$obj.'::ISA'}, $parent, 'rise::core::object::thread::ext';
		# strict		->import;
		# warnings	->import;
		$obj->thread::import;
		$obj->threads::shared::import;
		$obj->rise::core::ops::commands::init;
	########################################################################

	*{$obj} = *{"$obj::$trd_name"};
}


1;
