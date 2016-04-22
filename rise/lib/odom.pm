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

# my $ROOT;

# my $xdom    = {};
my $hdom            = new rise::lib::odom::hdom;

sub new {
  my $class         = ref $_[0] || $_[0];                                       # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  my $object        = $_[1] || {};                                              # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
  %$object          = (%$ENV_CLASS, %$object);                                  # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
  return bless($object, $class);                                                # обьявляем класс и его свойства
}

sub dom {
  my $self          = shift;
  my $hash          = shift;

  $ENV_CLASS->{base} = $hash;

  # $ROOT             = $hdom->parse($hash, 1);
  $self             = $self->reparse($hash);

  return $self;
}

sub reparse {
  my $self          = shift;
  my $hash          = shift;

  $self->{xdom}     = $hdom->parse($hash);

  return bless { xdom => $self->{xdom}, root => $ENV_CLASS->{root} }, ref $self;
}

sub xdom {
  my $self          = shift;
  return $self->{xdom};
}

sub root {
    my $self          = shift;
    $ENV_CLASS->{selected}{node} = '';
    $ENV_CLASS->{selected}{attr} = '';
    $ENV_CLASS->{selected}{path} .= ' :root';
    $self->{xdom}   = $ENV_CLASS->{base};

    # $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    return $self
    # return bless { xdom => $self->{xdom}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
    # return $ENV_CLASS->{base};
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

sub node {
    my $self        = shift;
    my $node        = shift;

    __error('ERROR NODE: The node name is not specified','?') if !$node;

    $ENV_CLASS->{selected}{node} = $node;
    $ENV_CLASS->{selected}{attr} = '';
    $ENV_CLASS->{selected}{path} .= ' ' . $node;

    $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');

    @{$self->{xdom}{node}{$node}} = grep $_->{parent} eq $ENV_CLASS->{direct}, @{$self->{xdom}{node}{$node}} if $ENV_CLASS->{direct} ne '';
    $ENV_CLASS->{direct} = '';

    return bless { xdom => $self->{xdom}{node}{$node}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub nodeValue {
  my $self          = shift;
  my $val           = shift || '.*?';
  my $arr           = [];

  $ENV_CLASS->{selected}{path} .= ' ?';
  $ENV_CLASS->{selected}{path} .= '"'.$val.'"' if $val;

  # say "### $ENV_CLASS->{selected}{path} ###";

  grep {
    my $node = $_;
    grep {
        push @$arr, $node if $_ =~ m/$val/sx;
        # push @$arr, $_ if !$val;
    } @{$_->{content}};
  } @{$self->{xdom}};

  return bless { xdom => $arr, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}


sub nodeInner {
  my $self          = shift;
  my $item          = shift;
  my $arr           = [];

  my $num           = 0;

  { no warnings; $num = 1 if $item =~ m/\d+/sx };

  __error('ERROR ITEM: Only number item',"'$item'") if $item && !$num;

  # $item             = '0' if $item == 0;

  $ENV_CLASS->{selected}{path} .= ' =';
  $ENV_CLASS->{selected}{path} .= '['.$item.']' if $num;

  # say "### $ENV_CLASS->{selected}{path} ###";

  grep {
    grep {
        push @$arr, $_;
    } @{$_->{content}};
  } @{$self->{xdom}};

  return $arr->[$item] if $num;
  return $arr;
}

sub flat {
    my $self        = shift;
    my $nodes       = [];

    $ENV_CLASS->{selected}{path} .= ' :flat';
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

  return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
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

  return bless {  xdom => $node_arr, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub direct {
    my $self          = shift;

    $ENV_CLASS->{selected}{path} .= ' :direct';
    $ENV_CLASS->{direct} = $ENV_CLASS->{selected}{node};
    return $self;
}

sub addNode {
    my $self        = shift;
    my $node        = shift;
    my $parent      = $ENV_CLASS->{selected}{node};

    __error('ERROR NODE: No selected node',"'$node'") if !$parent;

    $ENV_CLASS->{selected}{path} .= ' +' . $node;

    my $node_add    = {
      'attr' => {},
      'order' => 0,
      'content' => [],
      'name' => $node,
      'parent' => $parent
    };

    grep {
        # $node_add->{order} = "QWEQWE";
        push @{$_->{content}}, clone($node_add);
    } @{$self->{xdom}};

    $self->new->dom($ENV_CLASS->{base});

    return $self->node($node);
}

sub addNodeValue {
    my $self        = shift;
    my $value       = shift;
    my $node        = $ENV_CLASS->{selected}{node};

    __error('ERROR VAL: No selected node',"'$value'") if !$node;

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

    __error('ERROR ATTR: No selected node',"'$attr'") if !$node;

    $ENV_CLASS->{selected}{attr} = $attr;
    $ENV_CLASS->{selected}{path} .= ' +@' . $attr;

    my $arr = $self->{xdom};

    grep {
        $_->{attr}{$attr} = '';
    } @$arr;

    $self           = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    $self->new->dom($ENV_CLASS->{base});

    return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub addAttrValue {
    my $self        = shift;
    my $val         = shift;

    my $node        = $ENV_CLASS->{selected}{node};
    my $attr        = $ENV_CLASS->{selected}{attr};

    __error('ERROR ATTRVAL: No selected attribute', "'$val'") if !$attr;

    $ENV_CLASS->{selected}{path} .= ' +="' . $val . '"';

    my $arr = $self->{xdom};

    grep {
        $_->{attr}{$attr} .= ' ' if $_->{attr}{$attr};
        $_->{attr}{$attr} .= $val;
    } @$arr;

    $self             = $self->new->reparse($self->{xdom}) if (ref $self->{xdom} eq 'ARRAY');
    $self->new->dom($ENV_CLASS->{base});

    return bless { xdom => $self->{xdom}{attr}{$attr}, xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}

sub index {
  my $self          = shift;
  my $index         = shift;

  $ENV_CLASS->{selected}{path} .= " [$index]";

  return bless {  xdom => [$self->{xdom}[$index]], xpath => $ENV_CLASS->{selected}{path} }, ref $self;
}


# sub item {
#     my $self        = shift;
# }

sub inner {
  my $self          = shift;
  my $index         = shift;
  my $num;
  my $arr           = [];
  { no warnings; $num = 1 if $index =~ m/\d+/sx };

  grep {
      push @$arr, $_->{content};
  } @{$self->{xdom}};

  return $arr->[$index] if $num;
  return $arr;
}

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
    my $err;
    my ($package, $file, $line, $func);
    my $level           = 1;

    $package            = 1;

    while ($package) {
        ($package, $file, $line, $func)      = (caller($level));
        if ($package) {
            $func               =~ s/.*?(\w+)$/$1/sx;
            $err .= "$err_msg
    -> package:    $package
       line:       $line
       method:     $func(@arr)\n";
        }
        $level++;
        $err_msg = '';
    }

    die $err;
}

1;
