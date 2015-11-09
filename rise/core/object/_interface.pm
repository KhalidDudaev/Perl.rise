package rise::core::object::interface;
use strict;
use warnings;
use utf8;

use parent 'rise::core::object::object';

our $VERSION			= '0.01';
my $VARS				= {};

my $ERROR_MESSAGES		= '';

my $ERROR				= {
	interface				=> [ [ 0, 1 ], '"INTERFACE ERROR: Interface \"$parent\" only implements at $file line $line\n"' ],
	interface_inherit		=> [ 1, 4 ],
};

#die "INTERFACE ERROR: Interface $interface only implements or extends" if $parent ne 'parent';
#die "INTERFACE ERROR: Interface $class only implements or extends" if $func ne 'rise::extends::import';
#implements();

sub interface_confirm {
	no strict 'refs';
	my $class				= shift;
	#my $child			= caller(2);
	#print "############ $class ###########\n";

	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
	my @objnames 			= keys %$interfacelist;
	my $objlist;
	my $obj_name;
	my $obj_type;
	my $obj_accmod;
	#my $obj_tmpl;

	$objlist 				= $class->__OBJLIST__;
	#$objlist->{variable}	= $class->__VARLIST__;
	
	foreach my $object (@objnames) {
		($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
		$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$object\b/);
	}
	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
}

sub interface {

	no strict 'refs';
	no warnings;
	
	my $class 			= shift;
	my $interface		= shift;
	my $child			= caller(2);
	
	################################## access mod #################################
	#my $childcode			= (caller(2))[3];
	#$childcode eq 'rise::implements::import' or $class->_error($ERROR->{interface}); # protected interface with access mod
	
	#print "############ $interface - $child - $callercode - $callercode_eval ###########\n";
	
	my $h_i 			= $interface;
	my $h_ii 			= \%{$class.'::IMPORT_INTERFACELIST'};
	my $h_ci 			= \%{$child.'::IMPORT_INTERFACELIST'};
	
	%$h_i				= (%$h_i, %$h_ii);
	%$h_ci				= (%$h_ci, %$h_i);
	#print dump($h_ci) . "\n"; 
}

sub off_interface {

	no strict 'refs';
	no warnings;
	
	my $class 			= shift;
	my $interface		= shift;
	my $child			= caller(2);
	
	################################## access mod #################################
	#my $childcode			= (caller(2))[3];
	#$childcode eq 'rise::implements::import' or $class->_error($ERROR->{interface}); # protected interface with access mod
	
	#print "############ $interface - $child - $callercode - $callercode_eval ###########\n";
	
	my $h_i 			= $interface;
	my $h_ii 			= \%{$class.'::IMPORT_INTERFACELIST'};
	my $h_ci 			= \%{$child.'::IMPORT_INTERFACELIST'};
	
	%$h_i				= (%$h_i, %$h_ii);
	%$h_ci				= (%$h_ci, %$h_i);
	#print dump($h_ci) . "\n"; 
}

sub add {
	no strict 'refs';
	no warnings;
	my $class = shift;
	my $h_i = shift;
	my $h_ii 			= \%{$class.'::INTERFACELIST'};
	%$h_ii				= (%$h_ii, %$h_i);
}

################################# access mod #################################
sub protected_interface {
	my ($self)			= @_;

	#my $callercode			= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/g;
	#my $callercode_eval		= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/g;
	#
	#($callercode eq 'import' || $callercode_eval eq 'import') or $self->_error($ERROR->{interface});
	
	my $childcode			= (caller(2))[3];
	$childcode eq 'rise::implements::import' or $self->_error($ERROR->{interface}); # protected interface with access mod
	
}


#END { &implement }

sub DESTROY {}


1;

