package rise::core::object::variable_new;
use strict;
use warnings;
use utf8;

use parent 'rise::core::object::object', 'rise::core::object::error';

our $VERSION 	= '0.01';

#our $ERROR		= {
#	var_priv				=> [ [ 0, 1 ], '"VARIABLE ERROR: Can\'t access variable \"$func\" from \"$parent\" at $file line $line\n"' ],
#	var_prot				=> [ [ 0, 1 ], '"VARIABLE ERROR: Variable \"$func\" from \"$parent\" only inheritable at $file line $line\n"' ],
#};

my $obj_type;

my %access = (
	private		=> \&private_var,
	protected	=> \&protected_var,
	public		=> sub {}
);

my $accessmod	= 'public';
my $var_name;
my $class_name;
my $type;
my $type_regex;
my $__VALUE__;

my $ENV_CLASS		= {
	this_class		=> 'rise::core::object::variable_new',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

#sub new {
#	my $class					= ref $_[0] || $_[0];
#	my $this					= $conf;
#	$this                   	= bless($this, $class);                         # обьявляем класс и его свойства
#	return $this;
#}

sub var { no strict;

	my $self		= shift;
	#my $accmod		= shift;

	#my $name		= $args->{name};
	#my $accmod		= $args->{accmod};

	($accessmod, $type, $type_regex) = @_;

    my ($obj)		= caller(0);
	my ($class_name, $var_name)	= $obj =~ /(?:(.*?)::)?(\w+)$/;
	my $r						= qr/^$class_name\b/o;
	my $parent = $class_name;
	$parent			=~ s/(?:(.*?)::)\w+$/$1/;

	#print ">>>>>>>> accmod: $accessmod | self: $self | obj: $obj | class: $class_name | name: $var_name <<<<<<<<<\n";
	my $vvv;

	*{$obj} = sub () :lvalue {
		#$__VALUE__->{$obj.'::'.$name};
		$vvv;
	} if $accessmod eq 'public';

	*{$obj} = sub () :lvalue { #my $self = __PACKAGE__;
		#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
		__PACKAGE__->__error('PRIVATE', $class_name, $var_name, caller) unless (caller eq $class_name || caller =~ m/$r/o);
		#$__VALUE__->{$obj.'::'.$name};
		$vvv;
	} if $accessmod eq 'private';

	*{$obj} = sub () :lvalue { #my $self = __PACKAGE__;
		#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
		__PACKAGE__->__error('PROTECTED', $class_name, $var_name, caller) unless caller->isa($class_name);
		#$__VALUE__->{$obj.'::'.$name};
		$vvv;
	} if $accessmod eq 'protected';



	#*{$obj.'::obj_type'} = sub {'SCALAR'};


	#goto &{$obj};

}

#sub var { no strict 'refs'; no warnings;
#	my $self = shift;
#	my($obj)			= caller(0);
#
#	($accessmod, $type, $type_regex) = @_;
#	my ($class_name, $var_name)	= $obj =~ /(?:(.*?)::)?(\w+)$/;
#
#	my $parent = $class_name;
#	$parent			=~ s/(?:(.*?)::)\w+$/$1/;
#
#	#push (@{$obj}, 'rise::core::object::variable');
#	push (@{$class_name.'::ISA'}, $parent) if $parent ne 'main';
#
#	#print ">>>>>>>> parent: $parent | self: $self | obj: $obj | class: $class_name | name: $var_name <<<<<<<<<\n";
#
#	*{$obj} = sub () :lvalue { $__VALUE__->{$class_name} };# if $accessmod eq 'public';
#	*{$obj} = sub () :lvalue { my $self = __PACKAGE__;
#		#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
#		$self->__error('var_priv', $obj, $var_name, caller) unless (caller =~ m/^$obj.*$/);
#		#$__VALUE__->{$obj.'::'.$var_name};
#		${$obj.'::'.$var_name};
#	} if $accessmod eq 'private';
#
#	*{$obj} = sub () :lvalue { protected_var($self, $class_name,$var_name); $__VALUE__->{$class_name} } if $accessmod eq 'protected';
#
#	goto &{$obj};
#}

sub value() :lvalue { no strict; $access{$accessmod}->($class_name,$var_name);
	${$class_name.'::value'}
}

sub access {

}

sub obj_type {'variable'};
#sub type {'SCALAR'}

sub var_init { $obj_type = ref \$_[0] }
sub type { no strict;
	my $self 	= shift;
	my $class	= caller(1);
	print "\n###>>> self - $self | class - $class\n";
	$obj_type;
}

################################ ACCESS MODE #################################
#sub _private_var {
#	my $class			= shift;
#	my $class_caller	= shift || '???';
#	my $parent			= shift;
#	my $caller			= shift;
#
#	print "\n###############################\
#class			- $class
#class_caller		- $class_caller
#parent			- $parent
#caller			- $caller
################################\n" if $class_caller ne '???';
#
#	$parent =~ m/^$class.*$/ or $class->_error($ERROR->{var_priv});
#	#$class->can($caller) or $class->_error($ERROR->{var_priv});
#}
#
#sub _protected_var {
#	my $class			= shift;
#	my $class_caller	= shift || '???';
#	my $parent			= shift;
#	my $caller			= shift;
#
#	print "\n###############################\
#class			- $class
#class_caller		- $class_caller
#parent			- $parent
#caller			- $caller
################################\n" if $class_caller ne '???';
#
#
#	$parent->isa($class) or  $class->_error($ERROR->{var_prot});
#}

sub private_var {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller =~ m/^$class.*$/ || $self->__error('var_priv', $class, $name, $caller);
}

sub protected_var {
	my ($self, $class, $name)			= @_;
	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$caller->isa($class) ||  $self->__error('var_prot', $class, $name, $caller);
}

sub public_var {}

sub DESTROY {}

1;
