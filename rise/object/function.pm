package rise::object::function;
use strict;
use warnings;
use utf8;

use Data::Dump 'dump';

our $VERSION 	= '0.01';

#my $ERROR		= {
#	code_priv				=> [ [ 1, 2 ], '"FUNCTION ERROR: Can\'t access function \"$func\" from \"$parent\" at $file line $line\n"' ],
#	code_prot				=> [ [ 1, 2 ], '"FUNCTION ERROR: Function \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
#};
#

sub obj_type {'FUNCTION'};

################################# ACCESS MODE #################################
#sub _private_code {
#	my $class			= shift;
#	my $parent			= shift;
#	my $caller			= shift;
#	
#	print "################################
#	class	- $class
#	parent	- $parent
#	caller	- $caller
#	################################";
#	
#	$class =~ m/$caller.*/ or $class->_error($ERROR->{code_priv});
#}
#
#sub _protected_code {
#	my ($self)			= @_;
#	my $class			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
#	my $caller			= (caller(2))[0];	#$caller		=~ s/(.*)::\w+/$1/; 	# ----------------------- $caller обязателен
#	$caller->isa($class) or  $self->_error($ERROR->{code_prot});
#}

sub private_code {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller =~ m/$class.*/ || $self->__error('code_priv', $class, $name, $caller);
}

sub protected_code {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller->isa($class) ||  $self->__error('code_prot', $class, $name, $caller);
}

sub public_code {}

#sub __class_ref {
#	my $function		= shift;
#	my $class			= caller(0);
#	my $caller			= caller(1);
#	my $this			= ref $_[0] || $_[0] || '';
#
#	shift if ($caller =~ /$this/ || $class =~ /$this/);
#	return @_;
#}

sub __class_ref {
	my $self = shift;
	(ref $_[0] eq __PACKAGE__) ? $self = shift : $self = caller(1);
	return $self, @_;
}

#sub __class_ref {
#	my $this					= shift if (ref $_[0] eq __PACKAGE__);
#	$this						||= $conf;
#	return $this, @_;
#}

#sub __class_ref {
#	my $function		= shift;
#	my $class			= caller(0);
#	my $parent			= caller(1);
#	
#	my $this			= ref $_[0] || $_[0] || '';
#	shift if $this eq $class || $this eq $parent;
#	return @_;
#}

#sub __class_ref {
#	my $function		= shift;
#	my $class			= caller(1);
#	my $parent			= caller(2);
#	my $this			= ref $_[0] || $_[0] || '';
#	shift if $this eq $class || $this eq $parent;
#	return @_;
#}

#sub __class_ref {
#	shift;
#	my $class	= caller(1);
#	my $self	= ref $_[0] || $_[0] || '';
#	shift if $class eq $self;
#	@_;
#}

sub DESTROY {}

1;

