##################################### QUERY ######################################
package rise::lib::xml::query;
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

    $qcommands      =~ s/((?:\"\"|\"(?(?<!\\)[^\"]|.)*?[^\\]\"))/__xqexlude($1)/gsxe;
    $qcommands      =~ s/^\s*(.*?)\s*$/$1/sx;

    @$stack         = split /\s+/, $qcommands;

    grep {
        $_ =~ s/%%TXT(\d+)%%/__xqinclude($1)/sxe;

        $xdom = $xdom->root                 if $_ =~ m/^(?:\/|\:root|\:r)$/sx;
        $xdom = $xdom->base                 if $_ =~ m/^\:(?:base|b)$/sx;
        $xdom = $xdom->id($1)             if $_ =~ m/^\#(\w+)$/sx;
        $xdom = $xdom->class($1)          if $_ =~ m/^\.(\w+)$/sx;
        $xdom = $xdom->node($1)           if $_ =~ m/^(\w+)$/sx;
        $xdom = $xdom->nodeValue($1)      if $_ =~ m/^(?:\"(.*?)\")?$/sx;
        $xdom = $xdom->attr($1)           if $_ =~ m/^\@(\w+)$/sx;
        $xdom = $xdom->attrValue($1)      if $_ =~ m/^\@\"(.*?)\"$/sx;

        $xdom = $xdom->addNode($1)          if $_ =~ m/^\+(\w+)$/sx;
        $xdom = $xdom->addNodeValue($1)     if $_ =~ m/^\+\"(.*?)\"$/sx;
        $xdom = $xdom->addAttr($1)          if $_ =~ m/^\+\@(\w+)$/sx;
        $xdom = $xdom->addAttrValue($1)     if $_ =~ m/^\+\@\"(.*?)\"$/sx;

        $xdom = $xdom->nName($1)             if $_ =~ m/^\:name(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->nParent($1)             if $_ =~ m/^\:parent(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->nOrder($1)             if $_ =~ m/^\:order(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->nPath($1)             if $_ =~ m/^\:path(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->nAttr($1)             if $_ =~ m/^\:attr(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->nContent($1)      if $_ =~ m/^\=(?:\[(.*?)\])?$/sx;

        $xdom = $xdom->inner($1)            if $_ =~ m/^\:(?:inner|content)(?:\[(.*?)\])?$/sx;
        $xdom = $xdom->direct               if $_ =~ m/^(?:\:direct|\:d|\>)$/sx;
        $xdom = $xdom->flat                 if $_ =~ m/^(?:\:flat|\:f|\<)$/sx;
        $xdom = $xdom->index($1)            if $_ =~ m/^\[(.*?)\]$/sx;
        $xdom = $xdom->xml                  if $_ =~ m/^(?:\:xml|\<\>)$/sx;

    } @$stack;

    return $xdom;
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
