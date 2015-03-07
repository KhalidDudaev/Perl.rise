package rise::object::interface;
use strict;
use warnings;
use utf8;

use parent 'rise::object::abstract';

my $ERROR				= {
	interface				=> [ [ 0, 1 ], '"INTERFACE ERROR: Interface \"$parent\" only implements at $file line $line\n"' ],
	interface_inherit		=> [ 1, 4 ],
};

################################# access mod #################################

sub protected_interface {
	my ($self)			= @_;

	#my $callercode			= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/g;
	#my $callercode_eval		= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/g;
	#
	#($callercode eq 'import' || $callercode_eval eq 'import') or $self->_error($ERROR->{interface});
	
	my $childcode			= (caller(2))[3];
	$childcode eq 'rise::core::implements::import' or $self->_error($ERROR->{interface}); # protected interface with access mod
	
}

sub DESTROY {}

1;

