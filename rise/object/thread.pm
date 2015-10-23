package rise::object::thread;
use strict;
use warnings;
use utf8;

use Data::Dump 'dump';

use parent qw/
	rise::object::object
	rise::object::variable
/;

our $VERSION 	= '0.01';

#my $ERROR		= {
#	code_priv				=> [ [ 1, 2 ], '"FUNCTION ERROR: Can\'t access function \"$func\" from \"$parent\" at $file line $line\n"' ],
#	code_prot				=> [ [ 1, 2 ], '"FUNCTION ERROR: Function \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
#};
#

sub obj_type {'THREAD'};

sub join {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->join if !$tid;
        $info = $_->join if $tid;
    }
    return $info;
}

sub detach {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->detach if !$tid;
        $info = $_->detach if $tid;
    }
    return $info;
}

sub tid {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->tid;
        $info = $_->tid if $tid;
    }
    return $info;
}

sub is_running {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->is_running;
        $info = $_->is_running if $tid;
    }
    return $info;
}

sub is_joinable {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->is_joinable;
        $info = $_->is_joinable if $tid;
    }
    return $info;
}

sub is_detached {
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;
    { no strict; no warnings; $thread = *$thread; }
    $thread        = [$thread->[$tid - 1]] if $tid;
    foreach (@$thread){
        $info->[$_->tid] = $_->is_detached;
        $info = $_->is_detached if $tid;
    }
    return $info;
}



sub DESTROY {}

1;
