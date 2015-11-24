package rise::core::ops::commands;

use strict;
use warnings;
use utf8;
# use CORE;
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
	line
	say
	msg
	_
	a
	b
	true
	false
	toList

	__RISE_A2R
	__RISE_H2R
	__RISE_R2A
	__RISE_R2H
	__RISE_2R
	__RISE_R2

	keys
	values
	each

	__RISE_MAP_BLOCK
	__RISE_GREP_BLOCK
	__RISE_SORT_BLOCK

    __RISE_GREP

	map
	UNIVERSAL::grep
	join
	reverse
	pop
	push
	shift
	unshift
	size
	splice

	__RISE_MATCH
	__RISE_FOR
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
#	CORE::shift
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

sub __RISE_COMMANDS { no strict 'refs';
	my $self	= CORE::shift || caller(0);
	#autobox::Core->import;
	*{$self . "::$_"} = \&$_ for @export_list;
}

sub _ (){ $_; };
sub a (){ $a; };
sub b (){ $b; };
sub true { !!1; };
sub false { !!0; };
sub toList ($){@{$_[0]}}


sub line (;$){
	my $args		= CORE::shift;
	my $char		= $args->{char} || '#';
	my $title		= $args->{title} || '';
	my $length		= $args->{length} || 75;

	$title			= $char x 3 . '[ ' . $title . ' ]' if $title;
	return $title . $char x ($length - length($title));
}

sub say { local $\ = ""; print @_ , "\n"; };

sub msg (;$$){
	my $text		= CORE::shift || 'NO TEXT';
	my $title		= CORE::shift || 'NO TITLE';

	# $title			= '### ' . $title . ' ';
	# $title			= $title . line('#', 80 - length($title));

	say line { title => $title };
	say $text;
	say line;
}

sub clone {
	my $var = CORE::shift;
	my $vt = ref $var;
	my $data;

	$$data = $$var if $vt eq 'SCALAR';
	@$data = @$var if $vt eq 'ARRAY';
	%$data = %$var if $vt eq 'HASH';
	&$data = &$var if $vt eq 'CODE';
	*$data = *$var if $vt eq 'GLOB';

	return $data;
}

	#token op_array1					=> q/\b(?:pop|push|CORE::shift|slice|unshift|sort)\b/;
	#token op_array2					=> q/\b(?:grep|map|join|sort)\b/;

	#token op_hash					=> q/\b(?:keys|values|each)\b/;
	#token op_reverse				=> q/\b(?:reverse)\b/;

######### SCALAR ######################################################
#sub m          { [ $_[0] =~ m{$_[1]} ] }
#sub nm         { [ $_[0] !~ m{$_[1]} ] }
#sub split { no strict 'refs';
#	#my $list = CORE::shift;
#	my $sep = CORE::shift; my $var = CORE::shift;
#
#	print "### SPLIT $sep | $var\n";
#
#	wantarray ? split $sep, $var : [ split $sep, $var ];
#}
#
########## HASH ######################################################
##sub delete  {
##    my $hash = CORE::shift;
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
##    my $hash = CORE::shift;
##    return exists $hash->{$_[0]};
##}

sub keys ($){
	my $hash = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
	my $res = [ CORE::keys(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

sub values ($){
	my $hash = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
	my $res = [ CORE::values(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

sub each ($){
	my $hash = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'each') unless ref $hash eq 'HASH';
	my $res = [ CORE::each(%$hash) ];
	return $res;
	# return wantarray ? @$res : $res;
}

# sub each {
#    my $hash = CORE::shift;
#    my $cb = CORE::shift;
# 	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
#    # Reset the each iterator. (This is efficient in void context)
#    keys %$hash;
#
#    while((my $k, my $v) = each(%$hash)) {
#        # local $_ = $v; # XXX may I break stuff?
#        $cb->($k, $v);
#    }
#
#    return;
# }

########## ARRAY ######################################################
# sub grep (&$){
# 	my $filter = CORE::shift;
# 	my $arr = CORE::shift;
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

# sub grep {
#    no warnings 'redefine';
#    if(FIVETEN) {
#         eval '
#             # protect perl 5.8 from the alien, futuristic syntax of 5.10
#             *__RISE_GREP = sub {
#
#                 my $filter = CORE::shift;
#                 my $arr = CORE::shift;
#                 my @result = grep { $_ ~~ $filter } @$arr;
#                 return wantarray ? @result : \@result;
#             }
#        ' or croak $@;
#    } else {
#        *__RISE_GREP = sub {
#             my $filter = CORE::shift;
#             my $arr = CORE::shift;
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

## last version: sub map (\@&) { my $arr = CORE::shift; my $sub = CORE::shift; [ map { $sub->($_) } @$arr ]; }
#

sub __RISE_GREP_BLOCK (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
    # my $res = [grep { &$code } @$array];
	return [CORE::grep { &$code } @$array];
	# return wantarray ? @$res : $res;
}

sub __RISE_MAP_BLOCK (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'map') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
	# my $res = [ map { &$code } @$array ];
	return [ CORE::map { &$code } @$array ];
	# return wantarray ? @$res : $res;
}

sub UNIVERSAL::grep ($$){
	my( $filter, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $array eq 'ARRAY';
    # my $res = [grep $filter, @$array];
	# return wantarray ? @$res : $res;
	# return [CORE::grep { m/$filter/ } @$array];
    return '##### OK ######';
}

sub __RISE_GREP ($$){
	my( $filter, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $array eq 'ARRAY';
    # my $res = [grep $filter, @$array];
	return [CORE::grep { m/$filter/ } @$array];
	# return wantarray ? @$res : $res;
}

sub map ($$){
	my( $filter, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'map') unless ref $array eq 'ARRAY';
	# my $res = [ map $filter, @$array ];
	return [ CORE::map { m/$filter/ } @$array ];
	# wantarray ? return @$res : return $res;
}

sub join ($$){
	my $filter	= CORE::shift;
	my $array	= CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'join') unless ref $array eq 'ARRAY';
	CORE::join $filter, @$array;
}

sub reverse ($){
	my $data	= CORE::shift;
	my $res;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'reverse') unless ref $data eq 'ARRAY' || ref $data eq 'HASH';
	@$res = CORE::reverse @$data if ref $data eq 'ARRAY';
	%$res = CORE::reverse %$data if ref $data eq 'HASH';
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_SORT_BLOCK (&$){
	my $sub		= CORE::shift;
	my $array	= CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'sort') unless ref $array eq 'ARRAY' || ref $array eq 'HASH';
	my $res = [ sort { &$sub || $a cmp $b } @$array ];
	return $res;
}

sub pop ($){
	my $array = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'pop') unless ref $array eq 'ARRAY';
	return CORE::pop @$array;
}

sub push ($$){
	my $array	= CORE::shift;
	my $list 	= CORE::shift;
	$list		= [$list] if ref $list ne 'ARRAY';
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'push') unless ref $array eq 'ARRAY';
	return CORE::push @$array, @$list;
}

sub shift ($){
	my $array = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'CORE::shift') unless ref $array eq 'ARRAY';
	return CORE::shift @$array;
}

sub unshift ($$){
	my $array	= CORE::shift;
	my $list 	= CORE::shift;
	$list		= [$list] if ref $list ne 'ARRAY';
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'unshift') unless ref $array eq 'ARRAY';
	return CORE::unshift(@$array, @$list);
}

sub size ($){
	my $array = CORE::shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'size') unless ref $array eq 'ARRAY';
	CORE::scalar @$array;
}

sub splice {
	my $array	= CORE::shift;
	my $offset	= CORE::shift;
	my $lenght	= CORE::shift;
	my $list	= CORE::shift;

	return [CORE::splice @$array,$offset,$lenght, @$list] if $list;
	return [CORE::splice @$array,$offset,$lenght] if $lenght;
	return [CORE::splice @$array,$offset] if $offset;
	return [CORE::splice @$array];
}

# sub __RISE_SPLIT ($){
# 	my $filter	= CORE::shift;
# 	my $data	= CORE::shift;
# 	__PACKAGE__->__RISE_ERR('SCALAR', 'split') unless ref $list;
# 	return split $filter, $data;
# }

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
	# 	my $arr = \+CORE::shift;
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
	my $var = CORE::shift;
	${__PACKAGE__."::__VARTYPE__"} = ref $var;

	return $$var if ${__PACKAGE__."::__VARTYPE__"} eq 'SCALAR';
	return @$var if ${__PACKAGE__."::__VARTYPE__"} eq 'ARRAY';
	return %$var if ${__PACKAGE__."::__VARTYPE__"} eq 'HASH';
	return &$var if ${__PACKAGE__."::__VARTYPE__"} eq 'CODE';
	return *$var if ${__PACKAGE__."::__VARTYPE__"} eq 'GLOB';
}

sub test {
	my $self = CORE::shift;
	'its working';
}

1;
