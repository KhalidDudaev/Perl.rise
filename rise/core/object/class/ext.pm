package rise::core::object::class::ext;
use strict;
use warnings;
use utf8;

use parent 'rise::core::object::object', 'rise::core::object::variable';

use feature 'say';
use Data::Dump 'dump';

#use autobox::Core;

our $VERSION 	= '0.01';

our $ENV_CLASS		= {
	this_class		=> 'rise::core::object::class::ext',
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA',
    args            => []
};

# our $__VARS__           = {};

my @ARGS_CLASS;
my $self_current = {};
# my $ARGS_CLASS      = [];

# sub __set_args {
#     my $self        = shift;
#     $ARGS_CLASS     = [@_];
# }
#
# sub __get_args { $ARGS_CLASS }


sub __objtype {'CLASS'};
# sub self_current ():lvalue { $self_current->{+shift} };

# sub new {
#   my $class         = ref $_[0] || $_[0];                                     # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   return bless {}, $class;                                       				# обьявляем класс и его свойства
# }

sub new {
    my $class         = shift;
    $class            = ref $class || $class;                                   # получаем имя класса, если передана ссылка то извлекаем имя класса
    my $caller              = caller(0);
    my $self = bless {}, $class;
    # my $accmod      = '';
    # my ($parent)			= $caller =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

    # $parent ||= 'main';
                                                    # обьявляем класс и его свойства

    # __PACKAGE__->__RISE_ERR('VAR_PRIVATE', 'v2') unless (caller eq 'Imp' || caller =~ m/^Imp\b/o);
    $self->__CLASS_ARGS__(@_) if exists &{$class.'::__CLASS_ARGS__'};          # получаем аргументы класса

    # print "### $class - $caller ###\n";

    map { no strict; no warnings;
        my ($m_accmod, $m_type, $m_name, $m_cast, $m_cast_args)	= $_ =~ m/(\w+)\-(\w+)\-(\w+)(?:\s*\:\s*(\w+)(?:\((.*?)\))?)?/;
        # print "### $m_accmod - $m_type - $m_name ###\n";
        # $accmod = __accessmod($self, 'var_'.$m_accmod, $parent, $m_name);
        __PACKAGE__->__RISE_CAST($m_cast, \$self->{$m_name}, $m_cast_args) if $m_cast;
        $self->{$m_name} = $self->__CLASS_SELF__->{$m_name} if $m_name &&  exists &{$class.'::__CLASS_SELF__'};

        *{$class.'::'.$m_name} = *{$class.'::__'.$m_name.'__'} if $m_type eq 'var';

        # *{$class.'::'.$m_name} = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PRIVATE', $m_name) unless (caller eq $class || caller =~ m/^$class\b/o); my $self = shift; $self->{$m_name} } if $m_type eq 'var' && $m_accmod eq 'private';
        # *{$class.'::'.$m_name} = sub ():lvalue { __PACKAGE__->__RISE_ERR('VAR_PROTECTED', $m_name) unless caller->isa($class); my $self = shift; $self->{$m_name} } if $m_type eq 'var' && $m_accmod eq 'protected';
        # *{$class.'::'.$m_name} = sub ():lvalue { my $self = shift; $self->{$m_name} } if $m_type eq 'var' && $m_accmod eq 'public';
    } split(/\s+/, $self->__CLASS_MEMBERS__) if exists &{$class.'::__CLASS_MEMBERS__'};

    # $self->__CLASS_SELF__ = $self if exists &{$class.'::__CLASS_SELF__'};

    # $self->{'SELF'} = $self;
    # $self->self_current = $self;
    # { no strict 'refs'; ${$class.'::__CLASS_SELF__'} = $self; }

    # $self->__CLASS_CODE__ if exists &{$class.'::__CLASS_CODE__'};
    # $self->__CLASS_SELF__ if exists &{$class.'::__CLASS_SELF__'};
    # $self->{'SELF'} = $self;

    return $self;
}

# sub new {
#     my $class         = shift;
#     $class            = ref $class || $class;                                   # получаем имя класса, если передана ссылка то извлекаем имя класса
#     $class->__CLASS_ARGS__(@_) if exists &{$class.'::__CLASS_ARGS__'};          # получаем аргументы класса
#     return bless {}, $class;                                       				# обьявляем класс и его свойства
# }

# sub __bind_args {
#     my $self        = shift;
#     my @args        = @_;
#     # @args           = @$ARGS_CLASS;
#     # @args           = (\$ARGS_CLASS[0], \$ARGS_CLASS[1]);
#     @ARGS_CLASS     = @args;
#     # return (\$ARGS_CLASS[0], \$ARGS_CLASS[1]);
# }
# sub new {
#   my $class         = shift;
#   my $obj;
#   $class            = ref $class || $class;                                     # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   (${$ARGS_CLASS[0]}, ${$ARGS_CLASS[1]})       = @_;
#   # $class->__get_args(@_);
#   # print @_ if @_;
#   $obj = bless {}, $class;                                       				# обьявляем класс и его свойства
#   # $obj->__set_args(@_);
#   # print @$ARGS_CLASS;
#   return $obj;
# }

# sub new {
#   my $class         = ref $_[0] || $_[0];                                     # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   my $object        = $_[1] || {};                                            # получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#   %$object          = (%$ENV_CLASS, %$object);                                # применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
#   return bless($object, $class);                                       		# обьявляем класс и его свойства
# }

# sub new {
# 	my $class			= ref $_[0]	|| $_[0];
# 	my $args			= $_[1]		|| {};
# 	%$args				= (%$ENV_CLASS, %$args);
# 	return bless $args, $class;
# }

sub import { no strict "refs";
	my $caller              = (caller(0))[0];
	my $self                = shift;

	# say '--------- classext ---------';
	# say "caller -> $caller";
	# say "self   -> $self";

    # print "### $caller - $self ###\n";

    # *{$self."::__VARS__"} = $__VARS__;

    # $self = bless {}, $self;
    # my $class_self = ${$self.'::__CLASS_SELF__'};

    # map { no strict; no warnings;
    #     my ($m_accmod, $m_type, $m_name, $m_cast, $m_cast_args)	= $_ =~ m/(\w+)\-(\w+)\-(\w+)(?:\s*\:\s*(\w+)(?:\((.*?)\))?)?/;
    #     __PACKAGE__->__RISE_CAST($m_cast, \&{$self.'::__CLASS_SELF__'}->{$m_name}, $m_cast_args) if $m_cast;
    # } split(/\s+/, $self->__CLASS_MEMBERS__) if exists &{$self.'::__CLASS_MEMBERS__'};

	if (exists &{$self."::__CLASS_MEMBERS__"}){
		$self->interface_confirm;
		# $self->interface_confirm($self->__CLASS_MEMBERS__);
	}

	if (exists &{$self."::__EXPORT__"}){
		if (scalar @_ == 0) {
			$self->export(&{$self."::__EXPORT__"}->{':import'});
		}

		if ($_[0] && $_[0] ne ':noimport') {
			for (@_){
                # *{$self."::IMPORT::".$_} =
				$self->export(&{$self."::__EXPORT__"}->{$_});
			}
		}
	}

	# __IMPORT__($caller, @_) if exists &__IMPORT__;
}

# sub self { args('self', @_) }
# sub args {
# 	my $index				= shift;
# 	my @args				= @_;
# 	return $args[0] if $index eq 'self';
# 	return $args[$index + 1];
# }

sub export { no strict "refs"; no warnings;
	# my $__PARENT_CLASS__	= (caller(0))[0];
	my $__CALLER_CLASS__	= (caller(1))[0];
	my $self                = shift;
	my $exports				= shift;

    # say '--------- classext ---------';
    # # say "parent -> $__PARENT_CLASS__";
    # say "caller -> $__CALLER_CLASS__";
    # say "self   -> $self";

	foreach my $func (@$exports){
		# *{$__CALLER_CLASS__ . "::$_"} = \&{"$self::$_"};
		# *{$__CALLER_CLASS__ . "::IMPORT::$_"} = \&{"$self::$_"};
        # *{$__CALLER_CLASS__ . "::".$func}         = sub {&{$__PARENT_CLASS__."::IMPORT::".$_}($self, @_)};
		*{$__CALLER_CLASS__ . "::$func"}          = sub { &{"$self::$func"}($self, @_) };
		*{$__CALLER_CLASS__ . "::IMPORT::$func"}  = sub { &{"$self::$func"}($self, @_) };
	}
}

sub interface_confirm {
	no strict 'refs';
	no warnings;
	my $caller				= caller(1);
	my $self				= shift;
	my $memberlist			= $self->__CLASS_MEMBERS__;
	my $interfacelist		= \%{$self.'::INTERFACE'};
	my @objnames 			= keys %$interfacelist;
	my $obj_name;
	my $obj_type;
	my $obj_accmod;
	my $msg_error			= '';

	# say '--------- iface confirm ---------';
	# say "caller -> $caller";
	# say "self   -> $self";
	# say "memb   -> $memberlist";
	# say "ilist  -> " . dump \%{$self.'::INTERFACE'};
	# say "objects-> " . dump @objnames;

	$memberlist				||= '';

	foreach my $object (@objnames) {
		($obj_accmod, $obj_type, $obj_name) = $object =~ m/(\w+)-(\w+)-(\w+(?:\:\:\w+)*)/;
		$msg_error .= "INTERFACE ERROR: Not created $obj_accmod $obj_type \"$obj_name\" in class \"$self\"\n" if ($memberlist!~ m/\b$object\b/);
	}

	if ($msg_error ne '') {
		$msg_error			= "################################ ERROR ##################################\n"
			.$msg_error
			."#########################################################################\n\n";
		die $msg_error;
	}
	1;
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

	$starter eq 'RUN' || $self->__RISE_ERR($access);
}

sub protected_class {
	my ($self)			= @_;
	my $callercode		= (caller(2))[3]; $callercode		=~ s/.*::(\w+)/$1/;
	my $callercode_eval	= (caller(3))[3]; $callercode_eval	=~ s/.*::(\w+)/$1/;

	#print ">>>>>>>>>>>>> $callercode\n";

	($callercode eq 'import' || $callercode_eval eq 'import') || $self->__RISE_ERR('class_prot');
}

sub public_class {}

sub extends_error {
	shift->__RISE_ERR('class_inherits');
}

sub __accessmod {
	my ($self, $accmod, $parent_class, $name)			= @_;
	return '' if !$self->{debug};
	my %access = (

		code_private	=> '__PACKAGE__->__RISE_ERR(\'CODE_PRIVATE\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);',
		code_protected	=> '__PACKAGE__->__RISE_ERR(\'CODE_PROTECTED\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');',
		code_public		=> '',

		var_private		=> '__PACKAGE__->__RISE_ERR(\'VAR_PRIVATE\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);',
		var_protected	=> '__PACKAGE__->__RISE_ERR(\'VAR_PROTECTED\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');',
		var_public		=> '',
		var_local		=> '',
	);

	return $access{$accmod};
}

sub DESTROY {}

1;
