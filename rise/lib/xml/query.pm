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

    $qcommands      =~ s/((?:\"\"|\"(?(?<!\\)[^\"]|.)*?[^\\]\"))/__xqexlude($1)/gsxe;
    $qcommands      =~ s/^\s*(.*?)\s*$/$1/sx;

    @$stack         = split /\s+/, $qcommands;

    grep {
        $_ =~ s/%%TXT(\d+)%%/__xqinclude($1)/sxe;

        $_ =~ s/^\/$/$xdom->root/sxe;
        $_ =~ s/^\:base$/$xdom->base/sxe;
        $_ =~ s/^\#(\w+)$/$xdom->id($1)/sxe;
        $_ =~ s/^(\w+)$/$xdom->node($1)/sxe;
        $_ =~ s/^\@(\w+)$/$xdom->attr($1)/sxe;
        $_ =~ s/^\@\"(.*?)\"$/$xdom->attrVal($1)/sxe;
        $_ =~ s/^\+(\w+)$/$xdom->addNode($1)/sxe;
        $_ =~ s/^\+\=\"(.*?)\"$/$xdom->addNodeVal($1)/sxe;
        $_ =~ s/^\+\@(\w+)$/$xdom->addAttr($1)/sxe;
        $_ =~ s/^\+\@\"(.*?)\"$/$xdom->addAttrVal($1)/sxe;
    } @$stack;

    return $stack;
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
