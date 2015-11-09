package rise::core::object::interface;
use strict;
use warnings;
use utf8;

#use Data::Dump 'dump';
#local $\ = "\n";

use parent 'rise::core::object::object', 'rise::core::object::error';

#my $ERROR				= {
#	interface				=> [ [ 0, 1 ], '"INTERFACE ERROR: Interface \"$parent\" only implements at $file line $line\n"' ],
#	interface_inherit		=> [ 1, 4 ],
#};

my $ERROR_MESSAGES		= '';

sub obj_type {'INTERFACE'};

sub interface_join {
	no strict 'refs';
	no warnings;
	
	#my $self			= shift;
	my $interface 		= shift;
	my $class			= caller(2); #shift;
	
	#print ">>>>>>>>>> $interface <<<<<<<<<<\n";
	#print "\n###### interface - $interface | class - $class ######\n";
	
	%{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, %{$interface.'::IMPORT_INTERFACELIST'});
	
	#interface_confirm($class);
	
	#print dump (\%{$class.'::IMPORT_INTERFACELIST'}), "\n";
	#print "### - " . dump (\%{$interface.'::IMPORT_INTERFACELIST'}) . "\n";
}

#sub interface_confirm {
#	no strict 'refs';
#	my $class				= shift;
#	#my $child			= caller(2);
#	print "############ $class ###########";
#
#	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
#	my @objnames 			= keys %$interfacelist;
#	my $objlist;
#	my $obj_name;
#	my $obj_type;
#	my $obj_accmod;
#	#my $obj_tmpl;
#	
#	print "### - " . dump $interfacelist;
#	print "\n";
#
#	if (${$class.'::__OBJLIST__'}) {
#		#$objlist 				= $class->__OBJLIST__ if exists &{$class.'::__OBJLIST__'};
#		$objlist 				= ${$class.'::__OBJLIST__'};
#		$objlist ||= '';
#		#$objlist->{variable}	= $class->__VARLIST__;
#
#	print ">>>>>>> " . $objlist;
#	print "\n";
#	
#		foreach my $object (@objnames) {
#			($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
#			
#			#print " --- ############ $object ###########\n";
#			
#			$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$object\b/);
#		}
#	}
#	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
#}

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

sub interface_compare {
	my $interface		= shift;
	my $name			= shift;
	my $class			= caller(2);
	print ">>>>>>>>> interface - $interface | class - $class | name - $name\n";
	
	my $objlist 		= $class->__OBJLIST__;
	
	my($obj_accmod, $obj_type, $obj_name) = $name =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
	
	#print " --- ############ $object ###########\n";
	
	$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$name\b/);
	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
}

################################# access mod #################################

#sub protected_interface {
#	my ($self)			= @_;
#
#	#my $callercode			= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/g;
#	#my $callercode_eval		= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/g;
#	#
#	#($callercode eq 'import' || $callercode_eval eq 'import') or $self->_error($ERROR->{interface});
#	
#	my $childcode			= (caller(2))[3];
#	$childcode eq 'rise::core::ops::implements::import' or $self->_error($ERROR->{interface}); # protected interface with access mod
#	
#}

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

