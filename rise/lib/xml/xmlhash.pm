##################################### XML::HASH ################################
package rise::lib::xml::xmlhash;

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

sub parse {
  my $self          = shift;
  my $xml           = shift;
  my $xml_tag       = '\\w+(?::\\w+)*';
  my $hash          = {};

  $xml =~ s/<\!--.*?-->//gsx;
  $xml =~ s/\<\?xml\s+version\s*\=\s*\"(?:\d+(?:\.\d+)?)\"\s+encoding\s*\=\s*\"utf\-8\"\?\>//gsx;
  $xml =~ s/\<\!\[CDATA\[(.*?)\]\]\>/"<![CDATA[$1]]>"/gsx;
  $xml =~ s/<(?<TAGNAME>\w+(?::\w+)*)(?<TAGPROPH>(?(?<!\\)[^\<\>])*)?(?<!\\)\/>/
    # $tproph = tag_proph($+{TAGPROPH});
    '{ "name" => "'.$+{TAGNAME}.'", "attr" => {'. __node_proph($+{TAGPROPH}) .' }, "content" => undef },'
  /gsxe;
  $xml =~ s/<(?<TAGNAME>\w+(?::\w+)*)(?<TAGPROPH>(?(?<!\\)[^\<\>])*)?(?<!\\)>/
    # \{ $+{TAGNAME} => \{ proph => \['$+{TAGPROPH}'\], content => \[
    '{ "name" => "'.$+{TAGNAME}.'", "attr" => {'. __node_proph($+{TAGPROPH}) .' }, "content" => ['
  /gsxe;
  $xml =~ s/<\/(?:\w+(?::\w+)*)>/\]\}\,/gsx;
  # $xml =~ s/\[(?!\s*\{)/\["/gsx;
  # $xml =~ s/(?!\}.*?)\]/"\]/gsx;
  $xml =~ s/\"content\"\s*\=\>\s*\[(\w.*?)\]/
    "\"content\" \=\> \[\"".__escape($1)."\"\]"
  /gsxe;
  $xml =~ s/\"attr\"\s*\=\>\s*\{\s*\}/"attr" => undef/gsx;

  { #no strict;
    $hash = eval $xml;
  }
  # say "########################## ". dump($hash) ." ########################";
  # $hash =  __hparse3('', [$hash]);
  # $self->{xdom} = $xdom;
  return [$hash];
}

sub __node_proph {
	my $p = shift;
	$p =~ s/(?<pname>\w+(?::\w+)*)(?:\s*=\s*\"(?<pvalue>.*?)\")/\"$+{pname}\" => \"$+{pvalue}\"\,/gsx;
	return $p;
}

sub __escape {
  my $char      = shift;
  # $char =~ s/([^\w\s])/\\$1/gsx;
  $char =~ s/(\/)/\\$1/gsx;
  return $char;
}

1;
