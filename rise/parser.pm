package rise::parser;

use strict;
use warnings;
use 5.008;
use utf8;

our $VERSION = '0.100';

my $cenv 						= {};

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
	return $self;
}

sub parse {
	(my $self, @_) = _class_ref(@_);
	my ($sourse, $PARSER)	= @_;
	print "\n";
	for my $parser (@{$PARSER->{parsers}}){
		$parser->{info} ||= 'PARSER RETURN';
		my $cnt = 22 - length $parser->{info};
		print " " x $cnt, $parser->{info}, " | ";
		# 1 while $sourse =~ s/$parser->{extractor}/&{$parser->{injector}}/gsxe;	# мутирует синтаксис в perl код ( компилируем Perl код)
		$sourse =~ s/$parser->{extractor}/&{$parser->{injector}}/gsxe;	# мутирует синтаксис в perl код ( компилируем Perl код)
		print "\n";
	}
	return $sourse;
}

sub _class_ref {
	my $self				= shift if (ref $_[0] eq __PACKAGE__);
	$self					||= $cenv;
	return $self, @_;
}

1;
