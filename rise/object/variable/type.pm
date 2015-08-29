package rise::object::variable::type;

use strict;
use warnings;
use utf8;
our $VERSION = '0.000';

#use Data::Dump 'dump';
use Variable::Magic qw/wizard cast/;

#my $ENV_CLASS					= {};

use parent qw/
	rise::object::object
	rise::object::error
/;

my $types						= {};

my $rule_set				= '';

#__PACKAGE__->__RISE_TYPE_REGS 				= '';

#{	no strict 'refs'; no warnings;
#	__PACKAGE__->__RISE_ENV->{VARIABLE}{TYPE} = {
#		type		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'TYPE') unless ${$_[0]} =~ m/^$rule_set/sx } ),
#		#type		=> wizard ( set => sub { die "ERROR VARIABLE: Only TYPE value\n" unless ${$_[0]} =~ m/^$type_rule$/osx } ),
#		numeric		=> wizard (	set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'NUMERIC') unless ref $_[0] eq 'SCALAR' && ${$_[0]} + 0; } ),
#		array		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'ARRAY') unless (ref ${$_[0]} eq 'ARRAY')	} ),
#		hash		=> wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'HASH') unless ref ${$_[0]} eq 'HASH' } ),
#	};
#}

#__PACKAGE__->__RISE_TYPE_REGS ('type'		=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'TYPE') unless ${$_[0]} eq $rule_set || ${$_[0]} =~ m/^$rule_set/sx } ] );

sub type_cast { no strict 'refs';
	my $self		= shift;
	my $type		= shift;
	my $var_ref		= shift;
	
	$self->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule} = shift;
	cast $$var_ref, $self->__RISE_ENV->{VARIABLE}{TYPE}{$type};
	
	#my $rule_set	= shift;
	#__cast ($self, $type, $var_ref, $rule_set);
}

sub type { no strict 'refs';
	my $self		= shift;
	my $type		= shift;
	my $rule		= shift;
	
	$self->__RISE_ENV->{VARIABLE}{TYPE}{$type} = wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', $type) unless ${$_[0]} =~ m/^$rule$/sx} );
	
	#print "############################ $type - $rule\n".dump ($ypes)."\n";
	return 1;
}

sub type_regs {
	my $self		= shift;
	my $name		= shift;
	my $rule		= shift;
	$self->__RISE_ENV->{VARIABLE}{TYPE}{$name} = wizard (@$rule);
}

#sub __cast {
#	my $self		= shift;
#	my $type		= shift;
#	my $var_ref		= shift;
#	$self->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule} = shift;
#	
#	cast $$var_ref, $self->__RISE_ENV->{VARIABLE}{TYPE}{$type};
#	return 1;
#}



1;
