package rise::core::object::variable;
use strict;
use warnings;
use utf8;

use parent qw/
	rise::core::object::object
/;

use rise::core::object::variable::type;

our $VERSION 	= '0.01';

my $vt = new rise::core::object::variable::type;

my $atr; # = $vt->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule} || '';
# print "\n>>>>>>>>>>>>>>>> 1 $vt <<<<<<<<<<<<<<<<\n";
{ no warnings;
	$vt->type_regs ('type'     => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'type')     unless ${$_[0]} eq $atr || ${$_[0]} =~ m/^$atr/sx }]);
	$vt->type_regs ('object'   => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'object')   unless ref $_[0] && ${$_[0]} =~ m/\w+(::\w+)*\=HASH\(0x[0-9a-f]{7}\)/; }]);
	$vt->type_regs ('number'   => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'number')   unless ref $_[0] eq 'SCALAR' && ${$_[0]} + 0; }]);
	$vt->type_regs ('string'   => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'string')   unless ref $_[0] eq 'SCALAR' && (${$_[0]} =~ m/\D+/ || ${$_[0]} eq ''); }]);
	$vt->type_regs ('array'    => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'array')    unless ref ${$_[0]} eq 'ARRAY' }]);
	$vt->type_regs ('hash'     => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'hash')     unless ref ${$_[0]} eq 'HASH' }]);
}
# print "\n>>>>>>>>>>>>>>>> 2 $vt <<<<<<<<<<<<<<<<\n";

sub __RISE_CAST {
	# print "\n>>>>>>>>>>>>>>>> 3 $vt <<<<<<<<<<<<<<<<\n";
	my $self		= shift;
	my $type		= shift;
	my $var_ref		= shift;

	$atr			= shift;
	#$self->__RISE_ENV->{VARIABLE}{TYPE}{anytype_rule} = shift;


	$vt->type_cast($type, $var_ref) || __PACKAGE__->__RISE_ERR('VAR_CAST_UNDEFINE', $type);
}

sub obj_type {'variable'};


sub DESTROY {}

1;
