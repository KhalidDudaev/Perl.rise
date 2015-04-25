package rise::object::error;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

#our $INHERIT = 0;
my $VARS		= {};
my $ERROR		= {
	class_priv				=> [ [ 1, 2 ], '"ERROR CLASS: Can\'t access class \"$parent\" at $file line $line\n"' ],
	class_priv_inherit		=> [ [ 1, 3 ], '"ERROR CLASS: Can\'t access class \"$parent\" at $file line $line\n"' ],	
	class_prot				=> [ [ 1, 2 ], '"ERROR CLASS: Class \"$parent\" only extends at $file line $line\n"' ],
	
	abstract_prot			=> [ [ 1, 2 ], '"ERROR ABSTRACT: Abstract class \"$parent\" only extends at $file line $line\n"' ],
	interface_prot			=> [ [ 1, 2 ], '"ERROR INTERFACE: Interface \"$parent\" only extends at $file line $line\n"' ],
	
	code_priv				=> [ [ 1, 2 ], '"ERROR FUNCTION: Can\'t access function \"$name\" from \"$class\" at $file line $line\n"' ],
	code_prot				=> [ [ 1, 2 ], '"ERROR FUNCTION: Function \"$name\" from \"$class\" only inheritable at $file line $line\n"' ],
	
	var_priv				=> [ [ 1, 2 ], '"ERROR VARIABLE: Can\'t access variable \"$name\" from \"$class\" at $file line $line\n"' ],
	var_prot				=> [ [ 1, 2 ], '"ERROR VARIABLE: Variable \"$name\" from \"$class\" only inheritable at $file line $line\n"' ],
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
	
	my $err_msg;
	
	my $err_conf	= $ERROR->{$err};
	my $level		= $err_conf->[0];

	my $parent		= (caller($level->[0]))[0];
	my ($child, $file, $line, $func) = (caller($level->[1]));
	
	
	
	$file =~ s/(.*?)bin\/(\w+)\.pm/$1source\/$2.dclass/gsx;
	$func =~ s/.*::(\w+)/$1/g;
	
	$err_msg = eval $err_conf->[1];
	
	die $err_msg;
}

sub _error {
	my $self		= shift;
	my $err_conf	= shift;
	my $level		= $err_conf->[0];

	#my $parent		= (caller($level->[0]))[0];
	#my ($child, $file, $line, $func) = (caller($level->[1]));
	
	my $parent		= (caller($level->[0] + 1))[0];
	my ($child, $file, $line, $func) = (caller($level->[1] + 1));
	
	my $err_msg;
	
	$file =~ s/(.*?)bin\/(\w+)\.pm/$1source\/$2.dclass/gsx;
	$func =~ s/.*::(\w+)/$1/g;
	
	$err_msg = eval $err_conf->[1];
	
	die $err_msg;
}

sub DESTROY {}

1;

