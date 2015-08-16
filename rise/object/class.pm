package rise::object::class;
use strict;
use warnings;
use utf8;

#use Data::Dump 'dump';
#local $\ = "\n";
#use overload
#  '""'	=> sub { @_ },
#  '0+'	=> sub { @_ };
  
use parent 'rise::object::object', 'rise::object::error', 'rise::object::function', 'rise::object::variable', 'rise::core::commands';

our $VERSION 	= '0.01';

my $ERROR_MESSAGES		= '';

my @export_list = qw/
	rise_arr_to_ref
/;

#__PACKAGE__->import;

#sub _this_	{ $_[0] }
#sub _super_	{ no strict 'refs'; ${ $_[0].'::ISA' }[1]; }

#our $INHERIT = 0;

my $conf		= {
	this_class		=> 'rise::object::class',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

#__PACKAGE__->interface_confirm();

#my $ERROR		= {
#	class_priv				=> [ [ 0, 1 ], '"CLASS ERROR: Can\'t access class \"$parent\" at $file line $line\n"' ],
#	class_prot				=> [ [ 0, 1 ], '"CLASS ERROR: Class \"$parent\" only extends at $file line $line\n"' ],
#	class_priv_inherit		=> [ [ 0, 2 ], '"CLASS ERROR: Can\'t access class \"$parent\" at $file line $line\n"' ],
#};

#sub new {
#    my ($class, $string) = @_;
#    return bless +{ string => $string }, $class;
#}

sub new {
	my $class					= ref $_[0] || $_[0];

	my $this					= $conf;
	#my $lock = sub {
	#	my $field				= shift;
	#	$this->{$field} 		= shift if @_;
	#	$this->{$field};
	#};
	
	$this                   	= bless($this, $class);                         # обьявляем класс и его свойства
	
	return $this;
}

#sub new {
#    my ($param, $class, $self)	= ($PACK_ENV, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
#    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
#	return $self;
#}

sub import {
	my $self	= shift;
	$self->commands;
}
			
sub self { shift }
sub obj_type {'CLASS'};

#sub import { no strict 'refs';
#	my $self	= shift;
#	#strict		->import();	
#	#warnings	->import();
#	
#	#print "############ $self - $caller \n";
#	
#	for (@export_list) {
#		*{$self . "::$_"} = *$_;
#	}
#}

sub interface_confirm {
	no strict 'refs';
	no warnings;
	my $class				= shift; #caller(2);
	#my $child			= caller(2);
	#print "############ $class ###########";

	my $interfacelist		= \%{$class.'::IMPORT_INTERFACELIST'};
	my @objnames 			= keys %$interfacelist;
	my $objlist				= '';
	my $obj_name;
	my $obj_type;
	my $obj_accmod;
	#my $obj_tmpl;

	#print "### - " . dump $interfacelist;
	#print "\n";
	
	#if (exists &{$class.'::__OBJLIST__'}) {
		#$objlist 				= $class->__OBJLIST__ if exists &{$class.'::__OBJLIST__'};
		$objlist 				= $class->__OBJLIST__;
		#$objlist->{variable}	= $class->__VARLIST__;
		
	#print ">>>>>>> " . $objlist;
	#print "\n";
		
		foreach my $object (@objnames) {
			($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
			
			#print " --- ############ $object ###########\n";
			
			$ERROR_MESSAGES .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$class\"\n" if ($objlist !~ m/\b$object\b/);
		}
	#}
	die $ERROR_MESSAGES if $ERROR_MESSAGES ne '';
}

################################# ACCESS MODE #################################
sub private_class {
	my ($self)			= @_;
	my $starter			= (caller(4))[3] || 'RUN';
	my $callercode		= (caller(2))[3] || 'PRIV 2'; #$callercode			=~ s/.*::(\w+)/$1/g;
	my $callercode_eval	= (caller(3))[3] || 'PRIV 3'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	
	#my $caller0			= (caller(0))[3] || 'PRIV 0'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller1			= (caller(1))[3] || 'PRIV 1'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller2			= (caller(2))[3] || 'PRIV 2'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller3			= (caller(3))[3] || 'PRIV 3'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	#my $caller4			= (caller(4))[3] || 'PRIV 4'; #$callercode_eval	=~ s/.*::(\w+)/$1/g;
	
	my $access			= ($callercode eq 'import' || $callercode_eval eq 'import') ? 'class_priv_inherit' : 'class_priv';
	
	#print ">>> $access - $starter - $callercode - $callercode_eval \n";
	#print ">>> $caller0 - $caller1 - $caller2 - $caller3 - $caller4 \n";
	
	$starter eq 'RUN' or $self->__error($access);
}

sub protected_class {
	my ($self)			= @_;
	my $callercode		= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/;
	my $callercode_eval	= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/;
	
	#print ">>>>>>>>>>>>> $callercode\n";
	
	($callercode eq 'import' || $callercode_eval eq 'import') or $self->__error('class_prot');
}

sub public_class {}

sub extends_error {
	shift->__error('class_inherits');
}

sub DESTROY {}

1;

