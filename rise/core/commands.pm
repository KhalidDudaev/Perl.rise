package rise::core::commands;

use strict;
use warnings;
use utf8;
our $VERSION = '0.000';

my $cenv					= {};

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
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
	
	
sub test {
	my $self = shift;
	'its working';
}

1;
