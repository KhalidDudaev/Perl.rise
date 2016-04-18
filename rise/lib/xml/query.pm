##################################### QUERY ######################################
package rise::lib::xml::query;
use strict;
use warnings;
use utf8;
use feature 'say';
use rise::lib::xml::hash;
use rise::lib::odom;

use Data::Dump 'dump';

our $VERSION = '0.000';

my $ENV_CLASS          = {
  xml       => '',
  hash      => {}
};

my $txt_stack       = [];

sub new {
  my $class         = ref $_[0] || $_[0];                                       # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                              # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                  # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                                # обьявляем класс и его свойства
}

sub xq {
    my $self        = shift;
    my $xdom        = shift;
    my $qcommands   = shift;
    my $stack       = [];
    my $res;

    $qcommands      =~ s/((?:\"\"|\"(?(?<!\\)[^\"]|.)*?[^\\]\"))/__xqexlude($1)/gsxe;
    $qcommands      =~ s/^\s*(.*?)\s*$/$1/sx;

    @$stack         = split /\s+/, $qcommands;

    grep {
        $_ =~ s/%%TXT(\d+)%%/__xqinclude($1)/sxe;

        $res = $xdom->root              if $_ =~ m/^\/$/sx;
        $res = $xdom->base              if $_ =~ m/^\:base$/sx;
        $res = $xdom->id($1)            if $_ =~ m/^\#(\w+)$/sx;
        $res = $xdom->node($1)          if $_ =~ m/^(\w+)$/sx;
        $res = $xdom->attr($1)          if $_ =~ m/^\@(\w+)$/sx;
        $res = $xdom->attrValue($1)     if $_ =~ m/^\@\"(.*?)\"$/sx;
        $res = $xdom->addNode($1)       if $_ =~ m/^\+(\w+)$/sx;
        $res = $xdom->addNodeValue($1)  if $_ =~ m/^\+\=\"(.*?)\"$/sx;
        $res = $xdom->addAttr($1)       if $_ =~ m/^\+\@(\w+)$/sx;
        $res = $xdom->addAttrValue($1)  if $_ =~ m/^\+\@\"(.*?)\"$/sx;
        $res = $xdom->index($1)         if $_ =~ m/^\[(.*?)\]$/sx;
    } @$stack;

    return $res;
}

sub __xqexlude {
    my $txt         = shift;
    push @$txt_stack, $txt;
    return "%%TXT$#$txt_stack%%";
}

sub __xqinclude {
    my $index       = shift;
    return $txt_stack->[$index];
}
