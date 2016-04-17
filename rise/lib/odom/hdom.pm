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

my $parent          = '';
my $path            = '';
my $num             = 0;

# my $xdom    = {};

sub new {
  my $class         = ref $_[0] || $_[0];                                         # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                                # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                           # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                       # обьявляем класс и его свойства
}

sub parse {
  my $self          = shift;
  # my $key           = shift || '';
  my $hash          = shift;
  my $pxdom         = {};
  my $arr           = ref $hash ne 'ARRAY' ? [$hash] : $hash;
  # delete $xdom->{xdom};
  $ENV_CLASS->{xdom} = {};
  $pxdom             = __hparse('/',$arr,0);
  # say "########################## ". $self ." ########################";
  # say "########################## ". dump($pxdom) ." ########################";
  return $pxdom;
}

sub __hparse {
    my $key           = shift;
    my $array         = shift;
    my $order         = shift;

    # my $narray        = [];
    # my $ck;
    # my $content;
    # my $xdom          = {};
    # my $parent           = '';
    # my $lnum      = $num;
    my $num           = 0;
    # my $par           = $parent;

    # my $lpath          = '';

    return $array if ref $array ne 'ARRAY';

    for my $k (@$array) {
        # last if ref $k ne 'HASH' || !exists $k->{name} || ( $key and $k->{name} ne $key );
        next if ref $k ne 'HASH' || !exists $k->{name};

        # $parent             = $key || $k->{parent};
        # $parent             = $key || $k->{parent} if $num == 0;
        # $parent             = $k->{name};

        # $lpath              = $parent . '/' . $k->{name};
        # say "#######################".dump($k)."#######################";
        $k->{order}         = $num;
        $k->{parent}        ||= $key;
        # $k->{ref}           = $path. '/' . $lpath;

        # $key = $k->{name};

        $ENV_CLASS->{xdom}  = __hparse($k->{name},$k->{content},$num);
        push @{$ENV_CLASS->{xdom}{node}{$k->{name}}}, $k;                           #

        # $k->{name} = $k->{name} if !$num;
        # $parent = $k->{name};
        # attr($k);

        map {
        #   push @{$ENV_CLASS->{xdom}{id}{$_}},  __hparse($k->{name},$k,$num);
          push @{$ENV_CLASS->{xdom}{attr}{$_}},  __hparse($k->{name},$k,$num);                             #select node by attribute
          push @{$ENV_CLASS->{xdom}{attrValue}{$k->{attr}{$_}}},  __hparse($k->{name},$k,$num);            #select node by attribute value
        } keys %{$k->{attr}};

        # $par = $k->{name} if $num == 0;

        # $lpath               = $parent if $num == 0;
        $num++;
    }

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

sub clear {
  $ENV_CLASS->{xdom} = {};
}


sub test {
  'asdasdasddasdasdasdasd'
}

1;
