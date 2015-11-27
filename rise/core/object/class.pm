package rise::core::object::class;
use strict;
use warnings;
use utf8;
use	rise::core::object::classext;

use feature 'say';
#use Data::Dump 'dump';

#use autobox::Core;
#local $\ = "\n";
#use overload
#  '""'	=> sub { @_ },
#  '0+'	=> sub { @_ };
#use rise::core::attribute;

# use parent qw/
# 	rise::core::object::classext
# /;


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
	our $caller              = (caller(0))[0];
	my $self                = shift;

	my ($parent)			= $caller =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;
	# say '--------- class ---------';
	# say "caller -> $caller";
	# say "parent -> $parent";
	# say "self   -> $self";

	# package Puma::lib::fs; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::class','Puma::lib';   sub super { $Puma::lib::fs::ISA[1] } my $self = 'Puma::lib::fs'; sub self { $self }; BEGIN { __PACKAGE__->__RISE_COMMANDS } __PACKAGE__->interface_confirm; sub __OBJLIST__ {'public-var-dir public-var-path public-var-file public-var-info'}
	push @{$caller.'::ISA'}, $parent, 'rise::core::object::classext';
	$caller->__RISE_COMMANDS;
}

sub DESTROY {}

1;
