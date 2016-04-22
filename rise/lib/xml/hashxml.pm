##################################### XML::HASH ################################
package rise::lib::xml::hashxml;

use strict;
use warnings;
use utf8;
use feature 'say';

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

sub xml {
  my $self          = shift;
  # my $obj           = shift;
  my $xml;

  grep {
      $xml .= __xml($_) if ref $_ eq 'HASH';
      $xml .= $_ if ref $_ ne 'HASH';
  } @{$self->{xdom}};

  # $xml              = __xml($array);

  return $xml;
}

sub __xml {
    my $hash       = shift;
    my $xml;

    # say "################## ".dump($hash)." ##################";

    $xml    .= '<'.$hash->{name} if ref $hash eq 'HASH';
    grep {
        $xml    .= ' ' . $_ .'="'. $hash->{attr}{$_} .'"';
    } keys %{$hash->{attr}};
    $xml    .= '>';

    grep {
        $xml .= __xml($_) if ref $_ eq 'HASH';
        $xml .= $_ if ref $_ ne 'HASH';
    } @{$hash->{content}};

    $xml    .= '</'.$hash->{name}.'>';

    # $xml = __xml($hash);

    return $xml;
}

1;
