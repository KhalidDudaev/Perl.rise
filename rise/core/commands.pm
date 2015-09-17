package rise::core::commands;

use strict;
use warnings;
use utf8;

use parent qw/
	rise::object::error
/;

use Data::Dump 'dump';

#use autobox::Core;

our $VERSION = '0.000';
use constant FIVETEN => ($] >= 5.010);

my $cenv					= {};
my @export_list 			= qw/
	_
	__RISE_A2R
	__RISE_H2R
	__RISE_R2A
	__RISE_R2H
	__RISE_2R
	__RISE_R2

	__RISE_MAP
	__RISE_GREP
	__RISE_JOIN
	__RISE_REVERSE
	__RISE_SORT
	__RISE_POP
	__RISE_PUSH
	__RISE_SHIFT
	__RISE_UNSHIFT
	__RISE_SIZE
	__RISE_SLICE

	__RISE_KEYS
	__RISE_VALUES
	__RISE_EACH
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

sub __RISE_COMMANDS { no strict 'refs';
	my $self	= shift || caller(0);
	#autobox::Core->import;
	*{$self . "::$_"} = \&$_ for @export_list;
}

sub _ { $_ };

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
	my $res = [ keys %{$_[0]} ];
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_VALUES ($){
	my $hash = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'keys') unless ref $hash eq 'HASH';
	my $res = [ values %{$_[0]} ];
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
#        # local $_ = $v; # XXX may I break stuff?
#        $cb->($k, $v);
#    }
#
#    return;
# }

########## ARRAY ######################################################
sub __RISE_GREP (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'grep') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
    my $res = [grep { &$code } @$array];
	return $res;
	# return wantarray ? @$res : $res;
}

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
sub __RISE_MAP (&$){
	my( $code, $array ) = @_;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'map') unless ref $code eq 'CODE' && ref $array eq 'ARRAY';
	my $res = [ map { &$code } @$array ];
   # [map { &{$_[0]} } @{$_[1]}] || __PACKAGE__->__RISE_ERR('ARR_HASH', 'map');
	return $res;
	# wantarray ? return @$res : return $res;
}


sub __RISE_JOIN ($$){
	my $separ = shift;
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'join') unless ref $array eq 'ARRAY';
	join $separ, @$array;
}

# sub __RISE_REVERSE {
# 	my @res = reverse @{$_[0]};
# 	wantarray ? @res : \@res;
# }

sub __RISE_REVERSE ($){
	my $data = shift;
	my $res;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'reverse') unless ref $data eq 'ARRAY' || ref $data eq 'HASH';
	@$res = reverse @$data if ref $data eq 'ARRAY';
	%$res = reverse %$data if ref $data eq 'HASH';
	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_SORT ($;&$){
	my $sub		= sub { $a cmp $b };
	my $array	= shift();

	if (ref $array eq 'CODE') {
		print ">>>>>>>>>>>>> SORT CODE FILTER <<<<<<<<<<<<<<\n";
		$sub	= $array;
		$array	= shift;
	}

	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'sort') unless ref $array eq 'ARRAY' || ref $array eq 'HASH';
	# my $res = [ sort { $sub->($a, $b) } @$array ];
	my $res = [ sort { &$sub } @$array ];

	# print ">>>>>>>>>>>>> SORT RES - ".dump($res)." <<<<<<<<<<<<<<\n";

	return $res;
	# return wantarray ? @$res : $res;
}

sub __RISE_POP ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'pop') unless ref $array eq 'ARRAY';
	return pop @$array;
}

sub __RISE_PUSH ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'push') unless ref $array eq 'ARRAY';
	return push @$array, @_;
}

sub __RISE_SHIFT ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'shift') unless ref $array eq 'ARRAY';
	return shift @$array;
}

sub __RISE_UNSHIFT ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'unshift') unless ref $array eq 'ARRAY';
	return unshift(@$array, @_);
}

sub __RISE_SIZE ($){
	my $array = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'scalar') unless ref $array eq 'ARRAY';
	scalar @$array;
}

sub __RISE_SLICE ($){
	my $list = shift;
	__PACKAGE__->__RISE_ERR('ARRAY_HASH', 'slice') unless ref $list eq 'ARRAY';
	return [@{$list}[@_]];
}

##########################################################################################


{ no strict 'refs';
	sub __RISE_A2R (@){ wantarray ? @_ : \@_ }
	# sub __RISE_A2R (@){ \@_ }
	sub __RISE_H2R (%){+{@_}}
	sub __RISE_R2A ($){@{$_[0]}}
	# sub __RISE_R2A ($){ wantarray ? @{$_[0]} : $_[0] }
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
