package rise::core::commands;

use strict;
use warnings;
use utf8;
our $VERSION = '0.000';

my $cenv					= {};
my @export_list 			= qw/
	__RISE_A2R
	__RISE_H2R
	__RISE_R2A
	__RISE_R2H
	__RISE_2R
	__RISE_R2
/;

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

sub __RISE_COMMANDS { no strict 'refs';
	my $self	= shift;

	for (@export_list) {
		*{$self . "::$_"} = *$_;
	}
}

sub clone {
	my $var = shift;
	my $vt = ref $var;
	my $data;
	
	$$data = $$var if $vt eq 'SCALAR';
	@$data = @$var if $vt eq 'ARRAY';
	%$data = %$var if $vt eq 'HASH';
	&$data = &$var if $vt eq 'CODE';
	*$data = *$var if $vt eq 'GLOB';
	
	return $data;
}

sub __RISE_A2R {\@_}
sub __RISE_H2R {+{@_}}
sub __RISE_R2A {@{$_[0]}}
sub __RISE_R2H {%{$_[0]}}

sub __RISE_2R { no strict;
	return +[@_] if ${__PACKAGE__."::__VARTYPE__"} eq 'ARRAY';
	return +{@_} if ${__PACKAGE__."::__VARTYPE__"} eq 'HASH';
}

sub __RISE_R2 { no strict;
	my $var = shift;
	${__PACKAGE__."::__VARTYPE__"} = ref $var;

	return $$var if ${__PACKAGE__."::__VARTYPE__"} eq 'SCALAR';
	return @$var if ${__PACKAGE__."::__VARTYPE__"} eq 'ARRAY';
	return %$var if ${__PACKAGE__."::__VARTYPE__"} eq 'HASH';
	return &$var if ${__PACKAGE__."::__VARTYPE__"} eq 'CODE';
	return *$var if ${__PACKAGE__."::__VARTYPE__"} eq 'GLOB';
}

sub test {
	my $self = shift;
	'its working';
}

1;
