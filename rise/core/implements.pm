package rise::core::implements;
use strict;
use vars qw($VERSION);

use Data::Dump qw 'dump';

$VERSION = '0.001';

my $ERROR_MESSAGES		= '';

sub import {
    my $class		= shift;
    my $child		= caller(0);
	my @parents		= @_;
	my $path;

	
	
	foreach my $parent (@parents) {
		$path 		= $parent;
		$path 		=~ s/::/\//g;
		warn "Class '$child' tried to inherit from itself\n" if $child eq $parent;
		require $path.".pm" if !grep($parent->isa($parent), ($child, @parents));
		 interface_join($parent, $child);
	}
 
    { no strict 'refs';	push @{"$child\::ISA"}, @parents; };
}

# sub interface_join {
	# no strict 'refs';
	# no warnings;
	
	# my $interface 		= shift;
	# my $class			= shift;
	
	# # print "### $interface - $class ###\n";
 
	# %{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, (%{$interface->interface}, %{$interface.'::IMPORT_INTERFACELIST'}));
	# # print "### " . $interface . ' - ' . dump (\%{$class.'::IMPORT_INTERFACELIST'}) . " ###\n";
	# # print "### " . dump (\%{$interface.'::IMPORT_INTERFACELIST'}) . " ###\n";
# }

sub interface_join {
	no strict 'refs';
	no warnings;
	
	my $interface 		= shift;
	my $class			= shift;
	
	%{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, %{$interface.'::IMPORT_INTERFACELIST'});
	#print dump (\%{$class.'::IMPORT_INTERFACELIST'}), "\n";
	#print "### - " . dump (\%{$interface.'::IMPORT_INTERFACELIST'}) . "\n";
}

#sub interface_confirm {
#	no strict 'refs';
#	my $class				= shift;
#	my $objlist				= shift;
#	#my $child			= caller(2);
#	print "############ $class - $objlist ###########\n";
#
#	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
#	my @objnames 			= keys %$interfacelist;
#	my $obj_name;
#	my $obj_type;
#	my $obj_accmod;
#	#my $obj_tmpl;
#
#	#$objlist 				= $class->__OBJLIST__;
#	#$objlist->{variable}	= $class->__VARLIST__;
#	
#	foreach my $object (@objnames) {
#		($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
#		$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$object\b/);
#	}
#	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
#}

#sub implementation {
#	no strict 'refs';
#	my $class				= shift;
#	my $ERROR_MESSAGES;
#	#my $child			= caller(2);
#	#$class				= $class->__PACKAGE__;
#	print "############ $class ###########\n";
#
#	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
#	my @objnames 			= keys %$interfacelist;
#	my $objlist				= {};
#	my $obj_type;
#	my $obj_accmod;
#	my $obj_tmpl;
#	
#	
#	
#	$objlist->{objlist}	= $class->__OBJLIST__;
#	#$objlist->{variable}	= $class->__VARLIST__;
#	
#	foreach my $name (@objnames) {
#		#die "INTERFACE ERROR: Not created function $i in class $class" if ($codelist !~ m/$i/);
#		$obj_type			= $interfacelist->{$name}[0];
#		$obj_accmod			= $interfacelist->{$name}[1];
#		
#		$obj_tmpl			= $interfacelist->{$name}[1] . '_' . $interfacelist->{$name}[0] . '_' . $name;
#		
#		$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$name\" in class \"$class\"\n" if ($objlist->{objlist} !~ m/\b$obj_tmpl\b/);
#	}
#	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
#}



1;