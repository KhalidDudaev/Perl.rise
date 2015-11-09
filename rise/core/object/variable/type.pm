package rise::core::object::variable::type;

use strict;
use warnings;
use utf8;

use parent qw/
	rise::core::object::object
/;

#use Data::Dump 'dump';
use Variable::Magic qw/wizard cast/;

our $VERSION = '0.000';

my $ENV_CLASS					= {};
my $types						= {};

my $rule_set				= '';

sub type { no strict 'refs';
	my $self		= shift;
	my $type		= shift;
	my $rule		= shift;

	#$self->__RISE_ENV->{VARIABLE}{TYPE}{$type} = wizard ( set => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', $type) unless ${$_[0]} =~ m/^$rule$/sx} );
	$self->type_regs ($type		=> [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', $type) unless ${$_[0]} =~ m/^$rule$/sx}]);

	return 1;
}

sub type_regs {
	my $self		= shift;
	my $name		= shift;
	my $rule		= shift;

	#$self->__RISE_ENV->{VARIABLE}{TYPE}{$name} = wizard (@$rule);
	$ENV_CLASS->{VARIABLE}{TYPE}{$name} = wizard (@$rule);
}

sub type_cast { no strict 'refs';
	my $self		= shift;
	my $type		= shift;
	my $var_ref		= shift;

	#$self->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule} = shift;

	#cast $$var_ref, $self->__RISE_ENV->{VARIABLE}{TYPE}{$type};
	cast $$var_ref, $ENV_CLASS->{VARIABLE}{TYPE}{$type} || __PACKAGE__->__RISE_ERR('VAR_CAST_UNDEFINE', $type);
}

1;
