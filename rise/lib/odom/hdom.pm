######################################## lib::ODOM::HDOM ########################################
package rise::lib::odom::hdom;

use strict;
use warnings;
use utf8;
use feature 'say';
# use parent 'rise::object::class';
use Data::Dump 'dump';

our $VERSION = '0.000';

my $ENV_CLASS          = {
  xml       => '',
  hash      => {},
  xdom      => {}
};

# my $xdom    = {};

sub new {
  my $class         = ref $_[0] || $_[0];                                         # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                                # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                           # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                       # обьявляем класс и его свойства
}

sub parse {
  my $self          = shift;
  my $key           = shift || '';
  my $hash          = shift;
  my $pxdom         = {};
  my $arr           = ref $hash ne 'ARRAY' ? [$hash] : $hash;
  # delete $xdom->{xdom};
  $ENV_CLASS->{xdom} = {};
  $pxdom             = __hparse($key,$arr);
  # say "########################## ". $self ." ########################";
  # say "########################## ". dump($pxdom) ." ########################";
  return $pxdom;
}

sub __hparse {
  my $key           = shift || '';
  my $array         = shift;
  my $narray        = [];
  my $ck;
  my $content;
  # my $xdom          = {};
  return $array if ref $array ne 'ARRAY';
  for my $k (@$array) {
    last if ref $k ne 'HASH' || !exists $k->{name} || ( $key and $k->{name} ne $key );

    # say "#######################".dump($k)."#######################";

    # push @{$array},  __hparse3('',$k->{content});
    # push @{$xdom->{node}{$k->{name}}},  __hparse('',$k->{content});             #
    push @{$ENV_CLASS->{xdom}{node}{$k->{name}}},  $k;

    # __hparse($key,$k->{content});
    $ENV_CLASS->{xdom} = __hparse($key,$k->{content});
    # push @{$ENV_CLASS->{xdom}->{node}{$k->{name}}}, $k;             #
    # push @{$ENV_CLASS->{xdom}->{content}{$k->{name}}},   __hparse('',$k);

    # map {
    #   # my $key = $_ || '';
    #   push @{$ENV_CLASS->{xdom}->{node}{$_}}, [__hparse('',$k)];                             #select node by attribute
    #   # push @{$ENV_CLASS->{xdom}->{attrValue}{$k->{attr}{$_}}},  __hparse('',$k);            #select node by attribute value
    # } keys %{$k};

    map {
      # my $key = $_ || '';
      push @{$ENV_CLASS->{xdom}{id}{$_}},  __hparse($key,$k);
      push @{$ENV_CLASS->{xdom}{attr}{$_}},  __hparse($key,$k);                             #select node by attribute
      push @{$ENV_CLASS->{xdom}{attrValue}{$k->{attr}{$_}}},  __hparse($key,$k);            #select node by attribute value
    } keys %{$k->{attr}};
  }
  # $ENV_CLASS->{xdom} = { xdom => $ENV_CLASS->{xdom} };
  return $ENV_CLASS->{xdom};
}

sub clear {
  $ENV_CLASS->{xdom} = {};
}


sub test {
  'asdasdasddasdasdasdasd'
}
