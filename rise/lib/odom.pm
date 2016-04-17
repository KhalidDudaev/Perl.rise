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
  # my $key           = shift || '';
  my $hash          = shift;
  # my $xdom          = {};
  # my $hdom          = new lib::odom::hdom;
  # $hdom->clear;
  $ENV_CLASS->{base} = $hash;

  $ROOT             = $hdom->parse($hash);

  $self             = $self->reparse($hash);

  # say "########################## ". dump($self->{xdom}) ." ########################";

  # return bless { xdom => $self->{xdom}, root => $ENV_CLASS->{root} }, ref $self;
  return $self;
}

sub reparse {
  my $self          = shift;
  # my $key           = shift || '';
  my $hash          = shift;
  # my $xdom          = {};
  # my $hdom          = new lib::odom::hdom;
  # $hdom->clear;
  # $ENV_CLASS->{root} = $hdom->reparse($key,$hash) if !$ENV_CLASS->{root};

  $self->{xdom}     = $hdom->parse($hash);

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
    $ENV_CLASS->{selected}{node} = '';
    $ENV_CLASS->{selected}{attr} = '';
    $ENV_CLASS->{selected}{path} .= ' /';
    $self->{xdom}   = $ROOT;
    return $self;
}

sub parent {
    my $self          = shift;
    return $self;
}

sub base {
    return $ENV_CLASS->{base};
}

sub id {
  my $self          = shift;
  my $id            = shift;
  my $res           = $self->attr('id')->attrValue($id);
  $ENV_CLASS->{selected}{path} =~ s/\@id/\#/sx;
  $ENV_CLASS->{selected}{path} =~ s/\#\s*\=\"(\w+)\"/\#$1/sx;
  return  $res;
}

sub class {
  my $self          = shift;
  my $class         = shift;
  my $res           = $self->attr('class')->attrValue($class);
  $ENV_CLASS->{selected}{path} =~ s/\@class/\./sx;
  $ENV_CLASS->{selected}{path} =~ s/\.\s*\=\"(\w+)\"/\.$1/sx;

  return  $res;
}

# sub class {
#   my $self          = shift;
#   my $class          = shift;
#
#   $ENV_CLASS->{selected}{attr} = 'class';
#   $ENV_CLASS->{selected}{path} .= ' .';
#
#   $self             = $self->attrValue($class);
#   $self             = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
#
#
#   return bless { xdom => $self->{xdom}{attr}{'class'}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
#
#   # $self->{xpath}      = $ENV_CLASS->{selected}{path};
#   # return $self;
# }

sub node {
    my $self        = shift;
    my $node        = shift;

    __error('ERROR NODE: The node name is not specified
    -> package:    $package
       line:       $line
       method:     $func(?)
    \n') if !$node;

    $ENV_CLASS->{selected}{node} = $node;
    $ENV_CLASS->{selected}{attr} = '';
    $ENV_CLASS->{selected}{path} .= ' ' . $node;

    $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

    @{$self->{xdom}{node}{$node}} = grep $_->{parent} eq $ENV_CLASS->{direct}, @{$self->{xdom}{node}{$node}} if $ENV_CLASS->{direct} ne '';
    $ENV_CLASS->{direct} = '';

    return bless { xdom => $self->{xdom}{node}{$node}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub flat {
    my $self        = shift;
    my $nodes       = [];

    $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

    grep {
        push @$nodes, @{$self->{xdom}{node}{$_}};
    } keys %{$self->{xdom}{node}};

    return bless { xdom => $nodes, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub attr {
  my $self          = shift;
  my $attr          = shift;

  $ENV_CLASS->{selected}{attr} = $attr;
  $ENV_CLASS->{selected}{path} .= ' @' . $attr;

  $self             = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

  # my $obj;
  # $obj = bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
  # $ENV_CLASS->{selected}{obj} = $obj;
  # return $obj;

  return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;

  # $self->{xpath}      = $ENV_CLASS->{selected}{path};
  # return $self;
}

sub attrValue {
  my $self          = shift;
  my $attrVal       = shift;
  my $node_arr      = [];

  $ENV_CLASS->{selected}{attrValue} = $attrVal;
  $ENV_CLASS->{selected}{path} .= ' ="' . $attrVal . '"';

  $self = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

  $node_arr = $self->{xdom}{attrValue}{$attrVal};

  if ($ENV_CLASS->{selected}{attr}) {
    $node_arr = [];
    foreach my $n (@{$self->{xdom}{attr}{$ENV_CLASS->{selected}{attr}}}) {
        push @{$node_arr}, $n if $n->{attr}{$ENV_CLASS->{selected}{attr}} eq $attrVal;
    }
  }

  $ENV_CLASS->{selected}{attr} = '';

  # say "########################## ". $ENV_CLASS->{selected}{attr} ." ########################";

  # my $obj;
  # $obj = bless {  xdom => $node_arr, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
  # $ENV_CLASS->{selected}{obj} = $obj;
  # return $obj;

  return bless {  xdom => $node_arr, xpath => $ENV_CLASS->{selected}{path} }, ref $self;

  # $self->{xpath}      = $ENV_CLASS->{selected}{path};
  # return $self;
}

sub direct {
    my $self          = shift;

    $ENV_CLASS->{selected}{path} .= ' >';
    $ENV_CLASS->{direct} = $ENV_CLASS->{selected}{node};
    return $self;
}

sub addNode {
    my $self        = shift;
    my $node        = shift;
    # my $obj         = $ENV_CLASS->{selected}{obj};
    my $parent      = $ENV_CLASS->{selected}{node};

    __error('ERROR NODE: No selected node
    -> package:    $package
       line:       $line
       method:     $func(\''.$node.'\')
    \n') if !$parent;

    $ENV_CLASS->{selected}{path} .= ' +' . $node;

    my $node_add    = {
      'attr' => {},
      'order' => 0,
      'content' => [],
      'name' => $node,
      'parent' => $parent
    };

    grep {
        $node_add->{order} = $#{$_->{content}};
        push @{$_->{content}}, clone($node_add);
    } @{$self->{xdom}};

    $self->new->parse($ENV_CLASS->{base});

    return $self->node($node);
}

# sub addNode {
#     my $self        = shift;
#     my $name        = shift;
#     my $node        = $ENV_CLASS->{selected}{node};
#     my $obj;
#
#     $ENV_CLASS->{selected}{path} .= ' +' . $name;
#
#
#     my $node_add    = {
#       'attr' => {},
#       'order' => 0,
#       'content' => ['ASDASDAS'],
#       'name' => $name,
#       'parent' => $node
#     };
#
#     $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
#
#     @{$self->{xdom}{node}{$node}} = grep {
#         $node_add->{order} = $#{$_->{content}};
#         push @{$_->{content}}, $node_add;
#     } @{$self->{xdom}{node}{$node}};
#
#     $self->new->parse($ENV_CLASS->{base});
#
#     # say "########################## ". dump($self) ." ########################";
#
#     # return bless { xdom => $self->{xdom}{node}{$name}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
#     $self = bless { xdom => $self->{xdom}{node}{$node}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
#     return $self->node($name);
# }

sub addNodeVal {
    my $self        = shift;
    my $value       = shift;
    # my $obj         = $ENV_CLASS->{selected}{obj};
    my $node        = $ENV_CLASS->{selected}{node};

    __error('ERROR VAL: No selected node
    -> package:    $package
       line:       $line
       method:     $func(\''.$value.'\')
    \n') if !$node;

    $ENV_CLASS->{selected}{path} .= ' +="' . $value . '"';

    grep {
        push @{$_->{content}}, $value;
    } @{$self->{xdom}};

    return $self;
}

sub addAttr {
    my $self        = shift;
    my $attr        = shift;
    my $node        = $ENV_CLASS->{selected}{node};
    # my $obj         = $ENV_CLASS->{selected}{obj};

    __error('ERROR ATTR: No selected node
    -> package:    $package
       line:       $line
       method:     $func(\''.$attr.'\')
    \n') if !$node;

    $ENV_CLASS->{selected}{attr} = $attr;
    $ENV_CLASS->{selected}{path} .= ' +@' . $attr;

    my $arr = $self->{xdom};

    grep {
        $_->{attr}{$attr} = '';
    } @$arr;

    $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    $self->new->parse($ENV_CLASS->{base});

    return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub addAttrVal {
    my $self        = shift;
    my $val         = shift;

    my $node        = $ENV_CLASS->{selected}{node};
    my $attr        = $ENV_CLASS->{selected}{attr};
    # my $obj         = $ENV_CLASS->{selected}{obj};

    __error('ERROR ATTRVAL: No selected attribute
    -> package:    $package
       line:       $line
       method:     $func(\''.$val.'\')
    \n') if !$attr;

    $ENV_CLASS->{selected}{path} .= ' +="' . $val . '"';

    my $arr = $self->{xdom};

    grep {
        $_->{attr}{$attr} .= ' ' if $_->{attr}{$attr};
        $_->{attr}{$attr} .= $val;
    } @$arr;

    $self             = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    $self->new->parse($ENV_CLASS->{base});

    return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub index {
  my $self          = shift;
  my $index         = shift;
  # my $obj;

  $ENV_CLASS->{selected}{path} .= ' i:' . $index;

  return bless {  xdom => [$self->{xdom}[$index]], xpath => $ENV_CLASS->{selected}{path} }, ref $self;

  # $self->{xpath}      = $ENV_CLASS->{selected}{path};
  # return $self;

}

sub nodeVal {
  my $self          = shift;
  my $val           = shift || '';
  # my $num;
  my $arr           = [];
  # { no warnings; $num = 1 if $index =~ m/\d+/sx };

  grep {
    #   push @$arr, $_->{content}[$index] if $num;
    #   push @$arr, $_->{content} if !$num;
    # $_->{content} ||= '';
    grep {
        push @$arr, $_ if $_ =~ m/$val/sx;
    } @{$_->{content}};

    # push @$arr, $_->{content} if $_->{content} =~ m/$val/sx;
  } @{$self->{xdom}};

  # return $arr->[$index] if $num;
  return $arr;
}

sub inner {
  my $self          = shift;
  my $index         = shift;
  my $num;
  my $arr           = [];
  { no warnings; $num = 1 if $index =~ m/\d+/sx };

  grep {
    #   push @$arr, $_->{content}[$index] if $num;
    #   push @$arr, $_->{content} if !$num;
      push @$arr, $_->{content};
  } @{$self->{xdom}};

  return $arr->[$index] if $num;
  return $arr;
}

# sub inner {
#   my $self          = shift;
#   my $index         = shift;
#   my $num;
#   { no warnings; $num = 1 if $index =~ m/\d+/sx };
#   # return $self->{xdom}[$index]{content} if $num;
#   # return $self->index($index)->{xdom} if $num;
#   return $self->{xdom}[0]{content}[$index] if $num;
#   return $self->{xdom}[0]{content};
# }

sub val {&inner}

sub reset {
  my $self          = shift;
  my $name          = shift || '';
  $ENV_CLASS->{selected}{$name} = '';
  $ENV_CLASS->{selected}{attr} = '';
  return bless $self, ref $self;
}

sub __error {
    my $err_msg         = shift;
    my @arr             = @_;

    my ($package, $file, $line, $func)      = (caller(1));

    $func               =~ s/.*?(\w+)$/$1/sx;
    $err_msg            = '"' . $err_msg . '"';

    # $err_msg     .= "
    # -> line $line: $func('@arr') - $package
    # \n";

    die eval $err_msg;
}

1;
