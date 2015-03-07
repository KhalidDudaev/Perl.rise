package rise::core::extends;
use strict;
use vars qw($VERSION);
$VERSION = '0.001';

my $ERROR_MESSAGES		= '';
 
sub import {
    my $class		= shift;
    my $child		= caller(0);
	my @parents		= @_;
	my $path;

	foreach my $parent (@parents) {
		$path		= $parent;
		$path		=~ s/::/\//g;
		warn "Class '$child' tried to inherit from itself\n" if $child eq $parent;
		require $path.".pm" if !grep($parent->isa($parent), ($child, @parents));
		#interface($parent, $child);
	}
 
    { no strict 'refs'; push @{"$child\::ISA"}, @parents; };
}

#sub interface {
#	no strict 'refs';
#	no warnings;
#	
#	my $interface 		= shift;
#	my $class			= shift;
# 
#	%{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, (%{$interface->interface}, %{$interface.'::IMPORT_INTERFACELIST'}));
#}

1;