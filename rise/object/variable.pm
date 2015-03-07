package rise::object::variable;
use strict;
use warnings;
use utf8;

our $VERSION 	= '0.01';

my $ERROR		= {
	var_priv				=> [ [ 0, 1 ], '"VARIABLE ERROR: Can\'t access variable \"$func\" from \"$parent\" at $file line $line\n"' ],
	var_prot				=> [ [ 0, 1 ], '"VARIABLE ERROR: Variable \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
};

################################ ACCESS MODE #################################
sub _private_var {
	my $class			= shift;
	my $class_caller	= shift || '???';
	my $parent			= shift;
	my $caller			= shift;
	
	print "\n###############################\
class			- $class
class_caller		- $class_caller
parent			- $parent
caller			- $caller
###############################\n" if $class_caller ne '???';
	
	$parent =~ m/^$class.*$/ or $class->_error($ERROR->{var_priv});
	#$class->can($caller) or $class->_error($ERROR->{var_priv});
}

sub _protected_var {
	my $class			= shift;
	my $class_caller	= shift || '???';
	my $parent			= shift;
	my $caller			= shift;
	
	print "\n###############################\
class			- $class
class_caller		- $class_caller
parent			- $parent
caller			- $caller
###############################\n" if $class_caller ne '???';
	
	
	$parent->isa($class) or  $class->_error($ERROR->{var_prot});
}

sub private_var {
	my ($self)			= @_;
	my $class			= (caller(0))[0];	#$class		=~ s/(.*)::\w+/$1/;
	my $caller			= (caller(1))[0];	#$caller		=~ s/(.*)::\w+/$1/;
	$caller =~ m/^$class.*$/ or $self->_error($ERROR->{var_priv});
}

sub protected_var {
	my ($self)			= @_;
	my $class			= (caller(0))[0];	#$class		=~ s/(.*)::\w+/$1/;
	my $caller			= (caller(1))[0];	#$caller		=~ s/(.*)::\w+/$1/; 	# ----------------------- $caller обязателен
	$caller->isa($class) or  $self->_error($ERROR->{var_prot});
}

sub public_var {}

sub DESTROY {}

1;

