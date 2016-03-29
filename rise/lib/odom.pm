######################################## lib::odom #######################################
package rise::lib::odom;
use strict;
use warnings;
use utf8;
use feature 'say';
use rise::lib::odom::hdom;
use Data::Dump 'dump';
use Clone 'clone';

our $VERSION = '0.000';

my $ENV_CLASS          = {
    xml     => '',
    hash    => {},
    xdom    => {},
    direct  => '',
    # root    => {},
};

my $ROOT;

# my $xdom    = {};
my $hdom            = new rise::lib::odom::hdom;

sub new {
  my $class         = ref $_[0] || $_[0];                                       # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                              # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                  # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                                # обьявляем класс и его свойства
}

sub parse {
  my $self          = shift;
  my $key           = shift || '';
  my $hash          = shift;
  # my $xdom          = {};
  # my $hdom          = new lib::odom::hdom;
  # $hdom->clear;
  $ROOT             = $hdom->parse($key,$hash);

  $self             = $self->reparse($key,$hash);

  # say "########################## ". dump($self->{xdom}) ." ########################";

  # return bless { xdom => $self->{xdom}, root => $ENV_CLASS->{root} }, ref $self;
  return $self;
}

sub reparse {
  my $self          = shift;
  my $key           = shift || '';
  my $hash          = shift;
  # my $xdom          = {};
  # my $hdom          = new lib::odom::hdom;
  # $hdom->clear;
  # $ENV_CLASS->{root} = $hdom->reparse($key,$hash) if !$ENV_CLASS->{root};

  $self->{xdom}     = $hdom->parse($key,$hash);

  # say "########################## ". dump($self->{xdom}) ." ########################";

  return bless { xdom => $self->{xdom}, root => $ENV_CLASS->{root} }, ref $self;
  # return bless $self, ref $self;
}

sub xdom {
  my $self          = shift;
  return $self->{xdom};
}

sub root {
    my $self          = shift;
    $self->{xdom}   = $ROOT;
    return $self;
}

sub id {
  my $self          = shift;
  my $id            = shift;
  my $res           = $self->attr('id')->attrValue($id);
  return  $res;
}

sub class {
  my $self          = shift;
  my $class            = shift;
  my $res           = $self->attr('class')->attrValue($class);
  return  $res;
}

sub node {
    my $self        = shift;
    my $node        = shift;

    $ENV_CLASS->{selected}{node} = $node;
    $ENV_CLASS->{selected}{attr} = '';
    $ENV_CLASS->{selected}{path} .= ' ' . $node;

    $self           = $self->new->reparse($node,$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

    @{$self->{xdom}{node}{$node}} = [grep $_->{parent} eq  $ENV_CLASS->{direct}, @{$self->{xdom}{node}{$node}}] if $ENV_CLASS->{direct} ne '';

    return  bless ({ root => $self->{root}, xdom => $self->{xdom}{node}{$node}, xpath => $ENV_CLASS->{selected}{path} }, ref $self);

    # my $lself           = $self->new->reparse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    #
    # $lself->{xdom}       = $lself->{xdom}{node}{$node};
    # $lself->{xpath}      = $ENV_CLASS->{selected}{path};
    # # $self->{xpath}      = $ENV_CLASS->{selected}{path};
    #
    # %$self = (%$lself,%$self);
    #
    # return  bless ($self, ref $self);
}

sub attr {
  my $self          = shift;
  my $attr          = shift;

  $ENV_CLASS->{selected}{attr} = $attr;
  $ENV_CLASS->{selected}{path} .= ' @' . $attr;

  $self             = $self->new->reparse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

  return bless { root => $self->{root}, xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub attrValue {
  my $self          = shift;
  my $attrVal       = shift;
  my $node_arr      = [];

  $ENV_CLASS->{selected}{path} .= '="' . $attrVal . '"';

  $self = $self->new->reparse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

  # return bless { root => $ENV_CLASS->{root}, xdom => $self->{xdom}{attrValue}{$attrVal} }, ref $self;

  $node_arr = $self->{xdom}{attrValue}{$attrVal};

  if ($ENV_CLASS->{selected}{attr}) {
    $node_arr = [];
    foreach my $n (@{$self->{xdom}{attr}{$ENV_CLASS->{selected}{attr}}}) {
        push @{$node_arr}, $n if $n->{attr}{$ENV_CLASS->{selected}{attr}} eq $attrVal;
    }
  }

  # say "########################## ". $ENV_CLASS->{selected}{attr} ." ########################";

  return bless { root => $self->{root}, xdom => $node_arr, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub direct {
    my $self          = shift;

    $ENV_CLASS->{selected}{path} .= ' >';
    $ENV_CLASS->{direct} = $ENV_CLASS->{selected}{node};
    return $self;
}

sub index {
  my $self          = shift;
  my $index         = shift;

  $ENV_CLASS->{selected}{path} .= ' i:' . $index;

  return bless { root => $self->{root}, xdom => [$self->{xdom}[$index]], xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub inner {
  my $self          = shift;
  my $index         = shift;
  my $num;
  { no warnings; $num = 1 if $index =~ m/\d+/sx };
  # return $self->{xdom}[$index]{content} if $num;
  # return $self->index($index)->{xdom} if $num;
  return $self->{xdom}[0]{content}[$index] if $num;
  return $self->{xdom}[0]{content};
}

sub text {&inner}

sub reset {
  my $self          = shift;
  my $name          = shift || '';
  $ENV_CLASS->{selected}{$name} = '';
  return bless $self, ref $self;
}

1;
