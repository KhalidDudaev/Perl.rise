package rise::object::error;
use strict;
use warnings;
use utf8;

use Carp;

our $VERSION = '0.01';

#our $INHERIT = 0;
my $VARS		= {};
my $ERROR		= {
	class_priv				=> [ [ 1, 2 ], '"ERROR CLASS: Can\'t access class \"$parent\" \nat $file line $line"' ],
	class_priv_inherit		=> [ [ 1, 3 ], '"ERROR CLASS: Can\'t access class \"$parent\" \nat $file line $line"' ],	
	class_prot				=> [ [ 1, 2 ], '"ERROR CLASS: Class \"$parent\" only extends \nat $file line $line"' ],
	class_inherits			=> [ [ 1, 1 ], '"ERROR CLASS: extends or implements syntaxis erorr in class \"$parent\" \nat $file line $line"' ],
	
	abstract_prot			=> [ [ 1, 2 ], '"ERROR ABSTRACT: Abstract class \"$parent\" only extends \nat $file line $line"' ],
	abstract_priv			=> [ [ 1, 1 ], '"ERROR ABSTRACT: An abstract class \"$parent\" cannot be private \nat $file line $line"' ],
	abstract_publ			=> [ [ 1, 1 ], '"ERROR ABSTRACT: An abstract class \"$parent\" cannot be public \nat $file line $line"' ],
	
	interface_prot			=> [ [ 1, 2 ], '"ERROR INTERFACE: Interface \"$parent\" only extends \nat $file line $line"' ],
	interface_priv			=> [ [ 1, 1 ], '"ERROR INTERFACE: An interface \"$parent\" cannot be private \nat $file line $line"' ],
	interface_publ			=> [ [ 1, 1 ], '"ERROR INTERFACE: An interface \"$parent\" cannot be public \nat $file line $line"' ],
	
	INTERFACE_CONFIRM		=> [ [ 1, 1 ], '"ERROR INTERFACE: $msg_error"' ],
	
	code_priv				=> [ [ 1, 2 ], '"ERROR FUNCTION: Can\'t access function \"$name\" from \"$class\" \nat $file line $line"' ],
	code_prot				=> [ [ 1, 2 ], '"ERROR FUNCTION: Function \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],
	
	CODE_PRIVATE			=> [ [ 0, 1 ], '"ERROR FUNCTION: Can\'t access function \"$name\" from \"$class\" \nat $file line $line"' ],
	CODE_PROTECTED			=> [ [ 0, 1 ], '"ERROR FUNCTION: Function \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],	
	
	var_priv				=> [ [ 1, 2 ], '"ERROR VARIABLE: Can\'t access variable \"$name\" from \"$class\" \nat $file line $line"' ],
	var_prot				=> [ [ 1, 2 ], '"ERROR VARIABLE: Variable \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],
	
	VAR_PRIVATE				=> [ [ 0, 1 ], '"ERROR VARIABLE: Can\'t access variable \"$name\" from \"$class\" \nat $file line $line"' ],
	VAR_PROTECTED			=> [ [ 0, 1 ], '"ERROR VARIABLE: Variable \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],
	
	VAR_CAST				=> [ [ 1, 2 ], '"ERROR TYPE: You can only assign a value type \"$name\" \nat $file line $line"' ],
	#VAR_PROTECTED			=> [ [ 0, 1 ], '"ERROR VARIABLE: Variable \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],
	
	
	PRIVATE					=> [ [ 0, 1 ], '"ERROR ACCESS: Can\'t access function \"$name\" from \"$class\" \nat $file line $line"' ],
	PROTECTED				=> [ [ 0, 1 ], '"ERROR ACCESS: Function \"$name\" from \"$class\" only inheritable \nat $file line $line"' ],
	
};
#my $conf						= {
#	class_priv				=> [0,1],
#	class_prot				=> [0,1],
#	class_priv_inherit		=> [0,2],
#	class_prot_inherit		=> [0,2],
#	
#	#interface				=> [0,1],
#	#interface_inherit		=> [1,4],
#	
#	obj_priv				=> [0,1],
#	obj_prot				=> [0,1],
#
#	var_priv				=> [0,1],
#	var_prot				=> [0,1],
#	code_priv				=> [1,2],
#	code_prot				=> [1,2],
#};

#sub import {
#	strict		->import();	
#	warnings	->import();
#	#$INHERIT = 1;
#}

#sub new {
#	my $class					= ref $_[0] || $_[0];
#	my $this					= $conf;
#	my $lock = sub {
#		my $field				= shift;
#		$this->{$field} 		= shift if @_;
#		$this->{$field};
#	};
#	$this                   	= bless($lock, $class);                         # обьявляем класс и его свойства
#	return $this;
#}

#sub __error {
#	my $self		= shift;
#	my ($level)		= @_;
#	$level			= $conf->{$level};
#	my $parent		= (caller($level->[0] + 1))[0];
#	my ($child, $file, $line, $func) = (caller($level->[1] + 1));
#	my $err_msg;
#	
#	#print "parent:[$parent] child:[$child] file:[$file] line:[$line] func:[$func]\n";
#	
#	$file =~ s/(.*?)bin\/(\w+)\.pm/$1source\/$2.dclass/gsx;
#	$func =~ s/.*::(\w+)/$1/g;
#	
#	$err_msg = "Can\'t access object \"$func\" via class \"$parent\" at $file line $line\n";
#	$err_msg = "Can\'t access class \"$parent\" at $file line $line\n" if $func eq '(eval)' or $func eq 'import';
#	
#	die $err_msg;
#}

sub __error {
	my $self		= shift;
	my $err			= shift;
	my $class		= shift;
	my $name		= shift;
	my $caller		= shift;
	
	my $err_msg		= "################################ ERROR ##################################\n";
	
	my $err_conf	= $ERROR->{$err};
	my $level		= $err_conf->[0];

	my $parent		= (caller($level->[0]))[0];
	my ($child, $file, $line, $func) = (caller($level->[1]));
	
	
	
	$file =~ s/(.*?)bin\/(\w+)\.pm/$1source\/$2.dclass/gsx;
	$func =~ s/.*::(\w+)/$1/g;
	
	$err_msg = eval $err_conf->[1];
	
	die $err_msg;
}

sub __RISE_ERR {
	my $class		= shift;
	my $err			= shift;
	my $name		= shift;
	
	my $err_conf	= $ERROR->{$err};
	my $level		= $err_conf->[0];
	my $parent		= (caller($level->[0]))[0];
	my ($child, $file, $line, $func); # = (caller($level->[1]));
	my $err_msg		= "################################ ERROR ##################################\n";
	
	#my $child;
	#my $file;
	#my $line = '';
	#my $func;
	
	($child, $file, $line, $func) = (caller($level->[1]));
	$file			=~ s/\.pm/\.class/gsx;
	$func			=~ s/.*::(\w+)$/$1/;	
	$class			=~ s/::$func$//;	
	
#	print "----------------
#	self	: $class
#	error	: $err
#	parent	: $parent
#	child	: $child
#	file	: $file
#	line	: $line
#	func	: $name
#----------------\n";	
	
	#for ( my $i = 3; $line =~ /\d+/ && $i > 0; --$i  ) {
	#	($child, $file, $line, $func) = (caller($i));
	#	$line ||= '';
	#}
	

	

	#print ">>>>>> $class - $name | ".$level->[0]." <<<<<<<\n";
	

	
	$err_msg .= eval $err_conf->[1];
	
	($child, $file, $line, $func) = (caller($level->[1] + 1));# if $child eq 'main';
	$file			=~ s/\.pm/\.class/gsx;
	$func			=~ s/.*::(\w+)$/$1/;	
	$class			=~ s/::$func$//;
	
#	print "----------------
#	self	: $class
#	error	: $err
#	parent	: $parent
#	child	: $child
#	file	: $file
#	line	: $line
#	func	: $name
#----------------\n";	
	
	$err_msg .= eval '"\nat $file line $line"' if $file && $line && $child ne 'main';
	$err_msg .= "\n#########################################################################\n\n";
	
	die $err_msg;
	#confess $err_msg;
}

sub DESTROY {}

1;

