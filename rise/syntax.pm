package rise::syntax;

use strict;
use warnings;
use v5.008;
use utf8;

use lib qw |
../
../lib/
../lib/Seven/
|;

use rise::grammar qw/:simple/;

our $VERSION = '0.000';
our $conf							= {};

my $cenv 							= {};
my $this							= {};
my $PARSER							= {};
#my $parser							= new rise::grammar;

sub new {
    my ($param, $class, $this)	= ($conf, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$this						= (%$param, %$this);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $this                   	= bless($this, $class);                         # обьявляем класс и его свойства
	return $this;
}

var('app_stack')				= [];
#var('parse_token_sign')			= '-';
var('accessmod')				= 'private';
#var('command_inherit')			= 'use parents';
#var('text')						= [];
#var('namespace')				= '';
#var('class')					= '';
#var('function')					= '';
var('anon_fn_count')			= 0;
var('anon_code_pref')			= 'ACODE';
#var('class_blocknum')			= undef;
var('members')					= {};
var('BOOST_VARS')				= '';
var('members_export')			= {};

var('private_class')			= '';
var('protected_class')			= '';
var('public_class')				= '';

var('private_abstract')			= '';
var('protected_abstract')		= '';
var('public_abstract')			= '';

var('private_interface')		= '';
var('protected_interface')		= '';
var('public_interface')			= '';

var('private_var')				= q/((ref $_[0] || $_[0]) || __PACKAGE__) eq __PACKAGE__ || __PACKAGE__->__error('var_priv');/;
var('protected_var')			= q/((ref $_[0] || $_[0]) || __PACKAGE__) !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('var_prot');/;
#var('protected_var')	= q/shift !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('var_prot');/;
#tvar('protected_var')	= q/__PACKAGE__->__error('var_prot') if (($_[0] || __PACKAGE__) ne __PACKAGE__ and (($_[0] || __PACKAGE__) ne $__class)); /;
var('public_var')				= '';
	
var('private_code')				= q/((ref $_[0] || $_[0]) || __PACKAGE__) eq __PACKAGE__ || __PACKAGE__->__error('code_priv');/;
var('protected_code')			= q/((ref $_[0] || $_[0]) || __PACKAGE__) !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('code_prot');/;
#var('protected_code')	= q/shift !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('code_prot');/;
#var('protected_var')	= q/__PACKAGE__->__error('code_prot') if (($_[0] || __PACKAGE__) ne __PACKAGE__ and (($_[0] || __PACKAGE__) ne $__class)); /;
var('public_code')				= '';

keyword namespace				=> 'namespace';
keyword class					=> 'class';
keyword abstract				=> 'abstract';
keyword interface				=> 'interface';
keyword import					=> 'using';
keyword inherits				=> 'extends';
keyword implements				=> 'implements';
keyword inject					=> 'inject';
keyword function				=> 'function';
keyword method					=> 'method';
keyword fmethod					=> 'fmethod';
keyword variable				=> 'var';
keyword constant				=> 'const';
keyword private					=> 'private';
keyword protected				=> 'protected';
keyword public					=> 'public';
keyword local					=> 'local';

keyword for						=> 'for';
keyword foreach					=> 'foreach';

################################################## rules ####################################################

token namespace					=> keyword 'namespace';
token class						=> keyword 'class';
token abstract					=> keyword 'abstract';
token interface					=> keyword 'interface';
token inject					=> keyword 'inject';
token import					=> keyword 'import';
token inherits					=> keyword 'inherits';
token implements				=> keyword 'implements';
token function					=> keyword 'function';
token method					=> keyword 'method';
token fmethod					=> keyword 'fmethod';
token variable					=> keyword 'variable';
token constant					=> keyword 'constant';
token private					=> keyword 'private';
token protected					=> keyword 'protected';
token public					=> keyword 'public';
token local						=> keyword 'local';
token for						=> keyword 'for';
token foreach					=> keyword 'foreach';

token '"'						=> '\"';
token comma						=> q/\,/;

token before					=> q/^all/;
token after						=> q/all$/;
#token content					=> q/string+/;
token content					=> q/all?/;

token string					=> q/(?^s:.(?^:all))/;

token ident						=> q/letter*/;
token word						=> q/letter+/;
token number					=> q/digit+/;
#token letter					=> q/(?!nletter+|digit+)?\w/;
token letter					=> q/[^\W\d]\w/;
token digit						=> q/\d/;
token nletter					=> q/\W/;
token all						=> q/.*/;
#token all						=> q/string*/;
token sps						=> q/\s*/;


token nnline					=> q/[^\r\n]/;
token nline						=> q/[\r\n]/;
token endop						=> q/\;/;
token name						=> q/word(?:\:\:word)*/;
token name_list					=> q/name(?:\s*\,\s*name)*/;
token namestrong				=> q/[^\d\W][\w:]+[^\W]/;
token name_ext					=> q/name/;
token name_impl					=> q/name_list/;

#token comment					=> q/[#][^\n]*/;
token comment					=> q/(?<![$@%])[#] nnline*/;
#token comment					=> q/(?<![$@%])\#string/;
#token comment					=> q/(?<![$@%])\#string\n/;
#token comment2					=> q/(?<![\$\@\%])\#.*?\n/;


token for_each					=> q/foreach|for/;

token accessmod					=> q/local|private|protected|public/;
token class_type				=> q/namespace|class|abstract|interface/;
token code_type					=> q/function|method|fmethod/;
token name_ops					=> q/class_type|code_type|variable|import|inherits|implements|new/;
token object					=> q/(?<!\S)(?:class_type|code_type|variable|constant)(?!\S)/;

token _object_type_				=> q/\b_object_ word _\b/;
token _namespace_				=> q/_namespace_/;
token _base_					=> q/_base_/;
token _class_					=> q/_class_/;
token _interface_				=> q/_interface_/;
token _abstract_				=> q/_abstract_/;
token _class_type_				=> q/_namespace_|_base_|_class_|_abstract_|_interface_/;
token _code_type_				=> q/_function_|_method_|_fmethod_/;
token _var_						=> q/_var_/;
token _const_					=> q/_const_/;

token obj_type					=> q/OBJECT \_ (?:code_type)/;
token type_all					=> q/class_type|code_type/;
token class_attr				=> q/\s*content\s*/;
token namespace_attr			=> q/class_attr/;
token code_attr					=> q/(?:\(\W+\))?\:\s*content\s*/;
token code_args					=> q/\(content\)/;
token agrs_attr					=> q/(?:[^{};](?!object|accessmod))*/;
token list						=> q/\(content\)/;
token inherit_list				=> q/inherits/;
token implement_list			=> q/implements/;

token excluding					=> q/POD|DATA|END|comment|text/;
token including					=> q/%%%TEXT_ number %%%/;

token EOP 						=> q/(?:\n\n|\Z)/;
token CUT 						=> q/(?:\n=cut.*EOP)/;
token POD 						=> q/(?:^=(?:head[1-4]|item).*?CUT|^=pod.*?CUT|^=for.*?CUT|^=begin.*?CUT)/;
token DATA 						=> q/(?:^__DATA__\r?\n.*)/;
token END 						=> q/(?:^__END__\r?\n.*)/;

token text						=> q/(?:qtext|textqq|textqw)/;
#token textqq					=> q/(?:''|'content[^\\\]')/;
#token textqw					=> q/(?:""|"content[^\\\]")/;
token textqq					=> q/(?:\'content[^\\\']?\')/;
token textqw					=> q/(?:\"content[^\\\"]?\")/;
token qtext 					=> q/qtext_paren|qtext_brace|qtext_square|qtext_angle|qtext_slash|qtext_char/;
token qtext_paren				=> q/(?:q[qwr]?\s*\(content[^\\\)]\))/;
token qtext_brace				=> q/(?:q[qwr]?\s*\{content[^\\\}]\})/;
token qtext_square				=> q/(?:q[qwr]?\s*\[content[^\\\]]\])/;
token qtext_angle				=> q/(?:q[qwr]?\s*\<content[^\\\>]\>)/;
token qtext_slash				=> q/(?:q[qwr]?\s*\/content[^\\\/]\/)/;
token qtext_char				=> q/(?:q[qwr]?\s*(?<qchar>[\W\w])content(?!\\\&qchar)&qchar)/;

token block_paren				=> q/(?<BLOCK_PAREN>\((?>[^\(\)]+|(?&BLOCK_PAREN))*\))/; # (...)
token block_brace				=> q/(?<BLOCK_BRACE>\{(?>[^\{\}]+|(?&BLOCK_BRACE))*\})/; # {...}
token block_square				=> q/(?<BLOCK_SQUARE>\[(?>[^\[\]]+|(?&BLOCK_SQUARE))*\])/; # [...]
token block_angle				=> q/(?<BLOCK_ANGLE>\<(?>[^\<\>]+|(?&BLOCK_ANGLE))*\>)/; # <...>
token block_slash				=> q/(?<BLOCK_SLASH>\/(?>[^\/]+|(?&BLOCK_SLASH))*\/)/; # /.../


token unblk_pref				=> q/[\}\;]\s*/;

token brackets_brace			=> q/(?:\{(?!\s)|(?<!\s)\})/;

token CONDITION					=> q/content/;
token STATEMENT					=> q/content/;
token THEN						=> q/content/;
token ELSE						=> q/content/;

token op_dot					=> q/(?<![\s\W])\.(?![\s\d\.])/;
#token op_dot					=> q/(?:[^\s])\.(?:[^\s\d\.])/;

################################################## rules ####################################################

rule _excluding							=> q/<excluding>/;

rule _inject							=> q/<inject> <content> <endop>/;
rule _using								=> q/<import> <name>[<content>]<endop>/;
rule _inherits							=> q/<inherits> <name>/;
rule _implements						=> q/<implements> <name_list>/;

#rule _inherits_implements				=> q/<class> <name> (<inherits>|<implements>) <name_ext> [<implements> <name_impl>]/;
rule _prepare_interface					=> q/[<accessmod>] <interface> <name> [<content>] <block_brace>/;
rule _prepare_interface_post			=> q/<_interface_>/;

rule _prepare_abstract					=> q/[<accessmod>] <abstract> <name> [<content>] <block_brace>/;
rule _prepare_abstract_post				=> q/<_abstract_>/;

rule _prepare_foreach					=> q/<for_each> [<variable>] <name> \(<CONDITION>\) \{<STATEMENT>\}/;
rule _prepare_for						=> q/<for_each> \( <variable> <name> <CONDITION>\) \{<STATEMENT>\}/;
rule _prepare_variable_list				=> q/[<accessmod>] <variable> \( <name_list> \) [<endop>]/;
rule _prepare_variable_unnamedblock		=> q/<unblk_pref><block_brace>/;
rule _prepare_variable 					=> q/[<accessmod>] <variable> <name> [<endop>]/;

rule _function_defs 					=> q/[<accessmod>] <code_type> <name> <string> <endop>/;
rule _prepare_function 					=> q/[<accessmod>] <code_type> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
rule _prepare_function_post				=> q/<_code_type_>/;

rule _prepare_name_namespace			=> q/<namespace> <name> \{/;
rule _prepare_name_object				=> q/[<accessmod>] <object> [<name>] [<agrs_attr>] [<block_brace>]/;

rule _prepare_namespace					=> q/[<accessmod>] <_namespace_> <name> \{/;
#rule _prepare_class						=> q/[<accessmod>] <_class_> <name> [<agrs_attr>] \{/;

#rule _function_defs 					=> q/[<_object_type_>] [<accessmod>] <_code_type_> <name> [<string>] <endop>/;
rule _function 							=> q/[<_object_type_>] [<accessmod>] <_code_type_> <name> [<code_attr>] <block_brace>/;
rule _variable							=> q/[<_object_type_>] [<accessmod>] <_var_> <name> [<endop>]/;
rule _constant							=> q/[<_object_type_>] [<accessmod>] <_const_> <name> = <content> <endop>/;

rule _variable_boost					=> q/<all>/;

rule _abstract							=> q/[<_object_type_>] [<accessmod>] <_abstract_> <name> [<content>] <block_brace>/;
rule _interface							=> q/[<_object_type_>] [<accessmod>] <_interface_> <name> [<content>] <block_brace>/;

rule _namespace							=> q/[<_object_type_>] [<accessmod>] <_namespace_> <name> \{/;
#rule _class								=> q/[<_object_type_>] [<accessmod>] prepared_class <name> [<content>] \{/;
rule _class								=> q/[<_object_type_>] [<accessmod>] <_class_> <name> [<content>] \{/;

rule _op_dot							=> q/op_dot/;

rule _including							=> q/<including>/;

rule _optimise4 						=> q/\s+\;/;
rule _optimise5 						=> q/\s\s+/;
rule _optimise6 						=> q/\_UNNAMEDBLOCK\_/;
############################# post rules ########################################
rule _parser_list_iter					=> q/LI: \( <name_list> \) \{ <content> \}/;
rule _parser_if							=> q/IF: \( [<CONDITION>] \) \{<THEN>\}[ ELSE: \{<ELSE>\} ]/;


############################# actions ########################################


action _excluding 						=> \&_syntax_excluding;

action _inject 							=> \&_syntax_inject;
action _using 							=> \&_syntax_using;
action _inherits			 			=> \&_syntax_inherits;
action _implements 						=> \&_syntax_implements;

action _prepare_interface 				=> \&_syntax_prepare_interface;
action _prepare_interface_post			=> \&_syntax_prepare_interface_post;
action _prepare_abstract 				=> \&_syntax_prepare_abstract;
action _prepare_abstract_post			=> \&_syntax_prepare_abstract_post;

action _prepare_foreach 				=> \&_syntax_prepare_foreach;
action _prepare_for 					=> \&_syntax_prepare_for;

action _function_defs 					=> \&_syntax_function_defs;
action _prepare_function 				=> \&_syntax_prepare_function;
action _prepare_function_post 			=> \&_syntax_prepare_function_post;

action _prepare_variable_list 			=> \&_syntax_prepare_variable_list;
action _prepare_variable_unnamedblock	=> \&_syntax_prepare_variable_unnamedblock;


action _prepare_name_object				=> \&_syntax_prepare_name_object;

#action _prepare_namespace 				=> \&_syntax_prepare_namespace;
#action _prepare_class 					=> \&_syntax_prepare_class;

#action _function_defs 					=> \&_syntax_function_defs;
action _function 						=> \&_syntax_function;
action _variable 						=> \&_syntax_variable;
action _constant 						=> \&_syntax_constant;

#action _variable_boost					=> \&_syntax_variable_boost;

action _namespace 						=> \&_syntax_namespace;
action _class 							=> \&_syntax_class;
action _abstract 						=> \&_syntax_abstract;
action _interface 						=> \&_syntax_interface;

action _op_dot							=> \&_syntax_op_dot;

action _optimise4		 				=> \&_syntax_optimise4;
#action _optimise5		 				=> \&_syntax_optimise5;
action _optimise6		 				=> \&_syntax_optimise6;
action _including						=> \&_syntax_including;



#$parser->grammar = grammar;

sub syntax { grammar }
#sub parser { $parser }

#######################################################################################
#sub parse_parser_qr {'(?^<word>:<content>)'}

sub __add_stack {
	my $class_list			= shift; $class_list =~ s/\s+//gsx;
	my $apppath				= $class_list; $apppath	=~ s/\:\:/\//gsx;
	push @{var('app_stack')}, (split /\,/, $apppath) if $class_list;
	return 1;
}

sub parse_parser_list_iter {
	my $list 		= &name_list;
	my $name		= &tk_name;

	my ($before, $after) = &content =~ m/(.*)_LI_(.*)/;
	$list =~ s/($name)\,?/$before.$1.$after/gsxe;
	
	#$list = parse_parser_if($list);

	return $list;
}

sub parse_parser_if {
	my $res = '';

	if ( eval &CONDITION ) {
		$res = &THEN;
	} else {
		$res = &ELSE;
	};
	
	#$res = parse_parser_list_iter($res);
	
	return $res;
}
#######################################################################################
#-------------------------------------------------------------------------------------< excluding_ON
sub _syntax_excluding { 
		push @{&var('excluding')}, &excluding;
		return '%%%TEXT_' . sprintf("%03d", $#{&var('excluding')}) . '%%%';
}

sub _syntax_including {
	my $including		= &including;
	my $res				= '';
	$including			=~ s/%%%TEXT_(\d+)%%%/$1/gsx;
	$res				= var('excluding')->[$including] if $including;
	return $res;
}

#-------------------------------------------------------------------------------------< inject | using | inherits | implements
sub _syntax_inject {
	my $content				= &content; 
	$content 				=~ s/\<TEXT\_(\d+)\>/var('excluding')->[$1]/gsxe;
	__add_stack($1) if $content =~ m/\'(\w+(?:\.\w+)?)\'/gsx;
	return "require...${content}<endop>"
}

sub _syntax_using {  	
	__add_stack(&name);
	return "use...<name>...<content><endop>";
}

sub _syntax_inherits {
	__add_stack(&name);
	return "_<inherits>_...<name>";
}

sub _syntax_implements {
	__add_stack(&name_list);
	return "_<implements>_...<name_list>";
}

#-------------------------------------------------------------------------------------< for | foreach
sub _syntax_prepare_foreach {
	my $for = '<for_each>...(...<CONDITION>...)...{ <name> = $_;<STATEMENT>}';
	$for = '{ <kw_local> <variable> <name>; '.$for.'}' if &variable;
	return $for;
}

sub _syntax_prepare_for { "{ <kw_local> <variable> <name>; <for_each>...(...<name>...<CONDITION>...)...{<STATEMENT>}}" }

#-------------------------------------------------------------------------------------< function_defs | prepare function | function
sub _syntax_function_defs { "sub <name><string><endop>" }

sub _syntax_prepare_function { 
	my $accmod			= &accessmod || var('accessmod');
	my $code_type		= &code_type;
	my $name			= &name;
	my $args			= &code_args || ''; 
	my $attr			= &code_attr || '';
	my $block			= &block_brace; 
	my $arguments		= '';

	if(!$name){
		var('anon_fn_count')++;
		$name = var('anon_code_pref').sprintf("%05d", var('anon_fn_count'));
	}

	$args				=~ s/\s//gsx;
	$block 				=~ s/\{(.*)\}/$1/gsx;

	if ($args !~ m/\((\w+.*?)\)/sx) {
		$attr = $args . $attr;
		$args = '';
	}

	$arguments				= "<kw_public> <kw_variable> <code_args> = __PACKAGE__->__class_ref(\@_);" if $args ne '';

	return "${accmod}... _<code_type>_ ...${name}...${attr}...{ ${arguments}${block}}";
}

sub _syntax_function { 
	my $accmod			= &accessmod || var('accessmod');
	my $code_type		= &_code_type_;
	my $name			= &name;
	my $attr			= &code_attr || '';
	my $block			= &block_brace;
	my $parent_name		= $name;
	my $anon_code		= '';
	
	
	#$accmod				= '_'.uc($accmod).'_CODE_;';
	$accmod				= var($accmod.'_code');
	$code_type			=~ s/\_(\w+)\_/$1/gsx;
	$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	$block 				=~ s/\{(.*)\}/$1/gsx;
	
	if($name =~ /ACODE\d+/){
		$anon_code = '\&'.$name.'::code; ' ;
		$accmod = '';
	}

	#return "$anon_code<kw_public> prepared_<kw_class> $name _extends_ $parent_name { use function; sub this { '$parent_name' } sub code $attr { $accmod $block}}";
	return "${anon_code}{ package <name>; use strict; use warnings; use rise::core::extends 'rise::object::function', '$parent_name'; use rise::core::function; sub this { '$parent_name' }...sub...code...${attr}...{ ${accmod}${block}}}";
}

sub _syntax_prepare_function_args {
	my $accmod			= &accessmod || var('accessmod');
	my $code_type		= &code_type;
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

	return "$accmod _<code_type>_ <name> $attr { $arguments";
}

sub _syntax_prepare_function_post {
	my $code_type 		= &_code_type_;
	my $tk_code_type 	= token 'code_type';
	$code_type 			=~ s/\_(\w+)\_/$1/sx;
	
	return $code_type;
}
#-------------------------------------------------------------------------------------< variable
sub _syntax_prepare_variable_unnamedblock {
	my $block			= &block_brace;
	
	my $tk_accmod		= token 'accessmod';
	my $tk_var			= token 'variable';
	my $tk_const		= token 'constant';
	#my $kw_var			= keyword 'variable';
	#my $kw_const		= keyword 'constant';
	
	$block 				=~ s/\b(?:$tk_accmod)?\s*($tk_var|$tk_const)/local $1/gsx;
	
	return "<unblk_pref>_UNNAMEDBLOCK_$block";
	
}

sub _syntax_prepare_variable_list {
	
	my $var_def				= &name_list;
	my $var_init			= &name_list;
	
	$var_def				=~ s/(\w+)\,?/<accessmod> <variable> $1;/gsx;
	
	return "$var_def ($var_init) ";
	
	#return "LI: ( <name_list> ) { <accessmod> <variable> _LI_; } IF: ( !'<endop>' ) {(<name_list>) <endop>}";
}

sub _syntax_prepare_variable {
	my $accmod			= &accessmod || var 'accessmod';
	return "$accmod _<variable><constant>_ <name>; IF: ( !'<endop>' ) {<name> <endop>}";
}

sub _syntax_variable {
	my $accmod		= &accessmod || var 'accessmod';
	my $name		= &name;
	my $boost_vars	= '';
	my $or			= '';
	my $local_var	= '';
	my $end_op		= '';
	
	$name			=~ s/\w+(?:::\w+)*::(\w+)/$1/sx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;
	$accmod				= var($accmod.'_var');
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	$end_op			= " $name<endop> " if !&endop;
	$boost_vars		= var('BOOST_VARS') || '';
	$or				= '|' if $boost_vars;
	var('BOOST_VARS') .= $or . &name if &name !~ /$boost_vars/;

	#return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<endop>' ) {<name><endop>}/;
	#return "my \$$name; $local_var { no warnings; sub $name ():lvalue { \$$name } } $end_op";
	return "my \$$name; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { $accmod\$$name };$end_op";
}

sub _syntax_variable_boost {
	my $content		= &all;
	my $regexp		= var('BOOST_VARS');
	$content 		=~ s/(?:(?<!(?:var|sub)\s)|(?<!\$|\*)|(?<!\-\>))\b($regexp)\b/\$$1/gsx if $regexp;
	return $content;
}
#-------------------------------------------------------------------------------------< constant
sub _syntax_constant {
	my $accmod		= &accessmod || var 'accessmod';
	my $name		= &name;
	my $local_var	= '';
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	$name			=~ s/\w+(?:::\w+)*::(\w+)/$1/sx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;
	$accmod				= var($accmod.'_var');

	return "${local_var}sub $name () { $accmod<content> }";
}
#-------------------------------------------------------------------------------------< namespace
sub _syntax_prepare_name_namespace {
	#var('namespace')	= &name;
	return 'public <kw_class> <name> {';
}

sub _syntax_prepare_namespace {
	my $name			= &name;
	my ($parent_name)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; $parent_name ||= '';
	return "<kw_public> _<kw_class>_ <name> {"
}

sub _syntax_namespace {
	return "{ package <name>; use strict; use warnings;"
}

#-------------------------------------------------------------------------------------< interface

sub _syntax_prepare_interface {

	
	my $accmod			= &accessmod || var 'accessmod';
	my $object			= &interface;
	my $name			= &name;
	my $extends			= &content;
	#my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_constant		= token 'constant';
	my $tk_variable		= token 'variable';
	my $tk_function		= token 'function';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	
	
	#$accmod				= var($accmod.'_interface');
	
	#($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
	#	$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
	#	$list_extends			= "'$list_extends'" if $list_extends;
	#	$list_extends			||= '';
	#	$extends				= "use rise::core::implements $list_extends;" if $list_extends;
		
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
		
			 
	
	return "${accmod}... _<interface>_ ...<name>...<content>...{$block}";
}

sub _syntax_prepare_interface_post {'<kw_interface>'}

sub _syntax_interface {

	
	my $accmod			= &accessmod || var 'accessmod';
	#my $object			= &class_type;
	my $name			= &name;
	my $extends			= &content;
	my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_constant		= token 'constant';
	my $tk_variable		= token 'variable';
	my $tk_function		= token 'function';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; 
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	
	$accmod				= var($accmod.'_interface');
	
	($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		$extends				= " use rise::core::implements $list_extends;" if $list_extends;
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/'$1-constant-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/'$1-variable-$2' => 1,/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/'$1-function-$2' => 1,/gsx;
	#$block				=~ s/my\s+\$(\w+(?:\:\:\w+)*)\;\s*\{\s*no\swarnings\;\s*sub\s+\1\s*\(\)\:lvalue\s*\{\s*\_\_PACKAGE\_\_\-\>\_\_(\w+)\_VAR\_\_\;\s*\$\1\s*\}\s*\}/'$2-variable-$1' => 1,/gsx;
		
			 
	
	#return "{ package <name>;...use rise::core::extends 'rise::object::interface'$parent_class;$extends${accmod}...sub interface...{$block}}";
	return "{ package <name>;...use rise::core::extends 'rise::object::interface'$parent_class;$extends${accmod}...$block}";
}

#-------------------------------------------------------------------------------------< abstract

sub _syntax_prepare_abstract {

	my $accmod			= &accessmod || var 'accessmod';
	my $object			= &abstract;
	my $name			= &name;
	my $extends			= &content;
	my $block			= &block_brace;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_constant		= token 'constant';
	my $tk_variable		= token 'variable';
	my $tk_function		= token 'function';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_constant>-$2');/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_variable>-$2');/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_function>-$2');/gsx;
	
	return "${accmod}... _<abstract>_ ...<name>...<content>...{$block}";
}

sub _syntax_prepare_abstract_post {'<kw_abstract>'}

sub _syntax_abstract {

	
	my $accmod			= &accessmod || var 'accessmod';
	#my $object			= &class_type;
	my $name			= &name;
	my $extends			= &content;
	my $list_extends	= '';
	my $block			= &block_brace;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_constant		= token 'constant';
	my $tk_variable		= token 'variable';
	my $tk_function		= token 'function';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; 
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	
	$accmod				= var($accmod.'_abstract');
	
	($list_extends)		= $extends =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		$extends				= " use rise::core::implements $list_extends;" if $list_extends;
		
	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	return "{ package <name>;...use rise::core::extends 'rise::object::abstract'$parent_class;$extends${accmod}...$block}";
}

#-------------------------------------------------------------------------------------< class

sub _syntax_prepare_class {
	my $ns				= var('namespace');
	my $accmod			= &accessmod;
	my $object			= &_class_type_;
	my $name			= &name;
	my $agrs_attr		= &agrs_attr;
	my $extends			= '';
	my $kw_extends		= keyword 'inherits';
	my $tk_name_list	= token 'name_list';
	my ($parent_name)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; $parent_name ||= '';
	my $comma			= '';
	
	$comma		= ',' if $agrs_attr =~ s/\_$kw_extends\_\s*($tk_name_list)/$1/gsx;
	
	$extends			= 'rise::object::class';
	$extends			.= ", $parent_name" if $parent_name;
	$extends			.= $comma;

	$agrs_attr			= "_<kw_inherits>_ $extends $agrs_attr" if $extends;

	return "${accmod}...prepared_class...<name>...${agrs_attr}...{";
}

sub _syntax_class {
	my $accmod			= &accessmod || var 'accessmod';
	#my $object			= &_class_type_;
	my $name			= &name;
	my $agrs_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $base_class		= "'rise::object::class'";
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx;
	my $comma			= '';
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	#$base_class		.= ", '$parent_class'" if $parent_class;
	
	#$accmod				= ' _'.uc($accmod).'_CLASS_;';
	$accmod				= var($accmod.'_class');
	
	#$base_class		= "'rise::object::class'" if &_class_type_ eq '_base_';
	
	($list_extends)			= $agrs_attr =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		$comma					= ',' if $list_extends;
		$extends				= " use rise::core::extends $base_class$parent_class$comma$list_extends;";
		
	($list_implements)		= $agrs_attr =~ m/\_implements\_\s*($tk_name_list)/gsx;
		$list_implements		=~ s/\s*\,\s*/','/gsx if $list_implements;
		$list_implements		= "'$list_implements'" if $list_implements;
		$list_implements		||= '';
		
		$implements				= " use rise::core::implements  $list_implements;" if $list_implements ne '';
		#$implements				.= ' __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		$implements				.= ' __PACKAGE__->interface_confirm;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		#$implements				.= ' __PACKAGE__->interface_confirm("'.(var('members')->{$name}||'').'");' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');
		
		#
		#$implement_list			= $interface_list;
		#$implement_list			=~ s/\,/','/gsx;
		#$implements				= "; use rise::core::implements '" . $implement_list . "'" if $interface_list ne '';
		#$implements				.= '; __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST' if $interface_list ne '' && $tp eq 'class';

	
	#if (&_class_type_ eq '_base_' || $extends_list ne '') {
	#	$extends			= " use rise::core::extends $parent_class $extends_list;";
	#}

	#$extends			.= "$parent_class$extends_list";
	#$extends			.= '; ' if $extends;
	
	#print "########## $object EXT $extends - IMPL $implements ########\n";
	
	
	
	#$extends				= "use rise::core::extends '" . $parent_list . "'$class_ext";
	#$$implements			= "use rise::core::implements  '"
	
	return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
	#return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' }...";
	
}

sub _syntax_class_OFF {
	my $accmod			= &accessmod || var 'accessmod';;
	#my $object			= &_class_type_;
	my $name			= &name;
	my $agrs_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $parent_class	= '';
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	
	my $comma			= '';
	
	#$accmod				= ' _'.uc($accmod).'_CLASS_;';
	$accmod				= var($accmod.'_class');
	
	#$parent_class		= "'rise::object::class'" if &_class_type_ eq '_base_';
	
	($list_extends)			= $agrs_attr =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		#$comma					= ',' if $list_extends;
		#$list_extends			= $parent_class . $comma . $list_extends;
		$extends				= " use rise::core::extends $list_extends;";
		
	($list_implements)		= $agrs_attr =~ m/\_implements\_\s*($tk_name_list)/gsx;
		$list_implements		=~ s/\s*\,\s*/','/gsx if $list_implements;
		$list_implements		= "'$list_implements'" if $list_implements;
		$list_implements		||= '';
		
		$implements				= " use rise::core::implements  $list_implements;" if $list_implements ne '';
		$implements				.= ' __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST;' if $list_implements ne ''; # && &_class_type_ eq ('_class_'||'_base_');

		
		#
		#$implement_list			= $interface_list;
		#$implement_list			=~ s/\,/','/gsx;
		#$implements				= "; use rise::core::implements '" . $implement_list . "'" if $interface_list ne '';
		#$implements				.= '; __PACKAGE__->interface_confirm if %IMPORT_INTERFACELIST' if $interface_list ne '' && $tp eq 'class';

	
	#if (&_class_type_ eq '_base_' || $extends_list ne '') {
	#	$extends			= " use rise::core::extends $parent_class $extends_list;";
	#}

	#$extends			.= "$parent_class$extends_list";
	#$extends			.= '; ' if $extends;
	
	#print "########## $object EXT $extends - IMPL $implements ########\n";
	
	
	
	#$extends				= "use rise::core::extends '" . $parent_list . "'$class_ext";
	#$$implements			= "use rise::core::implements  '"
	
	return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
	
}




sub _syntax_prepare_class_helper {
	my ($name, $block) = @_;
	

	
	my $tk_accessmod	= token 'accessmod';
	my $tk_class		= token 'class';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	my $tk_extends		= token 'inherits';
	my $tk_content		= token 'content';
	my $tk_block		= token 'block_brace';
	my $extends			= keyword('inherits').' '.$name;
	
	#var('anon_fn_count')++;
	

	
	#my ($chk_anon_code)	= $block =~ m/$tk_class\s*($tk_name)?\s*$tk_content?\s*$tk_block/;
	#
	#if (!$chk_anon_code) {
	#	var('anon_fn_count')++;
	#	$name			= 'anon_code_'.var('anon_fn_count');
	#}		
	
	$block				=~ s/\{(.*)\}/$1/gsx;
	
	$block				= "{###DIALECTCLASSHEAD###$block}";
	
	$block				=~ s/\b($tk_class)\s*($tk_name)\s*($tk_extends)?(\s*$tk_name_list)?/$1 $2 $extends/gsx;
	#$block				=~ s/($tk_class)\s*($tk_name)\s*($tk_extends)?(\s*$tk_name_list)?/$1 $2 <kw_inherits> $name/gsx;
	$block 				=~ s/\b($tk_accessmod)?\s*($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/($1||var('accessmod')).' _'.$2.'_ '.$name.'::'.$3.' '.$4.' '._syntax_prepare_class_helper($name.'::'.$3, $5)/gsxe;
	#$block 				=~ s/\b(?:$tk_accessmod)?\s*($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/'_'.$1.'_ '.$name.'::'.$2.' '.$3.' '._syntax_prepare_class_helper($name.'::'.$2, $4)/gsxe;
	
	#if ($block !~ s/($tk_class)\s*($tk_name)\s*($tk_content)\s*($tk_block)/$1.' '.$name.'::'.$2.' '.$3.' '._prepare_class_helper($name.'::'.$2, $4)/gsxe){
	#	$block			=~ s/\{(.*)\}/$1/gsx;
	#	$block			=~ s/($tk_block)/_prepare_class_helper($name, $1)/gsxe;
	#}
	
	
	
	return $block;
}
#-------------------------------------------------------------------------------------< object
sub _syntax_prepare_name_object {
	
	my $accmod			= &accessmod || var 'accessmod';
	my $object			= &object;
	my $name			= &name;
	my $agrs_attr		= &agrs_attr;
	my $block			= &block_brace;
	my $base			= '';
	my $kw_class		= keyword 'class';
	my $object_type		= $object;
	
	$object_type		= 'base' if $object eq $kw_class;

	var('anon_fn_count') = 0;

	#$name				= var('namespace').'::'.$name if var('namespace');

	$block 				= _syntax_prepare_name_object_helper($name, $block);

	return "_object_${object_type}_ ${accmod}... _<object>_ ...<name>...<agrs_attr>...${block}";
}

sub _syntax_prepare_name_object_helper {
	my ($name, $block) = @_;

	my $accessmod;
	my $objname;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_object		= token 'object';
	my $tk_name			= token 'name';
	my $tk_agrs_attr	= token 'agrs_attr';
	my $tk_content		= token 'content';
	my $tk_block		= token 'block_brace';

	$block 				=~ s{
			\b(?<accessmod>$tk_accessmod)?
				(?<sps1>\s*)(?<object>$tk_object)
				(?<sps2>\s*)(?<name>$tk_name)?
				(?<sps3>\s*)(?<agrs_attr>$tk_agrs_attr)?
				(?<sps4>\s*)(?<block_brace>$tk_block)?
		}{
			$accessmod = $+{accessmod}||var('accessmod');
			var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$+{name} . ' ';
			'_object_'.$+{object}.'_ '.
				$accessmod.
				$+{sps1}.' _'.$+{object}.'_ '.
				$+{sps2}.$name.'::'.$+{name}.
				$+{sps3}.($+{agrs_attr}||'').
				$+{sps4}._syntax_prepare_name_object_helper($name.'::'.$+{name}, $+{block_brace}||'')
		}gsxe;
	
	#$block 				=~ s{
	#		\b(?<accessmod>$tk_accessmod)?\s*(?<object>$tk_object)\s*(?<name>$tk_name)?\s*(?<agrs_attr>$tk_agrs_attr)?\s*(?<block_brace>$tk_block)?
	#	}{
	#		$accessmod = $+{accessmod}||var('accessmod');
	#		$objname=$+{name};if(!$objname){var('anon_fn_count')++;$objname=var('anon_code_pref').sprintf("%05d", var('anon_fn_count'));}
	#		var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#		$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{agrs_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#	}gsxe;
	
	#$block 				=~ s{
	#	\b(?<accessmod>$tk_accessmod)?\s*(?<object>$tk_object)\s*(?<name>$tk_name)?\s*(?<agrs_attr>$tk_agrs_attr)?\s*(?<block_brace>$tk_block)?
	#}{
	#	$accessmod = $+{accessmod}||var('accessmod');
	#	$objname=$+{name};if($objname eq '_ANON_CODE_'){var('anon_fn_count')++;$objname.=sprintf("%05d", var('anon_fn_count'));}
	#	var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#	$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{agrs_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#}gsxe;
	
	return $block;
}

sub _syntax_op_dot {'->'}

sub _syntax_optimise4 { ';' }
sub _syntax_optimise5 { ' ' }
sub _syntax_optimise6 { '' }

1;