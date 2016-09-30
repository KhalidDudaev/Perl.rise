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
	$vt->type_regs ('type'     => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'type')		unless ${$_[0]} eq $atr || ${$_[0]} =~ m/^$atr/sx }]);
	$vt->type_regs ('num'      => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'num')	unless ref $_[0] eq 'SCALAR' && ${$_[0]} + 0; }]);
	$vt->type_regs ('str'      => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'str')	unless ref $_[0] eq 'SCALAR' && (${$_[0]} =~ m/\D+/ || ${$_[0]} eq ''); }]);
	$vt->type_regs ('arr'      => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'arr')	unless ref ${$_[0]} eq 'ARRAY'	}]);
	$vt->type_regs ('hsh'      => [ 'set' => sub { __PACKAGE__->__RISE_ERR('VAR_CAST', 'hsh')		unless ref ${$_[0]} eq 'HASH' }]);
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
