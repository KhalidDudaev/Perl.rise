package rise::object::class;
use strict;
use warnings;
use utf8;

use parent 'rise::object::object', 'rise::object::error', 'rise::object::function', 'rise::object::variable';

our $VERSION 	= '0.01';

#my @export_list = qw/
#this
#super
#/;

#sub _this_	{ $_[0] }
#sub _super_	{ no strict 'refs'; ${ $_[0].'::ISA' }[1]; }

#our $INHERIT = 0;

my $conf		= {
	this_class		=> 'rise::object::class',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

#my $ERROR		= {
#	class_priv				=> [ [ 0, 1 ], '"CLASS ERROR: Can\'t access class \"$parent\" at $file line $line\n"' ],
#	class_prot				=> [ [ 0, 1 ], '"CLASS ERROR: Class \"$parent\" only extends at $file line $line\n"' ],
#	class_priv_inherit		=> [ [ 0, 2 ], '"CLASS ERROR: Can\'t access class \"$parent\" at $file line $line\n"' ],
#};

sub new {
	my $class					= ref $_[0] || $_[0];

	my $this					= $conf;
	my $lock = sub {
		my $field				= shift;
		$this->{$field} 		= shift if @_;
		$this->{$field};
	};
	
	$this                   	= bless($lock, $class);                         # обьявляем класс и его свойства
	
	return $this;
}

#sub new {
#    my ($param, $class, $self)	= ($PACK_ENV, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
#    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
#	return $self;
#}

#sub import {
#	$INHERIT = shift;
#	#print "###################### $INHERIT IMPORTED ####################\n";
#}
			
sub self { shift }

#sub import {
#	my $caller = caller;
#	
#	strict		->import();	
#	warnings	->import();
#
#	no strict 'refs';
#	
#	*{$caller . "::this"} = *this;
#	
#	#for (@export_list) {
#	#	*{$caller . "::$_"} = *$_;
#	#}
#}

################################# ACCESS MODE #################################
sub private_class {
	my ($self)			= @_;
	my $starter			= (caller(4))[3] || 'RUN';
	my $callercode		= (caller(2))[3] || ''; $callercode		=~ s/.*::(\w+)/$1/g;
	my $callercode_eval	= (caller(3))[3] || ''; $callercode_eval	=~ s/.*::(\w+)/$1/g;
	
	
	#print "################################# $callercode_eval #################################\n";
	
	my $access			= ($callercode eq 'import' || $callercode_eval eq 'import') ? 'class_priv_inherit' : 'class_priv';
	
	$starter eq 'RUN' or $self->__error($access);
}

sub protected_class {
	my ($self)			= @_;
	my $callercode		= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/;
	my $callercode_eval	= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/;
	
	($callercode eq 'import' || $callercode_eval eq 'import') or $self->__error('class_prot');
}

sub public_class {}

sub DESTROY {}

1;

