package rise::core::object::variable::variable;

use strict;
use vars qw($VERSION);

use parent 'rise::core::object::object', 'rise::core::object::class', 'rise::core::object::error', 'rise::core::object::variable';

$VERSION = '0.001';

my $__VALUE__		= {};

my $ref			= 'v';

sub __VALUE__ {$__VALUE__}
 
sub import { no strict; no warnings;
	my $self = shift;
	my($obj)			= caller(0);

	my ($ref, $accessmod, $type, $type_regex) = @_;
	my ($class_name, $var_name)	= $obj =~ /(?:(.*?)::)?(\w+)$/;
	
	my $parent = $class_name;
	$parent			=~ s/(?:(.*?)::)\w+$/$1/;

	#push @{$obj.'::ISA'}, ('rise::core::object::variable', 'rise::core::object::variable::variable', $parent);
	push (@{$class_name.'::ISA'}, $parent) if $parent && $parent ne 'main'; 
	
	$var_name		=~ s/\_LOCAL\d+$//sx;	
	
#	print ">>>>>>>>
#	self	: $self	
#	parent	: $parent
#	class	: $class_name
#	object	: $obj
#	name	: $var_name
#<<<<<<<<<\n";
	
	my $r			= qr/^$parent\b/;
	

	
	*{$obj} = VARIABLE($self, $parent, $class_name, $var_name, $accessmod, $ref, $r);
}

sub val {
	my $self = shift;
	my $caller = caller;
	${__VALUE__->{$caller.'::'.$self}};
};

sub VARIABLE { no strict 'refs';
	
	my ($self, $parent, $class_name, $var_name, $accessmod, $ref, $r) = @_;
	my $obj				= $class_name.'::'.$var_name;
	my $v				= $ref;
	
	$accessmod			||= '';
	__VALUE__->{$obj} = $ref;
	
	return  sub () :lvalue { private($self, $class_name,$var_name) unless (caller eq $class_name || caller =~ m/$r/o);
		$$v;
	} if $accessmod eq 'private';
	
	return  sub () :lvalue { protected($self, $class_name,$var_name) unless (caller->isa($class_name));
		$$v;
	} if $accessmod eq 'protected';
	
	return sub () :lvalue {
		$$v;
	};# if $accessmod eq 'public';
}

sub CONSTANT {
	
	my ($self, $class_name, $var_name, $accessmod, $ref, $r) = @_;
	
	return  sub () { private($self, $class_name,$var_name) unless (caller eq $class_name || caller =~ m/$r/o);
		$$ref;
	} if $accessmod eq 'private';
	
	return  sub () { protected($self, $class_name,$var_name) unless (caller->isa($class_name));
		$$ref;
	} if $accessmod eq 'protected';
	
	return sub () {
		$$ref;
	};# if $accessmod eq 'public';

}

sub private {
	my ($self, $class, $name)			= @_;
	#my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> class - $class | name - $name | caller - $caller\n";
	$self->__error('var_priv', $class, $name, caller);
}

sub protected {
	my ($self, $class, $name)			= @_;
	#my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
	$self->__error('var_prot', $class, $name, caller);
}

1;

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################
 
##sub import { no strict;
##    my $child		= caller(0);
##	my $parent		= $child;
##	
##	#$parent			=~ s/\:\:CODE\:\:/::/;
##	
##	#print ">>>>>>>> $child <<<<<<<<<\n";
##	
##	*{$child} = \&{$child."::code"};
##}
#
#my $__VALUE__ 	= {};
#
#sub import { no strict;
#			
#	my $self = shift;
#	($accessmod, $type, $type_regex) = @_;
#			
#    my ($obj, $b, $c, $d)		= caller(0);
#	#my $parent		= $child;
#	my ($class_name, $var_name)	= $obj =~ /(?:(.*?)::)?(\w+)$/;
#	
#	my $parent = $class_name;
#	$parent			=~ s/(?:(.*?)::)\w+$/$1/;
#	
#	#print ">>>>>>>> parent: $parent | self: $self | obj: $obj | class: $class_name | name: $var_name <<<<<<<<<\n";
#	
#	
#	push @{$obj.'::ISA'}, 'rise::core::object::variable';
#	*{$obj} = \&{$obj.'::value'};
#	#goto &$obj;
#	
#	#eval "my \$${var_name}; *${child}::value =  sub () :lvalue { \$${var_name} }";
#	#*{$child} = \&{$child.'::value'};
#	
#	#*{$child.'::'.$var_name} = \${$var_name};
#	#*{$child.'::value'} =  sub () :lvalue { ${$child.'::'.$var_name} };
#	#*{$child} = \&{$child.'::value'};
#	
#	#eval "my \$${var_name};";
#	#*{$obj} = sub () :lvalue { $__VALUE__->{$obj} };
#	
#	############################################################################################################
#	#return *{$obj} = sub () :lvalue { my $self = __PACKAGE__;
#	#	my $caller = (caller(0))[0];
#	#	
#	#	#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
#	#	
#	#	#$caller =~ m/^$class_name.*$/ || $self->__error('var_priv', $class_name, $var_name, $caller);
#	#	#private_var($self, $class_name,$var_name);
#	#	
#	#	unless (caller =~ m/^$class_name.*$/)
#	#			{
#	#				require Carp;
#	#				Carp::croak "vpriv is a private variable of app::App::App2!";
#	#				__PACKAGE__->__error($var_name, $class_name, 'vpriv', $caller);
#	#			}
#	#	
#	#	
#	#	$__VALUE__->{$obj};
#	#} if $accessmod eq 'private';
#	#
#	#return *{$obj} = sub () :lvalue { my $self = __PACKAGE__;
#	#	my $caller = (caller(0))[0];
#	#	
#	#	#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
#	#	
#	#	$caller->isa($class_name) ||  $self->__error('var_prot', $class_name, $var_name, $caller);
#	#	#protected_var($self, $class_name,$var_name);
#	#	$__VALUE__->{$obj};
#	#} if $accessmod eq 'protected';
#	#
#	#return *{$obj} = sub () :lvalue { $__VALUE__->{$obj} };# if $accessmod eq 'public';
#	############################################################################################################
#	
#	#*{$child} = \&{"$child::$var_name"};
#	#*{$child} = \${"$child::value"};
#	#*{"$child::type"} = \&type;
#	
#}
#
#sub private_var {
#	my ($self, $class, $name)			= @_;
#	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
#	print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class | name: $name\n";
#	$caller =~ m/^$class.*$/ || $self->__error('var_priv', $class, $name, $caller);
#}
#
#sub protected_var {
#	my ($self, $class, $name)			= @_;
#	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
#	print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class | name: $name\n";
#	$caller->isa($class) ||  $self->__error('var_prot', $class, $name, $caller);
#}
#
##{ no strict;
##	sub value() :lvalue { ${'var'} }
##}
#1;