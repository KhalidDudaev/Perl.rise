package rise::core::object::error;
use strict;
use warnings;
use utf8;

use Carp;

our $VERSION = '0.01';

#our $INHERIT = 0;
my $VARS		= {};
my $ERROR		= {
	class_priv				=> [ [ 1, 2 ], '"ERROR CLASS:\nCan\'t access class \"$parent\" at\n-> line $line in $file"' ],
	class_priv_inherit		=> [ [ 1, 3 ], '"ERROR CLASS:\nCan\'t access class \"$parent\" at\n-> line $line in $file"' ],
	class_prot				=> [ [ 1, 2 ], '"ERROR CLASS:\nClass \"$parent\" only extends at\n-> line $line in $file"' ],
	class_inherits			=> [ [ 1, 1 ], '"ERROR CLASS:\nextends or implements syntaxis erorr in class \"$parent\" at"' ],

	abstract_prot			=> [ [ 1, 2 ], '"ERROR ABSTRACT:\nAbstract class \"$parent\" only extends at"' ],
	abstract_priv			=> [ [ 1, 1 ], '"ERROR ABSTRACT:\nAn abstract class \"$parent\" cannot be private at"' ],
	abstract_publ			=> [ [ 1, 1 ], '"ERROR ABSTRACT:\nAn abstract class \"$parent\" cannot be public at"' ],

	interface_prot			=> [ [ 1, 2 ], '"ERROR INTERFACE:\nInterface \"$parent\" only extends at"' ],
	interface_priv			=> [ [ 1, 1 ], '"ERROR INTERFACE:\nAn interface \"$parent\" cannot be private at"' ],
	interface_publ			=> [ [ 1, 1 ], '"ERROR INTERFACE:\nAn interface \"$parent\" cannot be public at"' ],

	INTERFACE_CONFIRM		=> [ [ 1, 1 ], '"ERROR INTERFACE:\n$msg_error"' ],

	code_priv				=> [ [ 1, 2 ], '"ERROR FUNCTION:\nCan\'t access function \"$name\" from \"$class\" at"' ],
	code_prot				=> [ [ 1, 2 ], '"ERROR FUNCTION:\nFunction \"$name\" from \"$class\" only inheritable at"' ],

	CODE_PRIVATE			=> [ [ 0, 1 ], '"ERROR FUNCTION:\nCan\'t access function \"$name\" from \"$class\" at"' ],
	CODE_PROTECTED			=> [ [ 0, 1 ], '"ERROR FUNCTION:\nFunction \"$name\" from \"$class\" only inheritable at"' ],

	var_priv				=> [ [ 1, 2 ], '"ERROR VARIABLE:\nCan\'t access variable \"$name\" from \"$class\" at"' ],
	var_prot				=> [ [ 1, 2 ], '"ERROR VARIABLE:\nVariable \"$name\" from \"$class\" only inheritable at"' ],

	VAR_PRIVATE				=> [ [ 0, 1 ], '"ERROR VARIABLE:\nCan\'t access variable \"$name\" from \"$class\" at"' ],
	VAR_PROTECTED			=> [ [ 0, 1 ], '"ERROR VARIABLE:\nVariable \"$name\" from \"$class\" only inheritable at"' ],

	VAR_CAST				=> [ [ 1, 2 ], '"ERROR TYPE:\nYou can only assign a value type \"$name\" at"' ],
	VAR_CAST_UNDEFINE		=> [ [ 1, 2 ], '"ERROR TYPE:\nUndefine value type \"$name\" at"' ],


	PRIVATE					=> [ [ 0, 1 ], '"ERROR ACCESS:\nCan\'t access function \"$name\" from \"$class\" at"' ],
	PROTECTED				=> [ [ 0, 1 ], '"ERROR ACCESS:\nFunction \"$name\" from \"$class\" only inheritable at"' ],

	# ARRAY_HASH				=> [ [ 0, 1 ], '"ERROR ARRAY OR HASH:\nNot ARRAY value \"$name\" at"' ],
	ARRAY_HASH				=> [ [ 0, 1 ], '"ERROR ARRAY OR HASH OP: \"$name\"\nNot ARRAY or HASH value or error expression at"' ],
	SCALAR					=> [ [ 0, 1 ], '"ERROR SCALAR OP: \"$name\"\nNot SCALAR value or error expression at"' ],
	PRINT					=> [ [ 0, 1 ], '"ERROR PRINT OP: Use of uninitialized value print at"' ],


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

sub __RISE_ERR { die __RISE_ERRWARN(shift, 'ERROR', @_) }
sub __RISE_WARN { warn __RISE_ERRWARN(shift, 'WARNING', @_) }

sub __RISE_ERRWARN {
	my $class		= shift;
    my $msgtitle    = shift;
	my $err			= shift;
	my $name		= shift;

	my $err_conf	= $ERROR->{$err};
	my $level		= $err_conf->[0];
	my $level_count	= 1;
	my $parent		= (caller($level->[0]))[0];
	my ($child, $file, $line, $func); # = (caller($level->[1]));
	# my $fext		= $class->{source}{fext};
	my $fext		= 'puma'; #$class->{source}{fext};
	my $err_msg		= "################################## $msgtitle #####################################\n";


	($child, $file, $line, $func) = (caller($level->[1]));
	($class, $file, $func) = __err_filter($class, $file, $func, $fext);
	$err_msg .= eval $err_conf->[1];

    print "parent:[$parent] child:[$child] file:[$file] line:[$line] func:[$func]\n";

	while ($file && $line && $child ne 'main') {
		$err_msg .= eval '"\n-> line $line in $file"';
		($child, $file, $line, $func) = (caller($level->[1] + $level_count));# if $child eq 'main';
		($class, $file, $func) = __err_filter($class, $file, $func, $fext);
		# $err_msg .= eval '"\n-> line $line in $file"' if $file && $line && $child ne 'main';
		$level_count++;
	}

	$err_msg .= "\n##############################################################################\n\n";

	return $err_msg;
	#confess $err_msg;
}

sub __err_filter {
	my ($class, $file, $func, $fext) = @_;
	$file			=~ s/\.pm/\.$fext/gsx;
	$file			=~ s/.*?(\/\w+\/\w+\/\w+\.\w+)$/..$1/gsx;
	$func			=~ s/.*::(\w+)$/$1/;
	$class			=~ s/::$func$//;
	return ($class, $file, $func);
}

sub DESTROY {}

1;
