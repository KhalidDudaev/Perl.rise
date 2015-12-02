package rise::core::object::interface::ext;
use strict;
use warnings;
use utf8;

use parent 'rise::core::object::object';

# use feature 'say';
# use Data::Dump 'dump';

    # rise::core::object::error
    # rise::core::object::function
    # rise::core::object::variable
    # rise::core::ops::commands

our $VERSION			= '0.01';

sub __objtype {'INTERFACE'};

sub set_interface {
	no strict 'refs';
	no warnings;
	my $caller			= caller(4);
	my $class			= shift;
	my $name			= shift;

	my $h_i				= { $name => 1 };
	my $h_ii 			= \%{$caller.'::INTERFACE'};
	%$h_ii				= (%$h_ii, %$h_i);
	# print "### ".dump (\%{$class.'::'})." ###\n";
    # say '--------- iface sets ---------';
    # say "caller -> $caller";
    # say "self   -> $class";
    # say "ilist  -> ". dump \%{$caller.'::INTERFACE'};
}

sub interface_join {
	no strict 'refs';
	no warnings;

	#my $self			= shift;
	my $interface 		= shift;
	my $class			= caller(2); #shift;

	#print ">>>>>>>>>> $interface <<<<<<<<<<\n";
	#print "\n###### interface - $interface | class - $class ######\n";

	%{$class.'::INTERFACE'} = (%{$class.'::INTERFACE'}, %{$interface.'::INTERFACE'});

	#interface_confirm($class);

	#print dump (\%{$class.'::INTERFACE'}), "\n";
	#print "### - " . dump (\%{$interface.'::INTERFACE'}) . "\n";
}

################################# access mod #################################

sub protected_interface {
	#my ($self)			= @_;
	my $callercode		= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/;
	my $callercode_eval	= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/;

	($callercode eq 'import' || $callercode_eval eq 'import') or shift->__error('interface_prot');
}

sub private_interface { shift->__error('interface_priv') }
sub public_interface { shift->__error('interface_publ') }

sub DESTROY {}


1;
