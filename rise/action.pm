package rise::action;

use strict;
use warnings;
use v5.008;
use utf8;

no strict 'refs';
no strict 'subs';

#use Data::Dump 'dump';

use lib '../lib/rise/';

#use rise::lib::grammar qw/:simple/;

our $VERSION = '0.000';
our $conf							= {};

my $cenv 							= {};
my $this							= {};
my $PARSER							= {};
#my $parser							= new rise::lib::grammar;

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    #__init();
	return bless($conf, $class);                         					# обьявляем класс и его свойства
}

sub _syntax_commentC {
	my $self	= shift;
	my $comment = &comment_C;
	$comment =~ s/^\/\//\#/gsx;
	return $comment;
}

sub _syntax_excluding {
	my $self	= shift;
		push @{$self->var('excluding')}, &excluding;
		return '%%%TEXT_' . sprintf("%03d", $#{$self->var('excluding')}) . '%%%';
}

sub _syntax_including {
	my $self	= shift;
	my $including		= &including;
	my $res				= '';
	$including			=~ s/%%%TEXT_(\d+)%%%/$1/gsx;
	$res				= $self->var('excluding')->[$including] if $including;
	return $res;
}

#-------------------------------------------------------------------------------------< inject | using | inherits | implements
sub _syntax_inject {
	my $self	= shift;
	my $content				= &content; 
	$content 				=~ s/\<TEXT\_(\d+)\>/$self->var('excluding')->[$1]/gsxe;
	#__add_stack($1) if $content =~ m/\'(\w+(?:\.\w+)?)\'/gsx;
	return "require...${content}<endop>"
}

sub _syntax_using {
	my $self	= shift;
	#__add_stack(&name);
	return "use...<name>...<content><endop>";
}

sub _syntax_inherits {
	my $self	= shift;
	#__add_stack(&name);
	return "_<inherits>_...<name>";
}

sub _syntax_implements {
	my $self	= shift;
	#__add_stack(&name_list);
	return "_<implements>_...<name_list>";
}

#-------------------------------------------------------------------------------------< for | foreach | while
sub _syntax_prepare_foreach {
	my $self	= shift;
	my $for = '<for_each>...(...<CONDITION>...)...{ <name> = $_;<STATEMENT>}';
	$for = '{ <kw_local> <variable> <name>; '.$for.'}' if &variable;
	return $for;
}

sub _syntax_prepare_for { my $self	= shift; "{ <kw_local> <variable> <name>; <for_each>...(...<name>...<CONDITION>...)...{<STATEMENT>}}" }

sub _syntax_prepare_while { my $self	= shift; "{ <kw_local> <variable> <name>; <while>...(...<name>...<CONDITION>...)...{<STATEMENT>}}" }

#-------------------------------------------------------------------------------------< function_defs | prepare function | function
sub _syntax_function_defs { my $self	= shift; "sub <name><args_attr><endop>" }

sub _syntax_function_list {
	my $self	= shift;
	$self->var('class_func') 		.= '|' . &name;
	$self->var('class_func')		=~ s/^\|//;

	$self->token('func_all')		= $self->var('class_func')||1;
	$self->rule('_func2method')		= '<func_all>\((NOT:\_\_PACKAGE\_\_)';
	
	return "_<kw_function>_ <name>";
}

sub _syntax_function_list_post { my $self	= shift; '<kw_function>' }

sub _syntax_func2method { my $self	= shift; '<func_all>(__PACKAGE__, ' }
sub _syntax_func2method_post { my $self	= shift; '__PACKAGE__)' }

sub _syntax_prepare_function {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $function		= &function;
	my $name			= &name;
	my $args			= &code_args || '';
	#my $args_comp		= $args;
	my $attr			= &code_attr || '';
	my $block			= &block_brace; 
	my $arguments		= '';
	my $self_args		= '<kw_self>';
	
	$args				=~ s/\s//gsx;
	$block 				=~ s/\{(.*)\}/$1/gsx;


	if(!$name){
		$self->var('anon_fn_count')++;
		$name = $self->var('anon_code_pref').sprintf("%05d", $self->var('anon_fn_count'));
	}
	
	if ($args !~ m/\((\w+.*?)\)/sx) {
		$attr = $args . $attr;
		$args = '';
	}
	
	$args				=~ s/\((.*?)\)/$1/gsx;
	$self_args			.= ','.$args if $args;
	$arguments			= "<kw_local> <kw_variable> ($self_args) = \@_;";

	return "${accmod}... _<function>_ ...${name}...${attr}...{ ${arguments}${block}}";
}

sub _syntax_function {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $function		= &_function_;
	my $name			= &name;
	my $attr			= &code_attr || '';
	my $block			= &block_brace;
	my $sname			= $name;
	my $parent_name		= $name;
	my $fn_name			= $name;
	my $anon_code		= '';
	
	
	
	#$accmod				= '_'.uc($accmod).'_CODE_;';
	$accmod				= $self->var($accmod.'_code');
	$function			=~ s/\_(\w+)\_/$1/gsx;
	$sname				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	$fn_name			=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	$block 				=~ s/\{(.*)\}/$1/gsx;
	
	if($name =~ /ACODE\d+/){
		$anon_code = '\&'.$name.'::code; ' ;
		$accmod = '';
	}
	
	$accmod				= eval $accmod if $accmod ne '';
	
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	#return "$anon_code<kw_public> prepared_<kw_class> $name _extends_ $parent_name { use function; sub this { '$parent_name' } sub code $attr { $accmod $block}}";
	#return "${anon_code}{ package ${parent_name}::CODE::${fn_name}; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::function', '$parent_name'; use rise::core::object::function::function; sub this { '$parent_name' }...sub...code...${attr}...{ ${accmod}${block}}}";
	
	#return "${anon_code}{ package <name>; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::function', '$parent_name'; use rise::core::object::function::function; sub this { '$parent_name' }...sub...code...${attr}...{${accmod}${block}}}";
	#return "${anon_code}{ package <name>; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::function', '$parent_name'; use rise::core::object::function::function; sub <kw_self> { '$parent_name' }...sub...code...${attr}...{ ${accmod} ${block}}}";
	return "${anon_code}{ package <name>; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::function', '$parent_name'; use rise::core::object::function::function;...sub...code...${attr}...{ ${accmod} ${block}}}";
	#return "${anon_code}{ package <name>; my \$__caller__ = '<name>'; use strict; use warnings; use rise::core::ops::extends 'rise::core::object::function', '$parent_name'; use rise::core::object::function::function; sub this { '$parent_name' }...sub...code...${attr}...{${accmod}${block}}}";
}

sub _syntax_prepare_function_args {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $function		= &function;
	my $name			= &name;
	my $args			= &code_args || ''; 
	my $attr			= &code_attr || '';
	my $arguments		= '';

	$args				=~ s/\s//gsx;

	if ($args !~ m/\((\w+.*?)\)/sx) {
		$attr = $args . $attr;
		$args = '';
	}
	 
	$arguments				= "<kw_public> <kw_variable> <code_args> = __PACKAGE__->__class_ref(\@_);" if $args ne '';

	return "$accmod _<function>_ <name> $attr { $arguments";
}

sub _syntax_prepare_function_post {
	my $self	= shift;
	my $function 		= &_function_;
	my $tk_function 	= $self->token('function');
	$function 			=~ s/\_(\w+)\_/$1/sx;
	
	return $function;
}
#-------------------------------------------------------------------------------------< variable
sub _syntax_prepare_variable_unnamedblock {
	my $self	= shift;
	my $block			= &block_brace;
	
	my $tk_accmod		= $self->token('accessmod');
	my $tk_var			= $self->token('variable');
	my $tk_const		= $self->token('constant');
	#my $kw_var			= $self->keyword('variable');
	#my $kw_const		= $self->keyword('constant');
	
	$block 				=~ s/\b(?:$tk_accmod)?\s*($tk_var|$tk_const)/local $1/gsx;
	
	return "<unblk_pref>_UNNAMEDBLOCK_$block";
	
}

sub _syntax_prepare_variable_list {
	my $self	= shift;
	my $var_def				= &name_list;
	my $var_init			= &name_list;
	
	$var_def				=~ s/(\w+)\,?/<accessmod> <variable> $1;/gsx;
	
	return "$var_def ($var_init) ";
	
	#return "LI: ( <name_list> ) { <accessmod> <variable> _LI_; } IF: ( !'<endop>' ) {(<name_list>) <endop>}";
}

sub _syntax_var_boost1 {
	my $self	= shift;
	my $class_var			= '';
	
	$class_var				= $self->var('class_var');
	$self->var('class_var') 		.= '|' . &name if &name !~ /$class_var/;
	$self->var('class_var')		=~ s/^\|//;
	
	$self->token('var_all')			= $self->var('class_var')||1;
	$self->rule('_var_boost2')		= '(_NOT:\$)<var_all>';
	
	return "_<kw_variable>_ <name>";
}

sub _syntax_var_boost2		{ my $self	= shift; '$<var_all>' }

sub _syntax_var_boost_post1	{ my $self	= shift; '<kw_variable> ' }

sub _syntax_var_boost_post2	{ my $self	= shift; '->' }

sub _syntax_prepare_variable {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	return "$accmod _<variable><constant>_ <name>; IF: ( !'<endop>' ) {<name> <endop>}";
}

sub _syntax_variable {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $name			= &name;
	my $sname			= $name;
	my $parent_name		= $name;
	my $boost_vars		= '';
	my $or				= '';
	my $local_var		= '';
	my $end_op			= '';
	
	$name				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	$sname				= $name;
	$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;
	$accmod				= $self->var($accmod.'_var');
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	$end_op				= " \$$name<endop> " if !&endop;
	
	$boost_vars			= $self->var('class_var') || '';
	$or					= '|' if $boost_vars;
	$self->var('class_var')	.= $or . $name if $name !~ /$boost_vars/;
	
	$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	#return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<endop>' ) {<name><endop>}/;
	#return "my \$$name; $local_var { no warnings; sub $name ():lvalue { \$$name } } $end_op";
	#return "my \$$name; { no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { $accmod\$$name };}$end_op";
	return "my \$$name; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name };$end_op";
}

sub _syntax_variable_boost {
	my $self	= shift;
	my $word			= &word;
	my $sigils			= &sigils;
	my $name			= &name;
	my $regexp			= $self->var('class_var');
	$self->var('class_var')	= '';
	#$content 			=~ s/(?:(?<!(?:var|sub)\s)|(?<!\$|\*)|(?<!\-\>))\b($regexp)\b/\$$1/gsx if $regexp;
	$name 			=~ s/\b($regexp)\b/\$$1/gsx if $regexp;
	return "$word $name";
}
#-------------------------------------------------------------------------------------< constant
sub _syntax_constant {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $name			= &name;
	my $sname			= $name;
	my $parent_name		= $name;
	my $local_var		= '';
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	$name				=~ s/\w+(?:::\w+)*::(\w+)/$1/sx;
	$sname				= $name;
	$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;
	$accmod				= $self->var($accmod.'_var');
	$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	return "${local_var}sub $name () { $accmod<content> }";
}
#-------------------------------------------------------------------------------------< namespace
sub _syntax_prepare_name_namespace {
	my $self	= shift;
	#$self->var('namespace')	= &name;
	return 'public <kw_class> <name> {';
}

sub _syntax_prepare_namespace {
	my $self	= shift;
	my $name			= &name;
	my ($parent_name)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; $parent_name ||= '';
	return "<kw_public> _<kw_class>_ <name> {"
}

sub _syntax_namespace {
	my $self	= shift;
	return "{ package <name>; use strict; use warnings;"
}

#-------------------------------------------------------------------------------------< interface

sub _syntax_prepare_interface {
	my $self	= shift;
	
	my $accmod			= 'protected'; #&accessmod || $self->var('accessmod');
	my $object			= &interface;
	my $name			= &name;
	my $extends			= &content;
	#my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_constant		= $self->token('constant');
	my $tk_variable		= $self->token('variable');
	my $tk_function		= $self->token('function');
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	
	
	#$accmod				= $self->var($accmod.'_interface');
	
	#($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
	#	$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
	#	$list_extends			= "'$list_extends'" if $list_extends;
	#	$list_extends			||= '';
	#	$extends				= "use rise::core::ops::implements $list_extends;" if $list_extends;
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/'$1-<kw_constant>-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/'$1-<kw_variable>-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/'$1-<kw_function>-$2' => 1,/gsx;
	
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/__PACKAGE__->add_interface({'$1-<kw_constant>-$2' => 1});/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/__PACKAGE__->add_interface({'$1-<kw_variable>-$2' => 1});/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/__PACKAGE__->add_interface({'$1-<kw_function>-$2' => 1});/gsx;
	
	$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_constant>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_variable>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_function>-$2'); }/gsx;
	
	#$block				=~ s/my\s+\$(\w+(?:\:\:\w+)*)\;\s*\{\s*no\swarnings\;\s*sub\s+\1\s*\(\)\:lvalue\s*\{\s*\_\_PACKAGE\_\_\-\>\_\_(\w+)\_VAR\_\_\;\s*\$\1\s*\}\s*\}/'$2-variable-$1' => 1,/gsx;
		
			 
	
	return "${accmod}..._<interface>_...<name>...<content>...{$block}";
	#return "${accmod}... <kw_interface> ...<name>...<content>...{$block}";
}

sub _syntax_prepare_interface_post {my $self	= shift; '<kw_interface>'}

sub _syntax_interface {
	my $self	= shift;
	
	my $accmod			= &accessmod || $self->var('accessmod');
	#my $object			= &class_type;
	my $name			= &name;
	my $sname			= $name;
	my $extends			= &content;
	my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_constant		= $self->token('constant');
	my $tk_variable		= $self->token('variable');
	my $tk_function		= $self->token('function');
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; 
	my $parent_name		= $parent_class || 'main';
	my $base_class		= "'rise::core::object::interface'";
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	
	$accmod				= $self->var($accmod.'_interface');
	$accmod				= eval $accmod if $accmod ne '';
	
	#($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
	#	$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
	#	$list_extends			= "'$list_extends'" if $list_extends;
	#	$list_extends			||= '';
		
	$list_extends				= list_extends($extends);
	
	#$extends				= " use rise::core::ops::implements $list_extends;" if $list_extends;
	
	$extends				= "use rise::core::ops::extends $base_class$parent_class$list_extends;";
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/'$1-constant-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/'$1-variable-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/'$1-function-$2' => 1,/gsx;
	#$block				=~ s/my\s+\$(\w+(?:\:\:\w+)*)\;\s*\{\s*no\swarnings\;\s*sub\s+\1\s*\(\)\:lvalue\s*\{\s*\_\_PACKAGE\_\_\-\>\_\_(\w+)\_VAR\_\_\;\s*\$\1\s*\}\s*\}/'$2-variable-$1' => 1,/gsx;
		
			 
	
	#return "{ package <name>;...use rise::core::ops::extends 'rise::core::object::interface'$parent_class;$extends${accmod}...sub interface...{$block}}";
	return "{ package <name>; use strict; use warnings;...$extends...$accmod... __PACKAGE__->interface_join; $block}";
}

#-------------------------------------------------------------------------------------< abstract

sub _syntax_prepare_abstract {
	my $self	= shift;
	my $accmod			= 'protected'; #&accessmod || $self->var('accessmod');
	my $object			= &abstract;
	my $name			= &name;
	my $extends			= &content;
	my $block			= &block_brace;
	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_constant		= $self->token('constant');
	my $tk_variable		= $self->token('variable');
	my $tk_function		= $self->token('function');
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_constant>-$2');/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_variable>-$2');/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_function>-$2');/gsx;
	
	$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_constant>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_variable>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_function>-$2'); }/gsx;
	
	return "${accmod}..._<abstract>_...<name>...<content>...{$block}";
	#return "${accmod}...<kw_abstract>...<name>...<content>...{$block}";
}

sub _syntax_prepare_abstract_post {my $self	= shift; '<kw_abstract>'}

sub _syntax_abstract {
	my $self	= shift;
	
	my $accmod			= &accessmod || $self->var('accessmod');
	#my $object			= &class_type;
	my $name			= &name;
	my $sname			= $name;
	my $extends			= &content;
	my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_constant		= $self->token('constant');
	my $tk_variable		= $self->token('variable');
	my $tk_function		= $self->token('function');
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx;
	my $parent_name		= $parent_class || 'main';
	my $base_class		= "'rise::core::object::abstract'";
	my $comma			= '';
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	
	$accmod				= $self->var($accmod.'_abstract');
	#$accmod				= $self->var($accmod.'_class');
	$accmod				= eval $accmod if $accmod ne '';
	
	#($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
	#	$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
	#	$list_extends			= "'$list_extends'" if $list_extends;
	#	$list_extends			||= '';
	#	$comma					= ',' if $list_extends;
	#	#$extends				= " use rise::core::ops::implements $list_extends;" if $list_extends;
	$list_extends				= list_extends($extends);
		
	$extends				= "use rise::core::ops::extends $base_class$parent_class$list_extends;";
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	return "{ package <name>; use strict; use warnings;...$extends...$accmod... __PACKAGE__->interface_join; $block}";
}

#-------------------------------------------------------------------------------------< class

sub _syntax_prepare_class {
	my $self	= shift;
	my $ns				= $self->var('namespace');
	my $accmod			= &accessmod;
	my $object			= &_class_type_;
	my $name			= &name;
	my $args_attr		= &args_attr;
	my $extends			= '';
	my $kw_extends		= $self->keyword('inherits');
	my $tk_name_list	= $self->token('name_list');
	my ($parent_name)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; $parent_name ||= '';
	my $comma			= '';
	
	$comma		= ',' if $args_attr =~ s/\_$kw_extends\_\s*($tk_name_list)/$1/gsx;
	
	$extends			= 'rise::core::object::class';
	$extends			.= ", $parent_name" if $parent_name;
	$extends			.= $comma;

	$args_attr			= "_<kw_inherits>_ $extends $args_attr" if $extends;

	return "${accmod}...prepared_class...<name>...${args_attr}...{";
}

sub _syntax_object {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $object			= &_object_; $object =~ s/\_(\w+)\_/$1/sx;
	my $name			= &name;
	my $sname			= $name;
	my $args_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $base_class		= "'rise::core::object::$object'";
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx;
	my $comma			= '';
	my $parent_name		= $parent_class || 'main';
	
	$self->var('class_func')		= '';
	$self->var('class_var')		= '';
	
	return '' if !$name;
	
	$sname				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';

	#print ">>>>>> accmod - $accmod | base_class - $base_class | name - $name\n";
	
	$accmod				= $self->var($accmod.'_'.$object);
	$accmod				= eval $accmod if $accmod;

	$list_extends		= list_extends($args_attr);

	$extends			= "use rise::core::ops::extends $base_class$parent_class$list_extends;";
	
	#return "{ package <name>; use strict; use warnings;...${extends}...${accmod}...__PACKAGE__->interface_confirm; sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	return "{ package <name>; use strict; use warnings;...${extends}...${accmod}..." . __object_header($object, $name || '');
}

sub __object_header {
	my $self	= shift;
	my $obj_type		= shift;
	my $name			= shift;
	my $header			= {
		class		=> "__PACKAGE__->interface_confirm; sub super { \$<name>::ISA[1] } my \$<kw_self> = '<name>'; sub <kw_self> { \$<kw_self> } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...",
		abstract	=> "__PACKAGE__->interface_join;",
		interface	=> "__PACKAGE__->interface_join;"
	};
	return $header->{$obj_type};
}

sub _syntax_class {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	#my $object			= &_class_type_;
	my $name			= &name;
	my $sname			= $name;
	my $args_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $base_class		= "'rise::core::object::class'";
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx;
	my $comma			= '';
	my $parent_name		= $parent_class || 'main';
	
	$sname				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	#$base_class		.= ", '$parent_class'" if $parent_class;
	
	print ">>>>>> accmod - $accmod | base_class - $base_class | name - $name\n";
	
	#$accmod				= ' _'.uc($accmod).'_CLASS_;';
	$accmod				= $self->var($accmod.'_class');
	$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';
	
	#$base_class		= "'rise::core::object::class'" if &_class_type_ eq '_base_';
	
	#($list_implements)		= $args_attr =~ m/\_implements\_\s*($tk_name_list)/gsx;
	#	$list_implements		=~ s/\s*\,\s*/','/gsx if $list_implements;
	#	$list_implements		= "'$list_implements'" if $list_implements;
	#	$list_implements		||= '';
		
	#$list_implements			= list_extends($args_attr);
		
		#$implements				= " use rise::core::ops::implements  $list_implements;" if $list_implements ne '';
		#$implements				.= ' __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		#$implements				.= ' __PACKAGE__->interface_confirm;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		#$implements				.= ' __PACKAGE__->interface_confirm("'.($self->var('members')->{$name}||'').'");' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		
		#
		#$implement_list			= $interface_list;
		#$implement_list			=~ s/\,/','/gsx;
		#$implements				= "; use rise::core::ops::implements '" . $implement_list . "'" if $interface_list ne '';
		#$implements				.= '; __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST' if $interface_list ne '' && $tp eq 'class';

	#($list_extends)			= $args_attr =~ m/\_extends\_\s*($tk_name_list)/gsx;
	#	$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
	#	$list_extends			= "'$list_extends'" if $list_extends;
	#	$list_extends			||= '';
		
	$list_extends				= list_extends($args_attr);
		
		#$comma					= ',' if $list_extends;
		$extends				= "use rise::core::ops::extends $base_class$parent_class$list_extends;";
	
	#if (&_class_type_ eq '_base_' || $extends_list ne '') {
	#	$extends			= " use rise::core::ops::extends $parent_class $extends_list;";
	#}

	#$extends			.= "$parent_class$extends_list";
	#$extends			.= '; ' if $extends;
	
	#print "########## $object EXT $extends - IMPL $implements ########\n";
	
	
	
	#$extends				= "use rise::core::ops::extends '" . $parent_list . "'$class_ext";
	#$$implements			= "use rise::core::ops::implements  '"
	
	#return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' }...";
	#return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	#return "{ package <name>; ".$self->var('env')."->{caller}{parent} = '${parent_name}'; ".$self->var('env')."->{caller}{name} = __PACKAGE__; ".$self->var('env')."->{caller}{type} = 'class'; ...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	return "{ package <name>; use strict; use warnings;...${extends}...${accmod}...__PACKAGE__->interface_confirm; sub super { \$<name>::ISA[1] } sub <kw_self> { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	#return "{ package <name>; my \$__caller__ = '<name>';...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	
}

sub _syntax_class_OFF {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');;
	#my $object			= &_class_type_;
	my $name			= &name;
	my $args_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $parent_class	= '';
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	
	my $comma			= '';
	
	#$accmod				= ' _'.uc($accmod).'_CLASS_;';
	$accmod				= $self->var($accmod.'_class');
	
	#$parent_class		= "'rise::core::object::class'" if &_class_type_ eq '_base_';
	
	($list_extends)			= $args_attr =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		#$comma					= ',' if $list_extends;
		#$list_extends			= $parent_class . $comma . $list_extends;
		$extends				= " use rise::core::ops::extends $list_extends;";
		
	($list_implements)		= $args_attr =~ m/\_implements\_\s*($tk_name_list)/gsx;
		$list_implements		=~ s/\s*\,\s*/','/gsx if $list_implements;
		$list_implements		= "'$list_implements'" if $list_implements;
		$list_implements		||= '';
		
		$implements				= " use rise::core::ops::implements  $list_implements;" if $list_implements ne '';
		$implements				.= ' __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');

		
		#
		#$implement_list			= $interface_list;
		#$implement_list			=~ s/\,/','/gsx;
		#$implements				= "; use rise::core::ops::implements '" . $implement_list . "'" if $interface_list ne '';
		#$implements				.= '; __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST' if $interface_list ne '' && $tp eq 'class';

	
	#if (&_class_type_ eq '_base_' || $extends_list ne '') {
	#	$extends			= " use rise::core::ops::extends $parent_class $extends_list;";
	#}

	#$extends			.= "$parent_class$extends_list";
	#$extends			.= '; ' if $extends;
	
	#print "########## $object EXT $extends - IMPL $implements ########\n";
	
	
	
	#$extends				= "use rise::core::ops::extends '" . $parent_list . "'$class_ext";
	#$$implements			= "use rise::core::ops::implements  '"
	
	return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub <kw_self> { '<name>' } sub __CLASS_MEMBERS__ {'".($self->var('members')->{$name}||'')."'}...";
	
}




sub _syntax_prepare_class_helper {
	my $self	= shift;
	my ($name, $block) = @_;
	

	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_class		= $self->token('class');
	my $tk_name			= $self->token('name');
	my $tk_name_list	= $self->token('name_list');
	my $tk_extends		= $self->token('inherits');
	my $tk_content		= $self->token('content');
	my $tk_block		= $self->token('block_brace');
	my $extends			= keyword('inherits').' '.$name;
	
	#$self->var('anon_fn_count')++;
	

	
	#my ($chk_anon_code)	= $block =~ m/$tk_class\s*($tk_name)?\s*$tk_content?\s*$tk_block/;
	#
	#if (!$chk_anon_code) {
	#	$self->var('anon_fn_count')++;
	#	$name			= 'anon_code_'.$self->var('anon_fn_count');
	#}		
	
	$block				=~ s/\{(.*)\}/$1/gsx;
	
	$block				= "{###DIALECTCLASSHEAD###$block}";
	
	$block				=~ s/\b($tk_class)\s*($tk_name)\s*($tk_extends)?(\s*$tk_name_list)?/$1 $2 $extends/gsx;
	#$block				=~ s/($tk_class)\s*($tk_name)\s*($tk_extends)?(\s*$tk_name_list)?/$1 $2 <kw_inherits> $name/gsx;
	$block 				=~ s/\b($tk_accessmod)?\s*($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/($1||$self->var('accessmod')).' _'.$2.'_ '.$name.'::'.$3.' '.$4.' '._syntax_prepare_class_helper($name.'::'.$3, $5)/gsxe;
	#$block 				=~ s/\b(?:$tk_accessmod)?\s*($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/'_'.$1.'_ '.$name.'::'.$2.' '.$3.' '._syntax_prepare_class_helper($name.'::'.$2, $4)/gsxe;
	
	#if ($block !~ s/($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/$1.' '.$name.'::'.$2.' '.$3.' '._prepare_class_helper($name.'::'.$2, $4)/gsxe){
	#	$block			=~ s/\{(.*)\}/$1/gsx;
	#	$block			=~ s/($tk_block)/_prepare_class_helper($name, $1)/gsxe;
	#}
	
	
	
	return $block;
}
#-------------------------------------------------------------------------------------< object
sub _syntax_prepare_name_object {
	my $self	= shift;
	my $accmod			= &accessmod || $self->var('accessmod');
	my $object			= &object;
	my $name			= &name;
	my $args_attr		= &args_attr;
	my $block			= &block_brace;
	my $base			= '';
	my $kw_class		= $self->keyword('class');
	my $object_type		= $object;
	
	$object_type		= 'base' if $object eq $kw_class;

	$self->var('anon_fn_count') = 0;

	#$name				= $self->var('namespace').'::'.$name if $self->var('namespace');

	$block 				= _syntax_prepare_name_object_helper($name, $block);

	return "_object_${object_type}_ ${accmod}... _<object>_ ...<name>...<args_attr>...${block}";
}

sub _syntax_prepare_name_object_helper {
	my $self	= shift;
	my ($name, $block) = @_;

	my $accessmod;
	my $objname;
	
	my $tk_accessmod	= $self->token('accessmod');
	my $tk_object		= $self->token('object');
	my $tk_name			= $self->token('name');
	my $tk_args_attr	= $self->token('args_attr');
	my $tk_content		= $self->token('content');
	my $tk_block		= $self->token('block_brace');

	$block 				=~ s{
			\b(?<accessmod>$tk_accessmod)?
				(?<sps1>\s*)(?<object>$tk_object)
				(?<sps2>\s*)(?<name>$tk_name)?
				(?<sps3>\s*)(?<args_attr>$tk_args_attr)?
				(?<sps4>\s*)(?<block_brace>$tk_block)?
		}{
			$accessmod = $+{accessmod}||$self->var('accessmod');
			$self->var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$+{name} . ' ' if $accessmod ne 'local';
			'_object_'.$+{object}.'_ '.
				$accessmod.
				$+{sps1}.' _'.$+{object}.'_ '.
				$+{sps2}.$name.'::'.$+{name}.
				$+{sps3}.($+{args_attr}||'').
				$+{sps4}._syntax_prepare_name_object_helper($name.'::'.$+{name}, $+{block_brace}||'')
		}gsxe;
	
	#$block 				=~ s{
	#		\b(?<accessmod>$tk_accessmod)?\s*(?<object>$tk_object)\s*(?<name>$tk_name)?\s*(?<args_attr>$tk_args_attr)?\s*(?<block_brace>$tk_block)?
	#	}{
	#		$accessmod = $+{accessmod}||$self->var('accessmod');
	#		$objname=$+{name};if(!$objname){$self->var('anon_fn_count')++;$objname=$self->var('anon_code_pref').sprintf("%05d", $self->var('anon_fn_count'));}
	#		$self->var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#		$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{args_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#	}gsxe;
	
	#$block 				=~ s{
	#	\b(?<accessmod>$tk_accessmod)?\s*(?<object>$tk_object)\s*(?<name>$tk_name)?\s*(?<args_attr>$tk_args_attr)?\s*(?<block_brace>$tk_block)?
	#}{
	#	$accessmod = $+{accessmod}||$self->var('accessmod');
	#	$objname=$+{name};if($objname eq '_ANON_CODE_'){$self->var('anon_fn_count')++;$objname.=sprintf("%05d", $self->var('anon_fn_count'));}
	#	$self->var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#	$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{args_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#}gsxe;
	
	return $block;
}

sub _syntax_op_dot {my $self	= shift; '->'}

sub _syntax_optimise4 { my $self	= shift; ';' }
sub _syntax_optimise5 { my $self	= shift; ' ' }
sub _syntax_optimise6 { my $self	= shift; '' }


	#action _excluding 						=> \&{$a->_syntax_excluding};
	#
	#action _inject 							=> \&{$a->_syntax_inject};
	#action _using 							=> \&{$a->_syntax_using};
	#action _inherits			 			=> \&{$a->_syntax_inherits};
	#action _implements 						=> \&{$a->_syntax_implements};
	#
	#action _prepare_interface 				=> \&{$a->_syntax_prepare_interface};
	#action _prepare_interface_post			=> \&{$a->_syntax_prepare_interface_post};
	#action _prepare_abstract 				=> \&{$a->_syntax_prepare_abstract};
	#action _prepare_abstract_post			=> \&{$a->_syntax_prepare_abstract_post};
	#
	#action _prepare_foreach 				=> \&{$a->_syntax_prepare_foreach};
	#action _prepare_for 					=> \&{$a->_syntax_prepare_for};
	#action _prepare_while 					=> \&{$a->_syntax_prepare_while};
	#
	#action _function_defs 					=> \&{$a->_syntax_function_defs};
	#
	#action _function_list 					=> \&{$a->_syntax_function_list};
	#action _function_list_post 				=> \&{$a->_syntax_function_list_post};
	#action _func2method						=> \&{$a->_syntax_func2method};
	#action _func2method_post				=> \&{$a->_syntax_func2method_post};	
	#
	#action _prepare_function 				=> \&{$a->_syntax_prepare_function};
	#action _prepare_function_post 			=> \&{$a->_syntax_prepare_function_post};
	#
	#action _prepare_variable_list 			=> \&{$a->_syntax_prepare_variable_list};
	#
	##action _var_boost1						=> \&{$a->_syntax_var_boost1};
	##action _var_boost2						=> \&{$a->_syntax_var_boost2};
	##action _var_boost_post1					=> \&{$a->_syntax_var_boost_post1};
	##action _var_boost_post2					=> \&{$a->_syntax_var_boost_post2};
	#
	#action _prepare_variable_unnamedblock	=> \&{$a->_syntax_prepare_variable_unnamedblock};
	#
	#
	#action _prepare_name_object				=> \&{$a->_syntax_prepare_name_object};
	#
	#	#action _prepare_namespace 				=> \&{$a->_syntax_prepare_namespace};
	#	#action _prepare_class 					=> \&{$a->_syntax_prepare_class};
	#
	#	#action _function_defs 					=> \&{$a->_syntax_function_defs};
	#action _function 						=> \&{$a->_syntax_function};
	#action _variable 						=> \&{$a->_syntax_variable};
	#action _constant 						=> \&{$a->_syntax_constant};
	#
	#
	#
	#	#action _variable_boost					=> \&{$a->_syntax_variable_boost};
	#
	#action _namespace 						=> \&{$a->_syntax_namespace};
	#action _object 							=> \&{$a->_syntax_object};
	#	#action _class 							=> \&{$a->_syntax_class};
	#	#action _abstract 						=> \&{$a->_syntax_abstract};
	#	#action _interface 						=> \&{$a->_syntax_interface};
	#
	#action _op_dot							=> \&{$a->_syntax_op_dot};
	#
	#
	#
	#action _optimise4		 				=> \&{$a->_syntax_optimise4};
	#	#action _optimise5		 				=> \&{$a->_syntax_optimise5};
	#action _optimise6		 				=> \&{$a->_syntax_optimise6};
	#action _including						=> \&{$a->_syntax_including};
	#
	#action _commentC 						=> \&{$a->_syntax_commentC};


1;