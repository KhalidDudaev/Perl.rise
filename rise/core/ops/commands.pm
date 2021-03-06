package rise::core::ops::commands;

use strict;
use warnings;
# use feature 'say';
use utf8;

use parent qw/
	rise::core::object::error
/;

use Data::Dump 'dump';

#use autobox::Core;

our $VERSION = '0.000';
use constant FIVETEN => ($] >= 5.010);

my $cenv					= {};
my @export_list 			= qw/
	dump
	clone
	say
	_
	a
	b
	true
	false
	toList
	size
	portal

	__RISE_OREF

	__RISE_A2R
	__RISE_H2R
	__RISE_R2A
	__RISE_R2H
	__RISE_2R
	__RISE_R2

	__RISE_SPLIT

	__RISE_MAP_BLOCK
	__RISE_GREP_BLOCK
	__RISE_SORT_BLOCK

	__RISE_MAP
	__RISE_GREP
	__RISE_JOIN
	__RISE_REVERSE
	__RISE_POP
	__RISE_PUSH
	__RISE_SHIFT
	__RISE_UNSHIFT
	__RISE_SPLICE

	__RISE_KEYS
	__RISE_VALUES
	__RISE_EACH

	__RISE_MATCH
/;
	#m
	#nm

#	keys
#	values
#	each
#
#	grep
#	map
#	join
#	reverse
#	sort
#	pop
#	push
#	shift
#	unshift
#	size
#	slice
#/;

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

sub init { no strict 'refs';
	my $self	= shift || caller(0);
	#autobox::Core->import;
	*{$self . "::$_"} = \&$_ for @export_list;
	# *{"UNIVERSAL::CORE::size"} = \&size;
}

# sub __class__ { &__RISE_OREF }
sub _ (){ $_; };
sub a (){ $a; };
sub b (){ $b; };
sub true { 1 };
sub false { 0 };
# sub true { !!1; };
# sub false { !!0; };
sub toList ($){@{$_[0]}}


# sub line (;$){
# 	my $args		= shift;
# 	my $char		= $args->{char} || '#';
# 	my $title		= $args->{title} || '';
# 	my $length		= $args->{length} || 75;
#
# 	$title			= $char x 3 . '[ ' . $title . ' ]' if $title;
# 	return $title . $char x ($length - length($title));
# }

sub say {
	# __PACKAGE__->__RISE_ERR('PRINT') if (!$_[0] && $_[0] ne '');
    # my $t = 0;
    # $t = 1 if $_[0] eq '';
	__PACKAGE__->__RISE_WARN('PRINT') unless $_[0];
	local $\ = "";
	print @_ , "\n";
}

# sub say { say @_ }

# sub msg (;$$){
# 	my $text		= shift || 'NO TEXT';
# 	my $title		= shift || 'NO TITLE';
#
# 	# $title			= '### ' . $title . ' ';
# 	# $title			= $title . line('#', 80 - length($title));
#
# 	say line { title => $title };
# 	say $text;
# 	say line;
# }

sub clone {
	my $var = shift;
	my $vt = ref $var;
	my $data;

	$$data = $$var if $vt eq 'SCALAR';
	@$data = @$var if $vt eq 'ARRAY';
	%$data = %$var if $vt eq 'HASH';
	&$data = &$var if $vt eq 'CODE';
	*$data = *$var if $vt eq 'GLOB';

	return $data;
}

sub portal {
    no strict 'refs';
    my $a = shift || 'a';
    my $b = shift || 'b';
    return &{$b}($a);
}
sub UNIVERSAL::portal {
    goto &portal;
}

sub __RISE_OREF {
	my $caller						= (caller(1))[3];
	$caller							=~ s{::\w+::\w+$}{}sx;
	my $self						= shift if ($_[0] && $_[0] =~ m{^$caller}sx);
	$self							||= $caller;
	return $self, @_;
}
	#token op_array1					=> q/\b(?:pop|push|shift|slice|unshift|sort)\b/;
	#token op_array2					=> q/\b(?:grep|map|join|sort)\b/;

	#token op_hash					=> q/\b(?:keys|values|each)\b/;
	#token op_reverse				=> q/\b(?:reverse)\b/;

######### SCALAR ######################################################
#sub m          { [ $_[0] =~ m{$_[1]} ] }
#sub nm         { [ $_[0] !~ m{$_[1]} ] }
#sub split { no strict 'refs';
#	#my $list = shift;
#	my $sep = shift; my $var = shift;
#
#	print "### SPLIT $sep | $var\n";
#
#	wantarray ? split $sep, $var : [ split $sep, $var ];
#}
#
########## HASH ######################################################
##sub delete  {
##    my $hash = shift;
##
##    my @res = ();
##    foreach(@_) {
##        push @res, delete $hash->{$_};
##    }
##
##    return wantarray ? @res : \@res
##}
#
##sub exists {
##    my $hash = shift;
##    return exists $hash->{$_[0]};
##}

sub __RISE_KEYS ($){
	my $hash = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
	my $res = [ keys(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_VALUES ($){
	my $hash = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
	my $res = [ values(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_EACH ($){
	my $hash = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'each') unless ref $hash eq 'HASH';
	my $res = [ each(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

# sub __RISE_EACH {
#    my $hash = shift;
#    my $cb = shift;
# 	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
#    # Reset the each iterator. (This is efficient in void context)
#    keys %$hash;
#
#    while((my $k, my $v) = each(%$hash)) {
#        # local $_ = $v; # nc:0 may I break stuff?
#        $cb->($k, $v);
#    }
#
#    return;
# }

########## ARRAY ######################################################
# sub __RISE_GREP (&$){
# 	my $filter = shift;
# 	my $arr = shift;
# 	my @result;
# 	if( ref $filter eq 'Regexp' ) {
# 		@result = grep { m/$filter/ } @$arr;
# 	} elsif( ! ref $filter ) {
# 		@result = grep { $filter eq $_ } @$arr;  # find all of the exact matches
# 	} else {
# 		@result = grep { &$filter } @$arr;
# 	}
# 	return wantarray ? @result : \@result;
# }

# sub __RISE_GREP {
#    no warnings 'redefine';
#    if(FIVETEN) {
#         eval '
#             # protect perl 5.8 from the alien, futuristic syntax of 5.10
#             *__RISE_GREP = sub {
#
#                 my $filter = shift;
#                 my $arr = shift;
#                 my @result = grep { $_ ~~ $filter } @$arr;
#                 return wantarray ? @result : \@result;
#             }
#        ' or croak $@;
#    } else {
#        *__RISE_GREP = sub {
#             my $filter = shift;
#             my $arr = shift;
#             my @result;
#             if( ref $filter eq 'Regexp' ) {
#                 @result = grep { m/$filter/ } @$arr;
#             } elsif( ! ref $filter ) {
#                 @result = grep { $filter eq $_ } @$arr;  # find all of the exact matches
#             } else {
#                 @result = grep { $filter->($_) } @$arr;
#             }
#             return wantarray ? @result : \@result;
#        };
#    }
#    __RISE_GREP(@_);
# }

## last version: sub map (\@&) { my $arr = shift; my $sub = shift; [ map { $sub->($_) } @$arr ]; }
#

sub __RISE_GREP_BLOCK (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
    # my $res = [grep { &$code } @$array];
	return [grep { &$code } @$array];
	# return wantarray ? @$res : $res;
}

sub __RISE_MAP_BLOCK (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'map') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
	# my $res = [ map { &$code } @$array ];
	return [ map { &$code } @$array ];
	# return wantarray ? @$res : $res;
}

sub __RISE_GREP ($$){
	my( $filter, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $array eq 'ARRAY';
    # my $res = [grep $filter, @$array];
	return [grep { m/$filter/ } @$array];
	# return wantarray ? @$res : $res;
}

sub __RISE_MAP ($$){
	my( $filter, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'map') unless ref $array eq 'ARRAY';
	# my $res = [ map $filter, @$array ];
	return [ map { m/$filter/ } @$array ];
	# wantarray ? return @$res : return $res;
}

sub __RISE_JOIN ($$){
	my $filter	= shift;
	my $array	= shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'join') unless ref $array eq 'ARRAY';
	join $filter, @$array;
}

sub __RISE_REVERSE ($){
	my $data	= shift;
	my $res;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'reverse') unless ref $data eq 'ARRAY' || ref $data eq 'HASH';
	@$res = reverse @$data if ref $data eq 'ARRAY';
	%$res = reverse %$data if ref $data eq 'HASH';
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_SORT_BLOCK (&$){
	my $sub		= shift;
	my $array	= shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'sort') unless ref $array eq 'ARRAY' || ref $array eq 'HASH';
	my $res = [ sort { &$sub || $a cmp $b } @$array ];
	return $res;
}

sub __RISE_POP ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'pop') unless ref $array eq 'ARRAY';
	return pop @$array;
}

sub __RISE_PUSH ($$){
	my $array	= shift;
	my $list 	= shift;
	$list		= [$list] if ref $list ne 'ARRAY';
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'push') unless ref $array eq 'ARRAY';
	return push @$array, @$list;
}

sub __RISE_SHIFT ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'shift') unless ref $array eq 'ARRAY';
	return shift @$array;
}

sub __RISE_UNSHIFT ($$){
	my $array	= shift;
	my $list 	= shift;
	$list		= [$list] if ref $list ne 'ARRAY';
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'unshift') unless ref $array eq 'ARRAY';
	return unshift(@$array, @$list);
}

sub size ($){
	my $array = shift;
	return scalar @$array if ref $array eq 'ARRAY';
	return scalar %$array if ref $array eq 'HASH';
	return length $array if ref \$array eq 'SCALAR';
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'size');
}

sub __RISE_SPLICE {
	my $array	= shift;
	my $offset	= shift;
	my $lenght	= shift;
	my $list	= shift;

	return [splice @$array,$offset,$lenght, @$list] if $list;
	return [splice @$array,$offset,$lenght] if $lenght;
	return [splice @$array,$offset] if $offset;
	return [splice @$array];
}

sub __RISE_SPLIT ($$){
	my $filter	= shift;
	my $data	= shift;
	__PACKAGE__->__RISE_ERR('SCALAR', 'split') unless ref \$data eq 'SCALAR';
	# return split $filter, $data;
	return [ split m/$filter/, $data ];
}

########## REGEX ######################################################
sub __RISE_MATCH (@) {
    # my @m   = @_;
    return !!0 if !$_[0];
	return @_ if wantarray;
    return [@_];
}
##########################################################################################
sub __RISE_FOR (@) {

}

##########################################################################################


sub __RISE_A2R (@){ wantarray ? @_ : \@_ }
# sub __RISE_A2R (@){
# 	return !!0 if !$_[0];;
# 	if (@_){
# 		return @_ if wantarray;
# 		return [@_];
# 	}
# }
# sub __RISE_A2R (@){ \@_ }

{ no strict 'refs';
	sub __RISE_H2R (%){+{@_}}
	# sub __RISE_R2A ($){ wantarray ? @{$_[0]} : $_[0] }
	sub __RISE_R2A ($){@{$_[0]}}
	# sub __RISE_R2A ($){
	# 	my $arr = \+shift;
	# 	return @$$arr;
	# }
	sub __RISE_R2H ($){%{$_[0]}}
}

#if ($@) {
#	my ($child, $file, $line, $func) = (caller(1));
#
#	print "----------------
#	child	: $child
#	file	: $file
#	line	: $line
#	func	: $func
#----------------\n";
#}

sub __RISE_2R { no strict;
	return +[@_] if ${__PACKAGE__."::__VARTYPE__"} eq 'ARRAY';
	return +{@_} if ${__PACKAGE__."::__VARTYPE__"} eq 'HASH';
}

sub __RISE_R2 { no strict;
	my $var = shift;
	${__PACKAGE__."::__VARTYPE__"} = ref $var;

	return $$var if ${__PACKAGE__."::__VARTYPE__"} eq 'SCALAR';
	return @$var if ${__PACKAGE__."::__VARTYPE__"} eq 'ARRAY';
	return %$var if ${__PACKAGE__."::__VARTYPE__"} eq 'HASH';
	return &$var if ${__PACKAGE__."::__VARTYPE__"} eq 'CODE';
	return *$var if ${__PACKAGE__."::__VARTYPE__"} eq 'GLOB';
}

sub test {
	my $self = shift;
	'its working';
}

1;
