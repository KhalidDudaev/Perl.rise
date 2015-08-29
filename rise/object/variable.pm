package rise::object::variable;
use strict;
use warnings;
use utf8;

our $VERSION 	= '0.01';

#use parent qw/rise::object::variable::type/;
use rise::object::variable::type;

#our $ERROR		= {
#	var_priv				=> [ [ 0, 1 ], '"VARIABLE ERROR: Can\'t access variable \"$func\" from \"$parent\" at $file line $line\n"' ],
#	var_prot				=> [ [ 0, 1 ], '"VARIABLE ERROR: Variable \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
#};



my $vt = new rise::object::variable::type;

my $atr = $vt->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule};

#{	no strict 'refs'; no warnings;
	#$vt->__RISE_TYPE_REGS = {
	#	type		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'TYPE') unless ${$_[0]} eq $rule_set || ${$_[0]} =~ m/^$rule_set/sx } ),
	#	#type		=> wizard ( set => sub { die "ERROR VARIABLE: Only TYPE value\n" unless ${$_[0]} =~ m/^$type_rule$/osx } ),
	#	numeric		=> wizard (	set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'NUMERIC') unless ref $_[0] eq 'SCALAR' && ${$_[0]} + 0; } ),
	#	array		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'ARRAY') unless (ref ${$_[0]} eq 'ARRAY')	} ),
	#	hash		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'HASH') unless ref ${$_[0]} eq 'HASH' } ),
	#};
#}

$vt->type_regs ('type'		=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'TYPE') unless ${$_[0]} eq $atr || ${$_[0]} =~ m/^$atr/sx }]);
$vt->type_regs ('numeric'	=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'NUMERIC') unless ref $_[0] eq 'SCALAR' && ${$_[0]} + 0; } ]);
$vt->type_regs ('array'		=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'ARRAY') unless (ref ${$_[0]} eq 'ARRAY')	} ]);
$vt->type_regs ('hash'		=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'HASH') unless ref ${$_[0]} eq 'HASH' } ]);

sub __RISE_CAST { my $self = shift; $vt->type_cast(@_) }

#$vartype->__RISE_TYPE_SETS('type', qr/\D+/);
#$vartype->__RISE_TYPE_SET('string', qr/\D+/);
#$vartype->__RISE_TYPE_SET('string', qr/\D+/);
#$vartype->__RISE_TYPE_SET('string', qr/\D+/);
#$vartype->__RISE_TYPE_SET('string', qr/\D+/);

sub obj_type {'variable'};
#sub val { shift->vl };

################################ ACCESS MODE #################################
#sub _private_var {
#	my $class			= shift;
#	my $class_caller	= shift || '???';
#	my $parent			= shift;
#	my $caller			= shift;
#	
#	print "\n###############################\
#class			- $class
#class_caller		- $class_caller
#parent			- $parent
#caller			- $caller
################################\n" if $class_caller ne '???';
#	
#	$parent =~ m/^$class.*$/ or $class->_error($ERROR->{var_priv});
#	#$class->can($caller) or $class->_error($ERROR->{var_priv});
#}
#
#sub _protected_var {
#	my $class			= shift;
#	my $class_caller	= shift || '???';
#	my $parent			= shift;
#	my $caller			= shift;
#	
#	print "\n###############################\
#class			- $class
#class_caller		- $class_caller
#parent			- $parent
#caller			- $caller
################################\n" if $class_caller ne '???';
#	
#	
#	$parent->isa($class) or  $class->_error($ERROR->{var_prot});
#}

sub private_var {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller =~ m/^$class.*$/ || $self->__error('var_priv', $class, $name, $caller);
}

sub protected_var {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller->isa($class) ||  $self->__error('var_prot', $class, $name, $caller);
}

sub public_var {}

sub DESTROY {}

1;

