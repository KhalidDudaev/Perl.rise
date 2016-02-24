package rise::core::object::thread::ext;
use strict;
use warnings;
use utf8;

our $VERSION 	= '0.01';

#my $ERROR		= {
#	code_priv				=> [ [ 1, 2 ], '"FUNCTION ERROR: Can\'t access function \"$func\" from \"$parent\" at $file line $line\n"' ],
#	code_prot				=> [ [ 1, 2 ], '"FUNCTION ERROR: Function \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
#};
#

sub obj_type {'THREAD'};

sub join {
	# print "\nTHREAD JOIN\n";
    my $self    = shift;
    my $tid     = shift;
    my $caller  = caller(0);
    # my $thread  = $self;
    my $thread  = $caller . '::THREAD::' . $self;
    # my $thread_res  = $caller . '::THREADRESULT::' . $self;
    my $info    = [];

    # $thread     =~ s/^(.*?)(::\w+)$/$1::THREAD$2/sx;

	{ no strict; no warnings;
		$thread = *$thread;
		# $thread_res = *$thread_res;
	}

	return $thread->[$tid]->join if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->join;
		# $$thread_res->[$_->tid] = $info->[$_->tid];
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
    # $thread        = [$thread->[$tid - 1]] if $tid;
	return $thread->[$tid]->detach if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->detach;
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
	return $thread->[$tid]->tid if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->tid;
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
	return $thread->[$tid]->is_running if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->is_running;
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
	return $thread->[$tid]->is_joinable if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->is_joinable;
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
	return $thread->[$tid]->is_detached if $tid;
    foreach (@{$thread}[1..$#$thread]){
        $info->[$_->tid] = $_->is_detached;
    }
    return $info;
}



sub DESTROY {}

1;
