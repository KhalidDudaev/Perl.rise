######################################## lib::odom #######################################
package rise::lib::odom;
use strict;
use warnings;
use utf8;
use feature 'say';
use rise::lib::odom::hdom;
use Data::Dump 'dump';

our $VERSION = '0.000';

my $ENV_CLASS          = {
  xml       => '',
  hash      => {},
  xdom      => {}
};

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
  $self->{xdom}     = $hdom->parse($key,$hash);

  # say "########################## ". dump($self->{xdom}) ." ########################";

  return bless { xdom => $self->{xdom} }, ref $self;
}

sub xdom {
  my $self          = shift;
  return $self->{xdom};
}

sub id {
  my $self          = shift;
  my $id            = shift;
  my $res           = $self->attr('id')->attrValue($id);
  return  $res;
}

sub node {
  my $self          = shift;
  my $node          = shift;
  $ENV_CLASS->{selected}{node} = $node;
  $ENV_CLASS->{selected}{attr} = '';
  # foreach my $n (@$node) {
  #     push @{$self->{xdom}{node}{$n}}, $n;
  # }

  $self             = $self->new->parse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
  return  bless { xdom => $self->{xdom}{node}{$node} }, ref $self;
}

sub attr {
  # my $self        = shift;
  # my $attr        = shift;
  # my $attr_name   = [keys(%$attr)]->[0];
  # my $attr_value  = $attr->{$attr_name};
  # my $res_arr     = [];
  #
  # $self = $self->new->parse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
  #
  # foreach my $n (@{$self->{xdom}{attr}{$attr_name}}) {
  #     push @{$res_arr}, $n if $n->{attr}{$attr_name} eq $attr_value;
  # }
  #
  # # say "########################## ". dump($res_arr) ." ########################";
  #
  # return bless { xdom => $res_arr }, ref $self;

  my $self          = shift;
  my $attr          = shift;
  $ENV_CLASS->{selected}{attr} = $attr;
  $self = $self->new->parse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
  return bless { xdom => $self->{xdom}{attr}{$attr} }, ref $self;
}

sub attrValue {
  my $self          = shift;
  my $attrVal       = shift;
  my $node_arr      = [];

  $self = $self->new->parse('',$self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

  $node_arr = $self->{xdom}{attrValue}{$attrVal};

  if ($ENV_CLASS->{selected}{attr}) {
    $node_arr = [];
    foreach my $n (@{$self->{xdom}{attr}{$ENV_CLASS->{selected}{attr}}}) {
        push @{$node_arr}, $n if $n->{attr}{$ENV_CLASS->{selected}{attr}} eq $attrVal;
    }
  }

  # say "########################## ". $ENV_CLASS->{selected}{attr} ." ########################";

  # return bless { xdom => $self->{xdom}{attrValue}{$attrVal} }, ref $self;
  return bless { xdom => $node_arr }, ref $self;
}

sub index {
  my $self          = shift;
  my $index         = shift;
  return bless { xdom => $self->{xdom}[$index]{content} }, ref $self;
}

sub inner {
  my $self          = shift;
  my $index         = shift;
  my $num;
  { no warnings; $num = 1 if $index =~ m/\d+/sx };
  # return $self->{xdom}[$index]{content} if $num;
  return $self->index($index)->{xdom} if $num;
  return $self->{xdom};
}

sub text {&inner}

sub reset {
  my $self          = shift;
  my $name          = shift;
  $ENV_CLASS->{selected}{$name} = '';
  return bless $self, ref $self;
}
