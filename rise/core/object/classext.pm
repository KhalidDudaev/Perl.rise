package rise::core::object::classext;
use strict;
use warnings;
use utf8;

use feature 'say';
#use Data::Dump 'dump';

#use autobox::Core;
#local $\ = "\n";
#use overload
#  '""'	=> sub { @_ },
#  '0+'	=> sub { @_ };
#use rise::core::attribute;

use parent qw/
	rise::core::object::object
	rise::core::object::variable
/;

# use rise::core::ops::commands;

our $VERSION 	= '0.01';

my $ENV_CLASS		= {
	this_class		=> 'rise::core::object::class',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

sub new {
  my $class         = ref $_[0] || $_[0];                                       # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  return bless {}, $class;                                       				# обьявляем класс и его свойства
}

# sub new {
#   my $class         = ref $_[0] || $_[0];                                         # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   my $object        = $_[1] || {};                                                # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   %$object          = (%$ENV_CLASS, %$object);                                           # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
#   return bless($object, $class);                                       # обьявляем класс и его свойства
# }

# sub new {
# 	my $class			= ref $_[0]	|| $_[0];
# 	my $args			= $_[1]		|| {};
# 	%$args				= (%$ENV_CLASS, %$args);
# 	return bless $args, $class;
# }

# sub import {
# 	my $self	= shift;
# 	#autobox::Core->import;
# 	$self->__RISE_COMMANDS;
# }

sub import { no strict "refs";
	my $caller              = (caller(0))[0];
	my $self                = shift;

	# say '--------- classext ---------';
	# say "caller -> $caller";
	# say "self   -> $self";

	# package Puma::lib::fs; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','Puma::lib';   sub super { $Puma::lib::fs::ISA[1] } my $self = 'Puma::lib::fs'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-var-dir public-var-path public-var-file public-var-info'}
	# push @{$self.'::ISA'}, $caller, 'rise::core::object::object';
	# $self->__RISE_COMMANDS if $self ne 'rise::core::object::classext';

	if (exists &{$self."::__OBJLIST__"}){
		$self->interface_confirm($self->__OBJLIST__);
	}

	if (exists &{$self."::__EXPORT__"}){
		if (scalar @_ == 0) {
			$self->export(&{$self."::__EXPORT__"}->{':import'});
		}

		if ($_[0] && $_[0] ne ':noimport') {
			for (@_){
				$self->export(&{$self."::__EXPORT__"}->{$_});
			}
		}
	}

	__IMPORT__($caller, @_) if exists &__IMPORT__;
}

# sub self { args('self', @_) }
# sub args {
# 	my $index				= shift;
# 	my @args				= @_;
# 	return $args[0] if $index eq 'self';
# 	return $args[$index + 1];
# }

sub obj_type {'CLASS'}

sub export { no strict "refs";
	my $__CALLER_CLASS__	= (caller(1))[0];
	my $self                = shift;
	my $exports				= shift;
	for (@$exports){
		*{$__CALLER_CLASS__ . "::$_"} = \&{"$self::$_"};
		*{$__CALLER_CLASS__ . "::IMPORT::$_"} = \&{"$self::$_"};
	}
}

sub interface_confirm {
	no strict 'refs';
	no warnings;
	my $class				= caller(1);
	my $self				= shift;

	# my $class				= shift;
	#my $child			= caller(2);
	# print "############ interface conf - $class ############\n";

	my $objlist				= shift;

	# print "############ objlist - $objlist ############\n";

	# my $objlist				= '';
	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
	my @objnames 			= keys %$interfacelist;
	my $obj_name;
	my $obj_type;
	my $obj_accmod;
	my $msg_error			= '';

	$objlist 				||= '';
	# $objlist 				= $class->__OBJLIST__;

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
