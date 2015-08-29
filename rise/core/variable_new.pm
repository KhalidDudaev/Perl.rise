package rise::core::variable_new;
use strict;
use vars qw($VERSION);

use parent 'rise::object::object', 'rise::object::class', 'rise::object::error', 'rise::object::variable';

$VERSION = '0.001';

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
 
my %access = (
	private		=> \&private_var,
	protected	=> \&protected_var,
	#public		=> sub {}
);

my $accessmod	= 'public';
my $var_name;
my $class_name;
my $type;
my $type_regex;
my $__VALUE__		= {};
#my $v;

my $ref			= 'v';
 
sub import { no strict; no warnings;
	my $self = shift;
	my($obj)			= caller(0);
	
	#bless {} => $self;
	
	#$class_name = $class;
	#my $ref = shift;
	my ($ref, $accessmod, $type, $type_regex) = @_;
	my ($class_name, $var_name)	= $obj =~ /(?:(.*?)::)?(\w+)$/;
	
	my $parent = $class_name;
	$parent			=~ s/(?:(.*?)::)\w+$/$1/;
	
	#$__VALUE__->{$obj} = $ref;
	
	push @{$obj.'::ISA'}, ('rise::object::variable', 'rise::core::variable_new');
	#push (@{$obj}, 'rise::object::variable');
	push (@{$class_name.'::ISA'}, $parent) if $parent && $parent ne 'main'; 
	
	#print ">>>>>>>> parent: $parent | self: $self | obj: $obj | class: $class_name | name: $var_name | accmod: $accessmod <<<<<<<<<\n";
	#*{$class} = \&value;
	
	my $r			= qr/^$class_name\b/o;
	
	*{$obj} = VARIABLE($self, $class_name, $var_name, $accessmod, $ref, $r);

	#*{$obj} = CONSTANT($self, $class_name, $var_name, $accessmod, $ref, $r);
	
	#*{$obj} = sub () :lvalue {
	#	$$ref;
	#};# if $accessmod eq 'public';
	#
	#*{$obj} = sub () :lvalue { private($self, $class_name,$var_name) unless (caller eq $class_name || caller =~ m/$r/o);
	#	$$ref;
	#} if $accessmod eq 'private';
	#
	#*{$obj} = sub () :lvalue { protected($self, $class_name,$var_name) unless (caller->isa($class_name));
	#	$$ref;
	#} if $accessmod eq 'protected';
	
	#return *{$class} = sub () :lvalue { $access{$accessmod}->($class,$var_name); $__VALUE__->{$class} } if $accessmod ne 'public';
	#return *{$class} = sub () :lvalue { $__VALUE__->{$class} }; # if $accessmod eq 'public';
	
	#eval "";
	#*{$class} = sub () :lvalue { ${$class.'::'.$var_name} };
	
}

sub val { #no strict 'refs';
	my $self = shift;
	my $caller = caller;
	#print "[ ".$caller."::".$self." ]";
	${$__VALUE__->{$caller.'::'.$self}};
};

sub VARIABLE { no strict 'refs';
	my $v;
	my ($self, $class_name, $var_name, $accessmod, $ref, $r) = @_;
	my $obj = $class_name.'::'.$var_name;
	
	print ">>>>>>>> accmod: $accessmod <<<<<<<<<\n";
	
	$__VALUE__->{$obj} = $ref;
	#$ref = \$v;
	$v = $ref;
	
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
#{no strict; sub value() :lvalue {  $access{$accessmod}->($class_name,$var_name) if $accessmod ne 'public';
#	$__VALUE__->{$class_name};
#}}
#
##sub obj_type {'variable'};
#
#sub private_var {
#	my ($self, $class, $name)			= @_;
#	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
#	#print ">>>>>>>>>>>>> class - $class | name - $name | caller - $caller\n";
#	$caller =~ m/^$class.*$/ || $self->__error('var_priv', $class, $name, $caller);
#}
#
#sub protected_var {
#	my ($self, $class, $name)			= @_;
#	my $caller			= (caller(1))[0];	#$class		=~ s/(.*)::\w+/$1/;
#	#print ">>>>>>>>>>>>> self - $self | class - $class | name - $name | caller - $caller\n";
#	$caller->isa($class) ||  $self->__error('var_prot', $class, $name, $caller);
#}

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