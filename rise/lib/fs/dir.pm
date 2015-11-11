package rise::lib::fs::dir;

use strict;
use warnings;
use utf8;
use feature 'say';

my $cenv   					= {};

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

sub filter {
    my $item                    = shift;
    my $filter                  = shift;

    $filter                     =~ s/([^\w\*\?])/\\$1/gsx;
    $filter                     =~ s/\?/\\w/gsx;
    $filter                     =~ s/\*/\.\*\?/gsx;
    $item                       =~ s/^(.*?)(\w+(?:\.\w+)*)$/$2/sx;

    return $item =~ m/^(?:$filter)$/gsx;
}

sub list {
    my $self		            = shift;
    my $pathdir                 = shift;
    my $dlist                   = [];

    opendir(DIR, $pathdir) || die;
    foreach my $item (readdir DIR) {
        push @$dlist, $pathdir.'/'.$item if $item !~ m/^(?:\.|\.\.)$/;
    }
    closedir DIR;
    return $dlist;
}

sub list_file {
    my $self					= shift;
    my $data                    = shift;
    my $pathdir                 = $data->{path};
    my $deep                    = $data->{deep} || 0;
    my $filter                  = $data->{filter} || '*.*';
    my $dpath                   = [$pathdir];
    my $dlist;
    # push @$dpath, @{list_dir({ path => $pathdir, deep => 1 })} if $data->{deep};
    foreach my $dname (@$dpath) {
        foreach my $item (@{$self->list($dname)}) {
            # if (!$dotF && $item =~ m/[\\\/]\./){}
            push @$dpath, $item if $self->is_dir($item) && $deep;
            push @$dlist, $item if $self->is_file($item) && filter($item, $filter);
        }
    }
    return $dlist;
}

sub list_dir {
    my $self					= shift;
    my $data                    = shift;
    my $pathdir                 = $data->{path};
    my $deep                    = $data->{deep} || 0;
    my $filter                  = $data->{filter} || '*';
    my $dotF                    = $data->{dotFiles} || 1;
    my $dpath                   = [$pathdir];
    my $dlist;
    foreach my $dname (@$dpath) {
        foreach my $item (@{$self->list($dname)}) {
            # if (!$dotF && $item =~ m/[\\\/]\./){ last; };
            if ($self->is_dir($item)){
                push @$dpath, $item if $deep;
                push @$dlist, $item if filter($item, $filter);
            }
        }
    }
    return $dlist;
}

# sub is_file { [stat($_[0])]->[2] =~ m/3[23]\d{3}/ ? return !!1 : return !!0; }
# sub is_dir {
#     my $file    = shift;
#     my $mode    = [stat($file)]->[2];
#     my $ret     = !!0;
#     $ret = !!1 if defined $mode && $mode =~ m/16\d{3}/;
#     return $ret;
# }

# sub is_file { my $self = shift; -f shift }
sub is_file { my $self = shift; -e shift && !-d _ }
sub is_dir  { my $self = shift; -d shift }

1;
