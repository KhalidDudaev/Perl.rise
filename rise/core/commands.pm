package rise::core::commands;

use strict;
use warnings;
use utf8;

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
#	#my $list = CORE::shift;
#	my $sep = CORE::shift; my $var = CORE::shift;
#	
#	print "### SPLIT $sep | $var\n";
#	
#	wantarray ? CORE::split $sep, $var : [ CORE::split $sep, $var ];
#}
#
########## HASH ######################################################
##sub delete  {
##    my $hash = CORE::shift;
## 
##    my @res = ();
##    foreach(@_) {
##        push @res, CORE::delete $hash->{$_};
##    }
## 
##    return wantarray ? @res : \@res
##}
# 
##sub exists {
##    my $hash = CORE::shift;
##    return CORE::exists $hash->{$_[0]};
##}
# 
#sub keys {
#    return wantarray ? CORE::keys %{$_[0]} : [ CORE::keys %{$_[0]} ];
#}
# 
#sub values {
#    return wantarray ? CORE::values %{$_[0]} : [ CORE::values %{$_[0]} ]
#}
#
#sub each {
#    my $hash = CORE::shift;
#    my $cb = CORE::shift;
#
#    # Reset the each iterator. (This is efficient in void context)
#    CORE::keys %$hash;
#
#    while((my $k, my $v) = CORE::each(%$hash)) {
#        # local $_ = $v; # XXX may I break stuff?
#        $cb->($k, $v);
#    }
#
#    return;
#}
#
########## ARRAY ######################################################
#sub grep {
#    no warnings 'redefine';
#    if(FIVETEN) {
#         eval '
#             # protect perl 5.8 from the alien, futuristic syntax of 5.10
#             *grep = sub {
#                 my $arr = CORE::shift;
#                 my $filter = CORE::shift;
#                 my @result = CORE::grep { $_ ~~ $filter } @$arr;
#                 return wantarray ? @result : \@result;
#             }
#        ' or croak $@;
#    } else {
#        *grep = sub {
#             my $arr = CORE::shift;
#             my $filter = CORE::shift;
#             my @result;
#             if( CORE::ref $filter eq 'Regexp' ) {
#                 @result = CORE::grep { m/$filter/ } @$arr;
#             } elsif( ! ref $filter ) {
#                 @result = CORE::grep { $filter eq $_ } @$arr;  # find all of the exact matches
#             } else {
#                 @result = CORE::grep { $filter->($_) } @$arr;
#             }
#             return wantarray ? @result : \@result;
#        };
#    }
#    autobox::Core::ARRAY::grep(@_);
#}
# 
## last version: sub map (\@&) { my $arr = CORE::shift; my $sub = shift; [ CORE::map { $sub->($_) } @$arr ]; }
# 
#sub map {
#    my( $array, $code ) = @_;
#    my @result = CORE::map { $code->($_) } @$array;
#    return wantarray ? @result : \@result;
#}
# 
#sub join { my $sep = CORE::shift; my $arr = CORE::shift; CORE::join $sep, @$arr; }
# 
#sub reverse { my @res = CORE::reverse @{$_[0]}; wantarray ? @res : \@res; }
# 
#sub sort {
#    my $arr = CORE::shift;
#    my $sub = CORE::shift() || sub { $a cmp $b };
#    my @res = CORE::sort { $sub->($a, $b) } @$arr;
#    return wantarray ? @res : \@res;
#}
#
#sub pop  { CORE::pop @{$_[0]}; }
# 
#sub push {
#    my $arr = CORE::shift;
#    CORE::push @$arr, @_;
#    return wantarray ? return @$arr : $arr;
#}
#
#sub shift   {
#    my $arr = CORE::shift;
#    return CORE::shift @$arr;
#}
#
#sub unshift {
#    my $a = CORE::shift;
#    CORE::unshift(@$a, @_);
#    return wantarray ? @$a : $a;
#}
# 
#sub size   { my $arr = CORE::shift; CORE::scalar @$arr; }
#
#sub slice {
#    my $list = CORE::shift;
#    # the rest of the arguments in @_ are the indices to take
#
#    return wantarray ? @$list[@_] : [@{$list}[@_]];
#}

##########################################################################################


{ no strict 'refs';
	sub __RISE_A2R { wantarray ? @_ : \@_ }
	sub __RISE_H2R {+{@_}}
	sub __RISE_R2A {@{$_[0]}}
	sub __RISE_R2H {%{$_[0]}}
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
