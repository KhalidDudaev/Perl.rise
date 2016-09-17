package rise::core::object::variable::variable_next;
use strict;
use vars qw($VERSION);
$VERSION = '0.001';

use parent 'rise::core::object::object', 'rise::core::object::error', 'rise::core::object::variable';

#sub import { no strict;
#    my $child		= caller(0);
#	my $parent		= $child;
#
#	#$parent			=~ s/\:\:CODE\:\:/::/;
#
#	#print ">>>>>>>> $child <<<<<<<<<\n";
#
#	*{$child} = \&{$child."::code"};
#}

my $__VALUE__ 	= {};

sub import { no strict;

	my $self		= shift;
	my $args		= shift;

	my $name		= $args->{name};
	my $accmod		= $args->{accmod};
	my $ref			= $args->{ref};

    my ($obj)		= caller(0);
	my $r			= qr/^$obj.*$/o;


	# print ">>>>>>>> parent: $parent | self: $self | obj: $obj | class: $obj | name: $name <<<<<<<<<\n";

	*{$obj.'::'.$name} = sub () :lvalue {
		#$__VALUE__->{$obj.'::'.$name};
		#${$obj.'::'.$name};
		$$ref;
	} if $accmod eq 'public';

	*{$obj.'::'.$name} = sub () :lvalue {
		#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
		__PACKAGE__->__error('var_priv', $obj, $var_name, caller) unless (caller eq $obj || caller =~ m/$r/o);
		#$__VALUE__->{$obj.'::'.$name};
		#${$obj.'::'.$name};
		$$ref;
	} if $accmod eq 'private';

	*{$obj.'::'.$name} = sub () :lvalue {
		#print ">>>>>>>>>>>>> self: $self | caller: $caller | class: $class_name | name: $var_name\n";
		__PACKAGE__->__error('var_prot', $obj, $var_name, caller) unless caller->isa($obj);
		#$__VALUE__->{$obj.'::'.$name};
		#${$obj.'::'.$name};
		$$ref;
	} if $accmod eq 'protected';



	*{$obj.'::'.$name.'::obj_type'} = sub {'SCALAR'};


	#goto &{$obj.'::'.$name};

}


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

#{ no strict;
#	sub value() :lvalue { ${'var'} }
#}
1;
