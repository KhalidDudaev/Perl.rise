package rise::object::abstract;
use strict;
use warnings;
use utf8;

use Data::Dump 'dump';

use parent 'rise::object::object';

our $VERSION			= '0.01';
my $VARS				= {};

my $ERROR_MESSAGES		= '';

my $ERROR				= {
	abstract				=> [ [ 0, 1 ], '"ABSTRACT ERROR: Abstract class \"$parent\" only extends at $file line $line\n"' ],
	abstract_inherit		=> [ 1, 4 ],
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
	#print "############ $class - $child - $interface ###########\n";
	
	my $h_i 			= $interface;
	my $h_ii 			= \%{$class.'::IMPORT_INTERFACELIST'};
	my $h_ci 			= \%{$child.'::IMPORT_INTERFACELIST'};
	
	%$h_i				= (%$h_i, %$h_ii);
	%$h_ci				= (%$h_ci, %$h_i);
	#print dump($h_ci) . "\n"; 
}

sub set_interface {
	no strict 'refs';
	no warnings;
	my $class			= shift;
	my $name			= shift;
	#my $h_i = shift;
	
	my $h_i				= { $name => 1 };
	my $h_ii 			= \%{$class.'::IMPORT_INTERFACELIST'};
	%$h_ii				= (%$h_ii, %$h_i);
	#print "### ".dump (\%$h_ii)." ###\n";
}

################################# access mod #################################
sub protected_abstract {
	my ($self)			= @_;

	#my $callercode			= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/g;
	#my $callercode_eval		= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/g;
	#
	#($callercode eq 'import' || $callercode_eval eq 'import') or $self->_error($ERROR->{interface});
	
	my $childcode			= (caller(2))[3];
	$childcode eq 'rise::core::extends::import' or $self->_error($ERROR->{abstract}); # protected interface with access mod
	
}

sub DESTROY {}


1;

