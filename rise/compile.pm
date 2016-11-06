package rise::Compile;

use strict;
use warnings;
use utf8;

use lib qw |
../
../lib/
../lib/rise/
|;

use rise::lib::grammar;
use rise::syntaxNew;
use rise::file;

our $VERSION = '0.000';

local $\ = "\n";

my $cenv					= {};
my $sfname					= 'mycode.sclass';

my $grammar	= new rise::lib::grammar;
my $syntax	= new rise::syntaxNew;
my $file	= new rise::file;

my $source	= $file->file('read', $sfname);
my $code	= $grammar->parse($source, $syntax->syntax);

eval $code;
print "\nERROR: $@" if $@;
print $code;

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

#sub __file	{ $file->file(@_) }

1;
