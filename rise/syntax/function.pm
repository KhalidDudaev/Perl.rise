package rise::syntax::class;

use strict;
use warnings;
use utf8;
our $VERSION = '0.000';

my $conf					= {};

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
	return bless($conf, $class);                         					# обьявляем класс и его свойства
}

sub test {
	my $self = shift;
	'its working';
}

1;
