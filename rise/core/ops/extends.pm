package rise::core::ops::extends;
use strict;
use vars qw($VERSION);

$VERSION = '0.001';

my $ERROR_MESSAGES		= '';
 
sub import {
	no strict;
    my $class		= shift;
    my $child		= caller(0);
	my @parents		= @_;
	my $path;

	foreach my $parent (@parents) {
		$path		= $parent;
		$path		=~ s/::/\//g;
		warn "Class '$child' tried to inherit from itself\n" if $child eq $parent;
		require $path.".pm" if !grep($parent->isa($parent), ($child, @parents));
		#interface_join($parent, $child) if (exists &{$parent.'::obj_type'} && ($parent->obj_type eq 'ABSTRACT' || $parent->obj_type eq 'INTERFACE'));
		
		#print ">>>>>>>>>> $parent <<<<<<<<<<\n";
		
		#$parent->interface_join($child) if exists &{$parent.'::interface_join'};
		
	}
	
	#$class->interface_confirm if exists &{$class.'::interface_confirm'};
 
    { no strict 'refs'; push @{"$child\::ISA"}, @parents; };
}

#sub interface_join {
#	no strict 'refs';
#	no warnings;
#	
#	my $interface 		= shift;
#	my $class			= shift;
#	
#	%{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, %{$interface.'::IMPORT_INTERFACELIST'});
#	
#	#print dump (\%{$class.'::IMPORT_INTERFACELIST'}), "\n";
#	#print "### - " . dump (\%{$interface.'::IMPORT_INTERFACELIST'}) . "\n";
#}

1;