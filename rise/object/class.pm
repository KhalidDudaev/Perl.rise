package rise::object::class;
use strict;
use warnings;
use utf8;

#use autobox::Core;
#use Data::Dump 'dump';
#local $\ = "\n";
#use overload
#  '""'	=> sub { @_ },
#  '0+'	=> sub { @_ };
#use rise::core::attribute; 

use parent qw/
	rise::object::object
	rise::object::variable
/;

our $VERSION 	= '0.01';

my $ENV_CLASS		= {
	this_class		=> 'rise::object::class',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

sub import {
	my $self	= shift;
	#autobox::Core->import;
	$self->__RISE_COMMANDS;
}
			
sub self { shift }
sub obj_type {'CLASS'}

sub interface_confirm {
	no strict 'refs';
	no warnings;
	my $class				= shift; #caller(2);
	#my $child			= caller(2);
	#print "############ $class ###########";

	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
	my @objnames 			= keys %$interfacelist;
	my $objlist				= '';
	my $obj_name;
	my $obj_type;
	my $obj_accmod;
	my $msg_error			= '';

	$objlist 				= $class->__OBJLIST__;

	foreach my $object (@objnames) {
		($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
		$msg_error .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$object\b/);
	}
	
	if ($msg_error ne '') {
		$msg_error			= "################################ ERROR ##################################\n"
			.$msg_error
			."\n#########################################################################\n\n";
		die $msg_error;
	}
	1;
}

################################# ACCESS MODE #################################
sub private_class {
	my ($self)			= @_;
	my $starter			= (caller(4))[3] || 'RUN';
	my $callercode		= (caller(2))[3] || 'PRIV 2'; #$callercode			=~ s/.*::(\w+)/$1/g;
	my $callercode_eval	= (caller(3))[3] || 'PRIV 3'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	
	#my $caller0			= (caller(0))[3] || 'PRIV 0'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller1			= (caller(1))[3] || 'PRIV 1'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller2			= (caller(2))[3] || 'PRIV 2'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller3			= (caller(3))[3] || 'PRIV 3'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller4			= (caller(4))[3] || 'PRIV 4'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	
	my $access			= ($callercode eq 'import' || $callercode_eval eq 'import') ? 'class_priv_inherit' : 'class_priv';
	
	#print ">>> $access - $starter - $callercode - $callercode_eval \n";
	#print ">>> $caller0 - $caller1 - $caller2 - $caller3 - $caller4 \n";
	
	$starter eq 'RUN' || $self->__RISE_ERR($access);
}

sub protected_class {
	my ($self)			= @_;
	my $callercode		= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/;
	my $callercode_eval	= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/;
	
	#print ">>>>>>>>>>>>> $callercode\n";
	
	($callercode eq 'import' || $callercode_eval eq 'import') || $self->__RISE_ERR('class_prot');
}

sub public_class {}

sub extends_error {
	shift->__RISE_ERR('class_inherits');
}

sub DESTROY {}

1;

