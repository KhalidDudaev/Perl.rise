##################################### XML ######################################
package rise::lib::xml;
use strict;
use warnings;
use utf8;
use feature 'say';
use rise::lib::xml::hash;
use rise::lib::odom;
# use rise::lib::xml::hash;

use Data::Dump 'dump';

our $VERSION = '0.000';

my $ENV_CLASS          = {
  xml       => '',
  hash      => {}
};

sub new {
  my $class         = ref $_[0] || $_[0];                                       # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                              # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                  # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                                # обьявляем класс и его свойства
}


sub parse {
  my $self          = shift;
  my $xml           = shift;
  my $xhash         = new rise::lib::xml::hash;
  my $odom          = new rise::lib::odom;
  my $xml_hash      = $xhash->parse($xml);
  my $xdom          = $odom->parse('',$xml_hash);

  # $xdom->{xhash}    = $xml_hash;

  # say "########################## ". dump($xdom) ." ########################";

  return $xdom;
}




1;
