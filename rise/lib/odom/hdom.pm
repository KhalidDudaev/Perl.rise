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
  # xml       => '',
  # hash      => {},
  xdom      => {}
};

my $parent          = '';
my $path            = '';
my $first           = 0;

# my $xdom    = {};

sub new {
  my $class         = ref $_[0] || $_[0];                                         # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                                # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                           # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                       # обьявляем класс и его свойства
}

sub parse {
  my $self          = shift;
  my $hash          = shift;
  $first            = shift || 0;
  my $pxdom         = {};
  my $arr           = ref $hash ne 'ARRAY' ? [$hash] : $hash;
  # delete $xdom->{xdom};
  $ENV_CLASS->{xdom} = {};
  $pxdom             = __hparse('/',$arr,'/');
  # say "########################## ". $self ." ########################";
  # say "########################## ". dump($pxdom) ." ########################";
  return $pxdom;
}

sub __hparse {
    my $key             = shift;
    my $array           = shift;
    my $path            = shift;
    my $idom            = {};
    my $plevel          = {};
    my $num             = 0;
    my $order           = 0;
    # my $name            = '';

    return $array if ref $array ne 'ARRAY';

    for my $k (@$array) {
        $order++;
        next if ref $k ne 'HASH' || !exists $k->{name};


        # say "#######################".dump($k)."#######################";
        # dump($k->{name});

        $num                = $plevel->{$k->{name}}++;
        $k->{path}          = $path . ' ' . $k->{name} . " [$num]" if $first;
        $k->{order}         = $order - 1;
        $k->{parent}        ||= $key;

        $idom               = __hparse($k->{name},$k->{content},$k->{path}) || {};
        %{$ENV_CLASS->{xdom}}  = (%{$ENV_CLASS->{xdom}}, %{$idom});

        push @{$ENV_CLASS->{xdom}{node}{$k->{name}}}, $k;                           #

        map {
          push @{$ENV_CLASS->{xdom}{attr}{$_}},  __hparse($k->{name},$k,$k->{path});                             #select node by attribute
          push @{$ENV_CLASS->{xdom}{attrValue}{$k->{attr}{$_}}},  __hparse($k->{name},$k,$k->{path});            #select node by attribute value
        } keys %{$k->{attr}};
    }

    # $ENV_CLASS->{xdom} = $dom->{xdom};
    # $ENV_CLASS->{xdom} = { xdom => $ENV_CLASS->{xdom} };
    return $ENV_CLASS->{xdom};
}

# sub attr {
#     my $k = shift;
#     map {
#       # my $key = $_ || '';
#       push @{$ENV_CLASS->{xdom}{id}{$_}},  __hparse($k->{name},$k,$num);
#       push @{$ENV_CLASS->{xdom}{attr}{$_}},  __hparse($k->{name},$k,$num);                             #select node by attribute
#       push @{$ENV_CLASS->{xdom}{attrValue}{$k->{attr}{$_}}},  __hparse($k->{name},$k,$num);            #select node by attribute value
#     } keys %{$k->{attr}};
# }

# sub clear {
#   $ENV_CLASS->{xdom} = {};
# }


sub test {
  'asdasdasddasdasdasdasd'
}

1;
