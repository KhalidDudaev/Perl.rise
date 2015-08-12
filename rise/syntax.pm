package rise::syntax;

use strict;
use warnings;
use v5.008;
use utf8;

use Data::Dump 'dump';
use Clone 'clone';

use lib '../lib/rise/';

use rise::grammar qw/:simple/;
#use rise::action;

our $VERSION = '0.000';
our $conf							= {};

my $cenv 							= {};
my $this							= {};
my $PARSER							= {};
#my $parser							= new rise::grammar;
#my $a								= rise::action->new(__PACKAGE__->new);

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    #__init();
	return bless($conf, $class);                         					# обьявляем класс и его свойства
}

#sub import {
#	my $ARGS 					= $_[1] || {};
#
#	#%$conf						= ( %$ARGS, %$conf );
#	%$conf						= ( %$conf, %$ARGS );
#
#}

sub confirm {
	my $self						= shift;
	
	%$conf						= (%$conf, %$self);
	#print dump($conf)."\n";
	
	var('env')						= '$rise::object::object::renv';
	var('app_stack')				= [];
	#var('parse_token_sign')			= '-';
	var('accessmod_class')			= $self->{accmod_class} || 'private';
	var('accessmod')				= $self->{accmod} || 'private';
	#var('command_inherit')			= 'use parents';
	#var('text')						= [];
	#var('namespace')				= '';
	#var('class')					= '';
	#var('function')					= '';
	var('anon_fn_count')			= 0;
	var('anon_code_pref')			= 'ACODE';
	#var('class_blocknum')			= undef;
	var('members')					= {};
	var('class_var')				= '';
	var('class_func')				= '';
	var('class_anon_func')			= '';
	var('members_export')			= {};
	
	var('private_namesapce')		= '';
	var('protected_namesapce')		= '';
	var('public_namesapce')			= '';
	
	var('private_base')				= '';
	var('protected_base')			= '';
	var('public_base')				= '';
	
	var('private_class')			= q/'__PACKAGE__->private_class("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('protected_class')			= q/'__PACKAGE__->protected_class("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('public_class')				= '';
	
	var('private_abstract')			= q/'__PACKAGE__->private_abstract("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('protected_abstract')		= q/'__PACKAGE__->protected_abstract("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('public_abstract')			= q/'__PACKAGE__->public_abstract("' . ($parent_class||'main') . '", "' . $name .'");'/;
	
	var('private_interface')		= q/'__PACKAGE__->private_interface("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('protected_interface')		= q/'__PACKAGE__->protected_interface("' . ($parent_class||'main') . '", "' . $name .'");'/;
	var('public_interface')			= q/'__PACKAGE__->public_interface("' . ($parent_class||'main') . '", "' . $name .'");'/;
	
	var('private_var')				= q/'__PACKAGE__->private_var("' . $parent_class . '", "' . $name .'");'/;
	var('protected_var')			= q/'__PACKAGE__->protected_var("' . $parent_class . '", "' . $name .'");'/;
	var('public_var')				= '';
	
	var('private_code')				= q/'__PACKAGE__->private_code("' . $parent_class . '", "' . $name .'");'/;
	var('protected_code')			= q/'__PACKAGE__->protected_code("' . $parent_class . '", "' . $name .'");'/;
	var('public_code')				= '';
	
	var ('parser_variable')			= [
		'_variable_boost',
		#'_var_boost2',
		'_var_boost3',			
		'_variable',
		'_constant',
	];
		
	var ('parser_function')			= [
		'_function',
		'_function_method',
	];
	
	var ('parser_code')				= [
		
		'_foreach',
		'_for',
		'_while',		
		
		'_function_defs',		
		'_variable_list',
		'_var_boost1',				

		@{var 'parser_function'},
		@{var 'parser_variable'},
	];
	
	var ('parser_class')			= [
		'_class',
		'_inject',
		'_using',
	
		@{var 'parser_code'},
	];
	
	var ('parser_interface')		= [
		'_interface_set',
	];
	
	var ('parser_abstract')			= [
		'_interface_set',
		'_inject',
		'_using',
		@{var 'parser_code'},
	];
	
	var ('parser_namespace')		= [
		'_namespace',
		'_inject',
		'_using',
		'_class',
		'_abstract',
		'_interface',
	];
	
	var ('parser__')				= [
		'_excluding',
		'_nonamedblock',
		@{var 'parser_namespace'},
		'_unwrap_code',
		'_op_dot',
		'_optimise4',
		'_optimise5',
		'_optimise6',
		'_function_method_post1',
		'_function_method_post2',
		#'_function_boost_post1',
		#'_function_boost_post2',
		#'_variable_boost_post',
		
		'_including',
		'_commentC',
	];

	#print dump(var 'parser__');
	
	#var 'parser_function'				= [qw/
	#	_function	
	#/];	
	#
	#var 'parser_code'					= [
	#	'_function_defs',
	#	@{var 'parser_function'},
	#	'_function_method'
	#];
	#
	#var 'parser_namespace'			= [qw/
	#	_namespace
	#	_class
	#	_abstract
	#	_interface
	#/];
	#
	#var 'parser_class'				= [
	#	'_class',
	#	@{var 'parser_code'}
	#];
	

	
	#print dump($PARSER);
	
	#var('private_var')				= q/((ref $_[0] || $_[0]) || __PACKAGE__) eq __PACKAGE__ || __PACKAGE__->__error('var_priv');/;
	#var('private_var')				= var('env')."->{caller}{name} eq __PACKAGE__ || __PACKAGE__->__error('var_priv');";
	
	
	#var('protected_var')			= q/((ref $_[0] || $_[0]) || __PACKAGE__) !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('var_prot');/;
	#var('protected_var')	= q/shift !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('var_prot');/;
	#tvar('protected_var')	= q/__PACKAGE__->__error('var_prot') if (($_[0] || __PACKAGE__) ne __PACKAGE__ and (($_[0] || __PACKAGE__) ne $__class)); /;
	
	
		
	#var('private_code')				= q/((ref $_[0] || $_[0]) || __PACKAGE__) eq __PACKAGE__ || __PACKAGE__->__error('code_priv');/;
	#var('protected_code')			= q/((ref $_[0] || $_[0]) || __PACKAGE__) !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('code_prot');/;
	##var('protected_code')	= q/shift !~ \/\=\w+\(0x\w+\)\/ || __PACKAGE__->__error('code_prot');/;
	##var('protected_var')	= q/__PACKAGE__->__error('code_prot') if (($_[0] || __PACKAGE__) ne __PACKAGE__ and (($_[0] || __PACKAGE__) ne $__class)); /;
	#var('public_code')				= '';.
	
	
	
	keyword namespace				=> 'namespace';
	keyword class					=> 'class';
	keyword abstract				=> 'abstract';
	keyword interface				=> 'interface';
	keyword using					=> 'using';
	keyword using2					=> 'import';
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
	keyword self					=> 'this';
	
	keyword for						=> 'for';
	keyword foreach					=> 'foreach';
	keyword while					=> 'while';
	
	################################################## rules ####################################################
	
	token namespace					=> keyword 'namespace';
	token class						=> keyword 'class';
	token abstract					=> keyword 'abstract';
	token interface					=> keyword 'interface';
	token inject					=> keyword 'inject';
	token using						=> keyword 'using';
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
	token self						=> keyword 'self';
	token for						=> keyword 'for';
	token foreach					=> keyword 'foreach';
	token while 					=> keyword 'while';
	
	token '"'						=> '\"';
	token comma						=> q/\,/;
	
	token before					=> q/^all/;
	token after						=> q/all$/;
	#token content					=> q/string+/;
	token content					=> q/all?/;
	
	token string					=> q/(?^s:.(?^:all))/;
	
	token ident						=> q/[^\d\W]\w*/;
	#token ident						=> q/letter*/;
	token word						=> q/letter+/;
	#token word						=> q/letter\w*/;
	#token word						=> q/ident/;
	
	token number					=> q/digit+/;
	#token letter					=> q/(?!nletter+|digit+)?\w/;
	#token letter					=> q/[^\W\d]\w/;
	#token letter					=> q/[_a-zA-Z]/;
	token letter					=> q/\w/;
	token digit						=> q/\d/;
	token nletter					=> q/\W/;
	token all						=> q/.*/;
	#token all						=> q/string*/;
	token sps						=> q/\s*/;
	token spss						=> q/\s+/;
	
	token nnline					=> q/[^\r\n]/;
	#token nline						=> q/[\r\n]/;
	token nline						=> q/\r|\n|\r\n/;
	token op_end					=> q/\;/;
	
	token name_ex					=> q/ident(?:::ident)*/;
	
	#token name						=> q/word(?:\:\:word)*/;
	token name						=> q/\b(?:ident(?:::ident)*)\b/;
	#token name						=> q/(?:\b[^\d\W]\w*\b)(?:::(?:\b[^\d\W]\w*\b))*/;
	
	#token name						=> q/[^\d\s](?:word\:\:)*word/;
	token name_list					=> q/name(?:\s*\,\s*name)*/;
	token namestrong				=> q/[^\d\W][\w:]+[^\W]/;
	token name_ext					=> q/name/;
	token name_impl					=> q/name_list/;
	
	#token comment					=> q`(?<![$@%])[#] nnline*`;
	#token comment					=> q`(?<![$@%])(?:\#|//) nnline*`;
	token comment_Perl				=> q`(?<![$@%])\# nnline*`;
	token comment_C					=> q`(?<![$@%])\/\/ nnline*`;
	token comment					=> q/comment_Perl|comment_C/;
	
	#token comment					=> q/(?<![$@%])\#string/;
	#token comment					=> q/(?<![$@%])\#string\n/;
	#token comment2					=> q/(?<![\$\@\%])\#.*?\n/;
	
	
	token for_each					=> q/foreach|for/;
	
	token accessmod					=> q/local|private|protected|public/;
	token class_type				=> q/namespace|class|abstract|interface/;
	#token function					=> q/function/;
	token name_ops					=> q/class_type|function|variable|constant|using|inherits|implements|new/;
	token object_members			=> q/function|variable|constant/;
	token object					=> q/(?<!\S)(?:class_type|object_members)(?!\S)/;
	
	token _object_type_				=> q/\b_object_ word _\b/;
	token _object_					=> q/_class_|_abstract_|_interface_/;
	token _namespace_				=> q/_namespace_/;
	token _base_					=> q/_base_/;
	token _class_					=> q/_class_/;
	token _interface_				=> q/_interface_/;
	token _abstract_				=> q/_abstract_/;
	token _class_type_				=> q/_namespace_|_base_|_class_|_abstract_|_interface_/;
	#token _function_				=> q/_function_|_method_|_fmethod_/;
	token _function_				=> q/_function_/;
	token _var_						=> q/_var_/;
	token _const_					=> q/_const_/;
	
	token obj_type					=> q/OBJECT \_ (?:function)/;
	token type_all					=> q/class_type|function/;
	token class_attr				=> q/\s*content\s*/;
	token namespace_attr			=> q/class_attr/;
	
	#token code_attr					=> q/(?:\(\W*\))?(?:\:\s*content\s*)?/;
	#token code_attr					=> q/(?:\(\W*\))?(?:\:[\w\s\(\)\,]+)?/;
	#token code_attr					=> q/(?:\:\s*content\s*)/;	
	#token code_attr					=> q/(?:\:\s*content)/;
	#token code_attr					=> q/(?:\:content)+/;
	token code_attr					=> q/(?:\:\s*word\s*)*/;	
	#token code_attr					=> q/(?:[^\{\}\n]*)?/;
	#token code_attr					=> q/[^\{\}\n]*/;
	
	token code_args					=> q/\(content\)/;
	
	token args_attr					=> q/(?:[^\{\}](?!object|accessmod))*/;
	#token args_attr					=> q/(?:[^\{\}\;])*/;
	#token args_attr					=> q/(?:\(\W*\))?(?:\s*\:\s*content)?/;
	#token args_attr					=> q/(?:\([\\\@\$\%\&\*\;\,]*\))?(?:\:[\w\s\(\)\,]+)?/;
	#token args_attr					=> q/[^\{\}\n]+[\;]*?/;
	
	token list						=> q/\(content\)/;
	token inherit_list				=> q/inherits/;
	token implement_list			=> q/implements/;
	#token var_all					=> var('class_var')||1;
	
	token excluding					=> q/POD|DATA|END|comment|text/;
	token including					=> q/%%%TEXT_ number %%%/;
	token wrap_code					=> q/%%%CLASS_CODE_ name_ex %%%/;
	
	token EOP 						=> q/(?:\n\n|\Z)/;
	token CUT 						=> q/(?:\n=cut.*EOP)/;
	token POD 						=> q/(?:^=(?:head[1-4]|item).*?CUT|^=pod.*?CUT|^=for.*?CUT|^=begin.*?CUT)/;
	token DATA 						=> q/(?:^__DATA__\r?\n.*)/;
	token END 						=> q/(?:^__END__\r?\n.*)/;
	
	token text						=> q/(?:qtext|textqq|textqw|qregex)/;
	#token textqq					=> q/(?:''|'content[^\\\]')/;
	#token textqw					=> q/(?:""|"content[^\\\]")/;
	token textqq					=> q/(?:\'content[^\\\']?\')/;
	token textqw					=> q/(?:\"content[^\\\"]?\")/;
	#token qtext 					=> q/qtext_paren|qtext_brace|qtext_square|qtext_angle|qtext_slash|qtext_char/;
	token qregex					=> q/\=\~\s*(?:s|m)?(?:in_paren|in_brace|in_square|in_angle|in_slash|in_char)/;
	token qtext						=> q/qvar\s*(?:in_paren|in_brace|in_square|in_angle|in_slash|in_char)/;
	token qvar						=> q/q[qwr]?/;
	token qquote					=> q/qvar/;
	
	token in_paren					=> q/(?:\(content[^\\\)]\))/;
	token in_brace					=> q/(?:\{content[^\\\}]\})/;
	token in_square					=> q/(?:\[content[^\\\]]\])/;
	token in_angle					=> q/(?:\<content[^\\\>]\>)/;
	token in_slash					=> q/(?:\/content[^\\\/]\/)/;
	token in_char					=> q/(?:(?<qchar>[\W\w])content(?!\\\&qchar)&qchar)/;	
	
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
	
	token sigils					=> q/[\@\$\%\&\*]/;
	
	################################################## rules ####################################################
	rule _									=> q/<all>/;
	
	rule _excluding							=> q/<excluding>/;
	rule _nonamedblock						=> q/<unblk_pref><block_brace>/;
	rule _namespace							=> q/<namespace> <name> <block_brace>/;

	rule _inject							=> q/<inject> <content> <op_end>/;
	rule _using								=> q/<using> <name>[<content>]<op_end>/;
	rule _inherits							=> q/<inherits> <name>/;
	rule _implements						=> q/<implements> <name_list>/;	
	
	#rule _object							=> q/[<_object_type_>] [<accessmod>] <_object_> <name> [<content>] \{/;	
	rule _class								=> q/[<accessmod>] <class> <name> [<content>] <block_brace>/;
	rule _abstract							=> q/[<accessmod>] <abstract> <name> [<content>] <block_brace>/;
	rule _interface							=> q/[<accessmod>] <interface> <name> [<content>] <block_brace>/;
	rule _interface_set						=> q/[<accessmod>] <object_members> <name> <op_end>/;
	
	rule _foreach							=> q/<for_each> [<variable>] <name> \(<CONDITION>\) \{<STATEMENT>\}/;
	rule _for								=> q/<for_each> \( <variable> <name> <CONDITION>\) \{<STATEMENT>\}/;
	rule _while								=> q/<while> \( <variable> <name> <CONDITION>\) \{<STATEMENT>\}/;

	rule _function 							=> q/[<accessmod>] <function> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
	rule _function_defs 					=> q/[<accessmod>] <function> [<args_attr>] <op_end><nline>/;
	rule _function_method					=> q/(NOT:__METHOD__)<name>\((NOT:__PACKAGE__)/;
	#rule _function_method					=> q/<name>\((NOT:__PACKAGE__)/;
	rule _function_method_post1				=> q/(__METHOD__)+/;
	rule _function_method_post2				=> q/__PACKAGE__\,\)/;
	
	rule _variable_list						=> q/[<accessmod>] <variable> \( <name_list> \) [<op_end>]/;
	rule _variable							=> q/[<accessmod>] <variable> <name> [<op_end>]/;
	rule _constant							=> q/[<accessmod>] <const> <name> = <content> <op_end>/;
	#rule _variable_boost					=> q/((_NOT:sigils)(_NOT:sub)<spss>)<name>/;
	#rule _variable_boost					=> q/(_NOT:__VARBOOSTED__)(_NOT:sigils)<name>/;
	#rule _variable_boost					=> q/(_NOT:sigils|\.)(_NOT:sub\s)(NOT:__VARBOOSTED__)<name>/;
	#rule _variable_boost					=> q/(_NOT:sigils|\.)(_NOT:sub\s)<name>(NOT:__VARBOOSTED__)/;
	rule _variable_boost					=> q/(_NOT:sigils|\.)(_NOT:sub\s)<name>/;
	rule _variable_boost_post				=> q/__VARBOOSTED__/;
	# rule _variable_boost					=> q/<word> (_NOT:sigils)<name>/;
	rule _var_boost1						=> q/[<accessmod>] <variable> <name>/;
	rule _var_boost2						=> q/(_NOT:sigils|\.)(_NOT:sub\s)<var_all>/;
	rule _var_boost3						=> q/variable \$/;
	rule _var_boost_post1					=> q/_var_ \$/;
	rule _var_boost_post2					=> q/\.\$/;	

	rule _op_dot							=> q/op_dot/;
	rule _optimise4 						=> q/\s+\;/;
	#rule _optimise5 						=> q/\s\s+(_NOT:\n|\t)/;
	rule _optimise5 						=> q/\s\s+/;
	rule _optimise6 						=> q/_UNNAMEDBLOCK_/;	
	rule _including							=> q/<including>/;
	rule _unwrap_code						=> q/<all>/;
	rule _commentC							=> q/<comment_C>/;
	
	############################# post rules ########################################
	# rule _parser_list_iter					=> q/LI: \( <name_list> \) \{ <content> \}/;
	# rule _parser_if							=> q/IF: \( [<CONDITION>] \) \{<THEN>\}[ ELSE: \{<ELSE>\} ]/;
	
	############################# actions ########################################
	action _								=> \&_;
	
	action _excluding 						=> \&_syntax_excluding;
	action _nonamedblock					=> \&_syntax_nonamedblock;

	action _namespace 						=> \&_syntax_namespace;
	#action _object 							=> \&_syntax_object;
	action _class 							=> \&_syntax_class;
	action _abstract 						=> \&_syntax_abstract;
	action _interface 						=> \&_syntax_interface;
	action _interface_set					=> \&_syntax_interface_set;	
	action _inject 							=> \&_syntax_inject;
	action _using 							=> \&_syntax_using;
	action _inherits			 			=> \&_syntax_inherits;
	action _implements 						=> \&_syntax_implements;

	action _foreach 						=> \&_syntax_foreach;
	action _for 							=> \&_syntax_for;
	action _while 							=> \&_syntax_while;

	action _function_defs 					=> \&_syntax_function_defs;
	action _function 						=> \&_syntax_function;
	action _function_method					=> \&_syntax_function_method;
	action _function_method_post1			=> \&_syntax_function_method_post1;
	action _function_method_post2			=> \&_syntax_function_method_post2;		

	action _variable_list 					=> \&_syntax_variable_list;
	action _variable 						=> \&_syntax_variable;
	action _constant 						=> \&_syntax_constant;
	action _var_boost1						=> \&_syntax_var_boost1;
	action _var_boost2						=> \&_syntax_var_boost2;
	action _var_boost3						=> \&_syntax_var_boost3;
	action _variable_boost					=> \&_syntax_variable_boost;
	action _variable_boost_post				=> \&_syntax_variable_boost_post;

	action _unwrap_code						=> \&_syntax_unwrap_code;
	action _op_dot							=> \&_syntax_op_dot;
	action _optimise4		 				=> \&_syntax_optimise4;
	action _optimise5		 				=> \&_syntax_optimise5;
	action _optimise6		 				=> \&_syntax_optimise6;
	
	action _including						=> \&_syntax_including;
	action _commentC 						=> \&_syntax_commentC;
	
	order = var 'parser__';
	
	#print dump(order);
	#print rule '_function_method';

}

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

#sub _ {
#	my $s	= &all;
#	$s		= parse($self, $s, grammar, ['_excluding']);
#	$s		= parse($self, $s, grammar, ['_namespace']);
#	$s		= parse($self, $s, grammar, ['_class']);
#	$s		= parse($self, $s, grammar, ['_abstract']);
#	$s		= parse($self, $s, grammar, ['_interface']);
#	$s		= parse($self, $s, grammar, ['_including']);
#	$s		= parse($self, $s, grammar, ['_commentC']);
#	return $s;
#}

#sub __code {
#	my ($self, $code, $confs)	= @_;
#	$code 				= parse($self, $code, &grammar, [qw/
#		_function_defs
#		_function
#		_function_method
#	/], $confs);
#	#$code 				= parse($self, $code, &grammar, ['_function'], $confs);
#	#$code 				= parse($self, $code, &grammar, ['_function_method'], $confs);
#}

#-------------------------------------------------------------------------------------< excluding_ON

sub _syntax_commentC {
	my $comment = &comment_C;
	$comment =~ s/^\/\//\#/gsx;
	return $comment;
}

sub _syntax_excluding {
		#my $self = shift;
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

sub _syntax_unwrap_code {
	
	my $all				= &all;
	#my $including		= &including_class_code;
	#my $tk_including_class_code = token 'including_class_code';
	
	
	
	my $res				= '';
	1 while $all =~ s/%%%WRAP_CODE_(\w+(?:::\w+)*)%%%/var('wrap_code')->{$1}/gsxe;
	
	#print "############ #############\n";
	
	#$res				= var('excluding_class_code')->{$including} if $including;
	return $all;
}
#-------------------------------------------------------------------------------------< inject | using | inherits | implements
sub _syntax_inject {
	my ($self, $rule_name, $confs)			= @_;
	my $content				= &content; 
	$content 				=~ s/\<TEXT\_(\d+)\>/var('excluding')->[$1]/gsxe;
	#__add_stack($1) if $content =~ m/\'(\w+(?:\.\w+)?)\'/gsx;
	return "require...${content}<op_end>"
}

sub _syntax_using {	
	#__add_stack(&name);
	return "use...<name>...<content><op_end>";
}

sub _syntax_inherits {
	#__add_stack(&name);
	return "_<inherits>_...<name>";
}

sub _syntax_implements {
	#__add_stack(&name_list);
	return "_<implements>_...<name_list>";
}

#-------------------------------------------------------------------------------------< for | foreach | while
sub _syntax_foreach {
	my ($self, $rule_name, $confs)			= @_;
	my $for = '<for_each>...(...<CONDITION>...)...{ <name> = $_;<STATEMENT>}';
	$for = '{ <kw_local> <variable> <name>; '.$for.'}' if &variable;
	return $for;
}

sub _syntax_for { "{ <kw_local> <variable> <name>; <for_each>...(...<name>...<CONDITION>...)...{<STATEMENT>}}" }

sub _syntax_while { "{ <kw_local> <variable> <name>; <while>...(...<name>...<CONDITION>...)...{<STATEMENT>}}" }
#sub _syntax_prepare_while {
#	my $while = '<while>...(...<CONDITION>...)...{ <name> = $_;<STATEMENT>}';
#	$while = '{ <kw_local> <variable> <name>; '.$while.'}' if &variable;
#	return $while;
#}

#-------------------------------------------------------------------------------------< function_defs | prepare function | function
#sub _syntax_function_defs { "sub <name><args_attr><op_end>" }
sub _syntax_function_defs {
	my ($self, $rule_name, $confs)			= @_;
	#my ($s1,$s2,$s3,$s4) = (&sps1,&sps2,&sps3,&sps4);
	#"${s1}sub${s2}<name>${s3}<args_attr>${s4}<op_end><nline>";
	"...sub <name><args_attr><op_end>... ... ...<nline>";
}

sub _syntax_function_list {

	var('class_func') 				.= '|' . &name;
	var('class_func')				=~ s/^\|//;
	
	#print ">>>>> ".var('class_func')."\n";

	token func_all					=> var('class_func')||'';
	rule _function_method			=> q/<func_all>\((NOT:__PACKAGE__)[<content>]\)/;
	
	return "_<kw_function>_ <name>";
}

sub _syntax_anon_function_list {

	var('class_anon_func') 			.= '|' . &name;
	var('class_anon_func')			=~ s/^\|//;
	
	#print ">>>>> ".var('class_anon_func')."\n";

	token anon_func_all				=> var('class_anon_func')||'';
	rule _anon_func2method			=> q/<anon_func_all>(\-\>|\.)\((NOT:\_\_PACKAGE\_\_)/;
	
	return "<name> = _<kw_function>_";
}

sub _syntax_function_list_post { '<kw_function>' }

sub _syntax_function_method_OFF {
	my ($rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	my $parent_name		= $confs->{parent} || 'main';
	my $args			= &content; #$args ||= '';
	my $self			= '';
	my $fname			= &func_all;
	my $tk_accmod		= token 'accessmod';
	my $fn_list			= var('members')->{$parent_class};
	
	if ($fn_list) {
		$fn_list			=~ s/\b(?:$tk_accmod)\-(?!function)\w+\-(\w+)//gsx;
		$fn_list			=~ s/\b(?:$tk_accmod)\-function\-(\w+)/\\b$1\\b/gsx;
		#$fn_list			=~ s/^\s+(.*?)\s+$/$1/sx;
		$fn_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
		#$fn_list			=~ s/\#//gsx;
		$fn_list			=~ s/\s+//gsx;
	}
	
	
	
	if ($fname =~ m/$fn_list/sx) {
		$self			= '__PACKAGE__';
		$self			.= ',' if $args;
		#print ">>>>>>>>>>> class - $parent_class | fname - $fname | fnlist - *$fn_list* \n";
	}
	
	#print "-------> func_list - $fname\n";
	
	#$args				.= ',' . &content if &content;
	return "${fname}(${self}${args})";
}

sub _syntax_function_method {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	my $name			= &name;
	#my $args			= &content; #$args ||= '';
	my $this			= '';
	my $tk_accmod		= token 'accessmod';
	my $fn_list			= var('members')->{$parent_class}||'';
	my $method			= '__METHOD__';
	
	#if ($fn_list) {
	#	$fn_list			=~ s/\b(?:$tk_accmod)\-(?!function)\w+\-\w+(?:::\w+)*//gsx;
	#	$fn_list			=~ s/\b(?:$tk_accmod)\-function\-(\w+(?:::\w+)*)/\\b$1\\b/gsx;
	#	#$fn_list			=~ s/^\s+(.*?)\s+$/$1/sx;
	#	$fn_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
	#	#$fn_list			=~ s/\#//gsx;
	#	$fn_list			=~ s/\s+//gsx;
	#}
	#
	#if ($name =~ m/$fn_list/sx) {
	#	$this			= '__PACKAGE__,';
	#	#$this			.= ',' if $args;
	#	$method			= '';
	#	#print ">>> class - $parent_class | fname - $name | fnlist - *$fn_list* \n";
	#}
	
	my $members_fn		= '-function-'.$name;
	my $members_list	= var('members')->{$parent_class}||'';
	
	$members_list		=~ s/$tk_accmod//gsx;
	$members_list		=~ s/\-function\-//gsx;
	$members_list		=~ s/\s/\|/gsx;
	
	if ($name =~ m/\b(?:$members_list)\b/sx) {
		$this			= '__PACKAGE__,';
		#print ">>> $parent_class->$name | fnlist - *$members_list* \n";
	}
	
	#$args 				= parse($self, $args, &grammar, ['_function_method'], { parent => $name });

	#return "${method}${name}(${this}";
	return "${name}(${this}";
}

sub  _syntax_function_method_post1 {''}
sub  _syntax_function_method_post2 {'__PACKAGE__)'}

sub _syntax_anon_func2method { '<anon_func_all>.(__PACKAGE__, ' }

sub _syntax_func2method_post { '__PACKAGE__)' }

sub _syntax_prepare_function {
	my ($rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var('accessmod');
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
		var('anon_fn_count')++;
		$name = var('anon_code_pref').sprintf("%05d", var('anon_fn_count'));
		#$self_args		= '';
	}
	
	if ($args !~ m/\((\w+.*?)\)/sx) {
		$attr = $args . $attr;
		$args = '';
	}
	
	#print ">>>> $name - $args - $attr\n";
	
	$args				=~ s/\((.*?)\)/$1/gsx;
	$self_args			.= ',' . $args if $args;
	$arguments			= "<kw_local> <kw_variable> ($self_args) = \@_;";

	return "${accmod}... _<function>_ ...${name}... ${attr}...{ ${arguments}${block}}";
}

sub _syntax_function {
	my ($self, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var('accessmod');
	my $name			= &name;
	my $args			= &code_args || '';
	my $attr			= &code_attr || '';
	my $block			= &block_brace;
	my $sname			= &name;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	my $fn_name			= &name;
	my ($s1,$s2,$s3,$s4) = (&sps1,&sps2,&sps3,&sps4);
	my $anon_code		= '';
	my $arguments		= '';
	my $self_args		= &kw_self;
	#my $tk_accmod		= token 'accessmod';
	my $fn_list;
	my $res				= '';
	
	if ($name){
		#var('class_func') 				.= '|' . $name;
		#var('class_func')				=~ s/^\|//;
		#token func_all					=> $fn_list;
		#rule _function_method					=> q/(_NOT:sub\s)(_NOT:\-\>)(_NOT:\.)<func_all>\((NOT:__PACKAGE__)[<content>]\)/;
		
		var('members')->{$parent_class} .= ' '.$accmod.'-function-'.$name;
		var('members')->{$parent_class} =~ s/^\s+//;
		
		#$fn_list			= var('members')->{$parent_class};
		#if ($fn_list) {
		#	$fn_list			=~ s/\b(?:$tk_accmod)\-(?!function)\w+\-(\w+)//gsx;
		#	$fn_list			=~ s/\b(?:$tk_accmod)\-function\-(\w+)/\\b$1\\b/gsx;
		#	#$fn_list			=~ s/^\s+(.*?)\s+$/$1/sx;
		#	$fn_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
		#	#$fn_list			=~ s/\#//gsx;
		#	$fn_list			=~ s/\s+//gsx;
		#}			
		
	}
	
	if (!$name){
		var('anon_fn_count')++;
		$name			= var('anon_code_pref').sprintf("%05d", var('anon_fn_count'));
		$fn_name		= $name;
		$anon_code		= '\&'.$fn_name.'; ' ;
		$self_args		= '';
	}
	
	if ($args !~ m/\(\s*(\w+.*?)\)/sx) {
		$attr = $args . $attr;
		$args = '';
	}
	
	#return 0;
	
	$accmod				= var($accmod.'_code');
	$accmod				= eval $accmod if $accmod ne '';	
	$name				= $parent_class . '::' . $name;
	$args				=~ s/\s//gsx;
	$args				=~ s/\((.*?)\)/$1/gsx;
	$self_args			.= ',' . $args if $args; $self_args =~ s/^\,//;
	$arguments			= &kw_local." ".&kw_variable." ($self_args) = \@_;" if $self_args;
	$arguments			= parse($self, $arguments, &grammar, ['_variable_list','_variable'], { parent => $name });
	$block 				=~ s/\{(.*)\}/$1/gsx;
	$block 				= parse($self, $block, &grammar, ['_variable_boost', '_var_boost3'], { parent => $parent_class });
	$block 				= parse($self, $block, &grammar, [@{var 'parser_code'}], { parent => $name });
	#$block 				= parse($self, $block, &grammar, ['_var_boost2', '_var_boost3'], { parent => $parent_class });
	#var('wrap_code')->{$name} = $block;
	#$block = '%%%WRAP_CODE_' . $name . '%%%';
	
	$res				= "${anon_code}{ package ${name}; use strict; use warnings; use rise::core::extends 'rise::object::function', '${parent_class}'; use rise::core::function; sub ${s1}${fn_name}${s2}${attr}${s3}{ ${accmod} ${arguments}${s4}${block}}}";
	#$res 				= parse($self, $res, &grammar, [@{var 'parser_code'}], { parent => $parent_class });
	var('wrap_code')->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';
	
	return $res;
}

sub _syntax_prepare_function_args {
	my $accmod			= &accessmod || var('accessmod');
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
	my $function 		= &_function_;
	my $tk_function 	= token 'function';
	$function 			=~ s/\_(\w+)\_/$1/sx;
	
	return $function;
}
#-------------------------------------------------------------------------------------< variable
sub _syntax_nonamedblock {
	my $block			= &block_brace;
	my $unblk_pref		= &unblk_pref;
	
	my $tk_accmod		= token 'accessmod';
	my $tk_var			= token 'variable';
	my $tk_const		= token 'constant';
	#my $kw_var			= keyword 'variable';
	#my $kw_const		= keyword 'constant';
	
	$block 				=~ s/\b(?:$tk_accmod)?\s*($tk_var|$tk_const)/local $1/gsx;
	
	return "${unblk_pref}_UNNAMEDBLOCK_${block}";
	
}

sub _syntax_variable_list {
	my ($self, $rule_name, $confs)			= @_;
	
	my $var_def				= &name_list;
	my $var_init			= &name_list;
	my $op_end				= '';
	
	$var_def				=~ s/(\w+)\,?/<accessmod> <variable> $1;/gsx;
	$var_init				=~ s/(?<!\$)\b(\w+(?:::\w+)*)\b/\$$1/gsx;
	
	$op_end					= " ($var_init) " if !&op_end;
	
	return $var_def.$op_end;
	
	#return "LI: ( <name_list> ) { <accessmod> <variable> _LI_; } IF: ( !'<op_end>' ) {(<name_list>) <op_end>}";
}

sub _syntax_boost_var {
	my ($rule_name, $confs)			= @_;
	my $block			= &all;
	my $parent_class	= $confs->{parent};
	my $parent_name		= $confs->{parent} || 'main';
	my $tk_accmod		= token 'accessmod';
	my $var_list		= var('members')->{$parent_class};
	
	if ($var_list) {
		$var_list			=~ s/\b(?:$tk_accmod)\-(?!variable)\w+\-(\w+)//gsx;
		$var_list			=~ s/\b(?:$tk_accmod)\-variable\-(\w+)/\\b$1\\b/gsx;
		$var_list			=~ s/\\b\s\\b/\\b|\\b/gsx;
		$var_list			=~ s/\s+//gsx;
		#print ">>>>>>>>>>> $var_list \n";
		
		$block 				=~ s/[^\$]($var_list)/\$$1/gsx;
	}
	
	return $block;
}

sub _syntax_var_boost1 {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent} || '';
	
	my $accmod			= &accessmod || var('accessmod');
	my $name			= &name;
	my $tk_accmod		= token 'accessmod';
	my $members_var		= $accmod.'-var-'.$name;
	my $members_list	= var('members')->{$parent_class} || '';
	
	$members_list		=~ s/$tk_accmod//gsx;
	$members_list		=~ s/\-var\-//gsx;
	$members_list		=~ s/\s/\|/gsx;
	$members_list		=~ s/\b\w+\-(?!var)\w+\-\w+(?:::\w+)*//gsx;
	
	#if ($var_list) {
	#	$var_list			=~ s/\b(?:$tk_accmod)\-(?!var)\w+\-\w+(?:::\w+)*//gsx;
	#	$var_list			=~ s/\b(?:$tk_accmod)\-var\-(\w+(?:::\w+)*)/\\b$1\\b/gsx;
	#	#$var_list			=~ s/^\s+(.*?)\s+$/$1/sx;
	#	$var_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
	#	#$var_list			=~ s/\#//gsx;
	#	$var_list			=~ s/\s+//gsx;
	#	
	#	#print ">>>>>>>>>>> *$var_list* \n" if $name =~ m/($var_list)/sx;
	#	
	#}
	
	
	var('members')->{$parent_class} .= ' '.$members_var if $members_var !~ /$members_list/;  # if $accmod ne 'local';
	var('members')->{$parent_class} =~ s/^\s+//;
	
	
	#print "VAR $parent_class->$name | list - ".$members_list." \n";
	
	token 'var_all'		=> $members_list||1;
	rule '_var_boost2'	=> '(_NOT:\$)<var_all>';
	
	#print "VAR $parent_class->$name | list - ".var('members')->{$parent_class}." \n";
	
	return "$accmod <kw_variable> $name";
}

sub _syntax_var_boost2		{ '$<var_all>' }

sub _syntax_var_boost3		{ '<kw_variable> ' }

sub _syntax_var_boost_post1	{ '<kw_variable> ' }

sub _syntax_var_boost_post2	{ '->' }

sub _syntax_prepare_variable {
	my $accmod			= &accessmod || var 'accessmod';
	return "$accmod _<variable><constant>_ <name>; IF: ( !'<op_end>' ) {<name> <op_end>}";
}

sub _syntax_variable {
	my ($self, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var 'accessmod';
	my $name			= &name;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	my $boost_vars		= '';
	my $local_var		= '';
	my $op_end			= '';
	
	my $members_var		= $accmod.'-var-'.$name;
	my $members_list	= var('members')->{$parent_class}||'';
	
	$members_list		=~ s/\s/\|/gsx;
	var('members')->{$parent_class} .= ' '.$members_var if $members_var !~ /$members_list/;  # if $accmod ne 'local';
	var('members')->{$parent_class} =~ s/^\s+//;

	$accmod				= var($accmod.'_var');
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';
	
	$op_end				= " \$$name".&op_end." " if !&op_end;

	#return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<op_end>' ) {<name><op_end>}/;
	#return "my \$$name; $local_var { no warnings; sub $name ():lvalue { \$$name } } $op_end";
	#return "my \$$name; { no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { $accmod\$$name };}$op_end";
	return "my \$$name; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name };$op_end";
}

sub _syntax_variable_boost_OFF {
	my $word			= &word;
	my $sigils			= &sigils;
	my $name			= &name;
	my $regexp			= var('class_var');
	var('class_var')	= '';
	#$content 			=~ s/(?:(?<!(?:var|sub)\s)|(?<!\$|\*)|(?<!\-\>))\b($regexp)\b/\$$1/gsx if $regexp;
	$name 			=~ s/\b($regexp)\b/\$$1/gsx if $regexp;
	return "$word $name";
}

sub _syntax_variable_boost {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	#my $sps				= &spss;
	my $name			= &name;
	#my $args			= &content; #$args ||= '';
	my $this			= '';
	my $tk_accmod		= token 'accessmod';
	my $var_list		= var('members')->{$parent_class}||'';
	my $sigil			= "";
	my $varboost		= "";
	my $members_var		= '-var-'.$name;
	my $members_list	= var('members')->{$parent_class}||'';
	
	$members_list		=~ s/$tk_accmod//gsx;
	$members_list		=~ s/\-var\-//gsx;
	$members_list		=~ s/\s/\|/gsx;
	
	#if ($members_list && $members_var =~ /$members_list/) {
	#	$sigil				= "\$" if $members_var !~ /__VARBOOSTED__/;
	#	$varboost			= "__VARBOOSTED__";
	#	#print "VAR $parent_class->$name | fnlist - *$members_list* \n";
	#}
	
	if ($members_list && $name =~ m/\b(?:$members_list)\b/sx) {
		$sigil				= "\$";
		$varboost			= "__VARBOOSTED__";
		#print "VAR $parent_class->$name | fnlist - *$members_list* \n";
	}
	
	#if ($var_list) {
	#	$var_list			=~ s/\b(?:$tk_accmod)\-(?!var)\w+\-\w+(?:::\w+)*//gsx;
	#	$var_list			=~ s/\b(?:$tk_accmod)\-var\-(\w+(?:::\w+)*)/\\b$1\\b/gsx;
	#	#$var_list			=~ s/^\s+(.*?)\s+$/$1/sx;
	#	$var_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
	#	#$var_list			=~ s/\#//gsx;
	#	$var_list			=~ s/\s+//gsx;
	#	
	#	#print ">>>>>>>>>>> *$var_list* \n" if $name =~ m/($var_list)/sx;
	#	
	#}

	
	#$name =~ s/($var_list)/\$$1/sx;

	#return "${name}";
	#return "${sps}${sigil}${name}";
	return "${sigil}${name}";
	#return "${sigil}${name}${varboost}";
	#return "${sigil}${varboost}${name}";
}

sub _syntax_variable_boost_post {''}
#-------------------------------------------------------------------------------------< constant
sub _syntax_constant {
	my ($self, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var 'accessmod';
	my $name			= &name;
	my $sname			= $name;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	my $local_var		= '';
	
	var('members')->{$parent_class} .= ' '.$accmod.'-const-'.$name if $accmod ne 'local';
	var('members')->{$parent_class} =~ s/^\s+//;
	
	if (&accessmod eq 'local') {
		$accmod			= '';
		$local_var		= "local *$name; ";
	}
	
	#$name				=~ s/\w+(?:::\w+)*::(\w+)/$1/sx;
	#$sname				= $name;
	#$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;
	$accmod				= var($accmod.'_var');
	$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

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
	my ($self, $rule_name, $confs)			= @_;
	my $name			= &name;
	#my $parent_class	= $confs->{parent};
	my $parent_name		= $confs->{parent};
	my $block 			= &block_brace;
	
	my ($s1,$s2,$s3,$s4) = (&sps1,&sps2,&sps3,&sps4);
	
	return '' if !$name;

	$name				= $parent_name . '::' . $name if $parent_name;
	
	$block 				=~ s/\{(.*)\}/$1/gsx;
	
	#print ">>>>>> parent_class - ". &name ." | name - ".&name."\n";
	
	$block 				= parse($self, $block, grammar, [@{var 'parser_namespace'}], { parent => $name });
	
	#$block 				= parse($self, $block, grammar, ['_namespace'], { parent => $name });
	#$block 				= parse($self, $block, grammar, ['_class'], { parent => $name });
	#$block				= parse($self, $block, grammar, ['_abstract'], { parent => $name });
	#$block				= parse($self, $block, grammar, ['_interface'], { parent => $name });
	
	
	return "{ package $name;$s1 use strict; use warnings;$s2 $s3 $s4$block}"
	#return "{ package <name>; use strict; use warnings;"
}

#-------------------------------------------------------------------------------------< class

sub _syntax_prepare_class {
	my $ns				= var('namespace');
	my $accmod			= &accessmod;
	my $object			= &_class_type_;
	my $name			= &name;
	my $args_attr		= &args_attr;
	my $extends			= '';
	my $kw_extends		= keyword 'inherits';
	my $tk_name_list	= token 'name_list';
	my ($parent_name)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx; $parent_name ||= '';
	my $comma			= '';
	
	$comma		= ',' if $args_attr =~ s/\_$kw_extends\_\s*($tk_name_list)/$1/gsx;
	
	$extends			= 'rise::object::class';
	$extends			.= ", $parent_name" if $parent_name;
	$extends			.= $comma;

	$args_attr			= "_<kw_inherits>_ $extends $args_attr" if $extends;

	return "${accmod}...prepared_class...<name>...${args_attr}...{";
}

sub _syntax_class {
	return '' if !&name;
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod || var 'accessmod';
	return __object($self, 'class', $rule_name, $confs);
}

sub _syntax_class_OFF2 {
	
	return '' if !&name;
	
	my ($self, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var 'accessmod';
	my $name			= &name;
	my $args_attr		= &content;
	my $block 			= &block_brace;
	
	my $base_class		= "'rise::object::class'";
	my $parent_class	= $confs->{parent};
	
	my $list_extends	= '';
	my $list_implements	= '';
	my $extends			= '';
	my $implements		= '';
	
	if ($parent_class) {
		var('members')->{$parent_class} .= ' '.$accmod.'-class-'.$name;
		var('members')->{$parent_class} =~ s/^\s+//;
		$name				= $parent_class . '::' . $name;
		$list_extends		= ",'$parent_class'";
	}
	
	$accmod				= var($accmod.'_class');
	$accmod				= eval $accmod if $accmod;		
	
	$list_extends		.= __list_extends($self, $args_attr);
	$extends			= "use rise::core::extends ${base_class}${list_extends};";	
	
	################# reset function list from new class #####################
	#var('class_func')		= '';
	#var('class_var')		= '';
	#token func_all			=> 1;
	#rule _function_method	=> q/<func_all>\((NOT:__PACKAGE__)[<content>]\)/;
	##########################################################################

	#print ">>>>>> accmod - $accmod | parent_class - $parent_name | name - $name\n";
	#print ">>>>>> class_name - $name | func_list - ".var('class_func')."\n";

	$block 				=~ s/\{(.*)\}/$1/gsx;
	$block 				= parse($self, $block, &grammar, [@{var 'parser_class'}], { parent => $name });
	
	#push @{&var('wrap_code')}, $block;
	#$block = '%%%WRAP_CODE_' . sprintf("%03d", $#{&var('excluding')}) . '%%%';
	
	var('wrap_code')->{$name} = $block;
	$block = '%%%WRAP_CODE_' . $name . '%%%';
	
	return "{ package ${name}; use strict; use warnings;".&sps1.$extends.&sps2.$accmod.&sps3 . __object_header('class', $name || '') . &sps4.$block."}";
}

sub _syntax_class_OFF {
	my $accmod			= &accessmod || var 'accessmod';
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
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	
	my $comma			= '';
	
	#$accmod				= ' _'.uc($accmod).'_CLASS_;';
	$accmod				= var($accmod.'_class');
	
	#$parent_class		= "'rise::object::class'" if &_class_type_ eq '_base_';
	
	($list_extends)			= $args_attr =~ m/\_extends\_\s*($tk_name_list)/gsx;
		$list_extends			=~ s/\s*\,\s*/','/gsx if $list_extends;
		$list_extends			= "'$list_extends'" if $list_extends;
		$list_extends			||= '';
		#$comma					= ',' if $list_extends;
		#$list_extends			= $parent_class . $comma . $list_extends;
		$extends				= " use rise::core::extends $list_extends;";
		
	($list_implements)		= $args_attr =~ m/\_implements\_\s*($tk_name_list)/gsx;
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
	
	return "{ package <name>;...${accmod} use strict; use warnings;...${extends}...${implements} sub super { \$<name>::ISA[1] } sub <kw_self> { '<name>' } sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
	
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

sub __list_extends {
	my $self					= shift;
	my $args_attr				= shift;
	my $tk_name_list			= token 'name_list';
	my $list_extends			= '';
	my $list_implements			= '';
	my $comma					= '';
	my $tk_extends				= token 'inherits';
	my $tk_implements			= token 'implements';
	my $sps						= '';
	#my $err						= '';
	
	#print ">>> args_attr - $args_attr\n";
	
	#($list_extends)				= $args_attr =~ m/$tk_extends\s*($tk_name_list)/gsx;
	#($list_implements)			= $args_attr =~ m/$tk_implements\s*($tk_name_list)/gsx;	
	
	$args_attr					=~ s/$tk_extends\s+(?<ext>$tk_name_list)//sx;		$list_extends		= $+{ext} || '';
	$args_attr					=~ s/$tk_implements\s+(?<imp>$tk_name_list)//sx;	$list_implements	= $+{imp} || '';
	$args_attr					=~ s/(?<sps>\s*)//; $sps = $+{sps};
	
	#print ">>> ext - $list_extends | impl - $list_implements\n";
	return ";${sps}__PACKAGE__->extends_error" if $args_attr;
	
	$comma						= ',' if $list_extends;
	$list_extends				.= $comma . $sps . $list_implements if $list_implements && $self->{debug};
	if ($list_extends) {
		$list_extends				=~ s/(?<scomma>\s*\,\s*)/'$+{scomma}'/gsx;
		$list_extends				=~ s/\s?\,\s?/,/gsx;
		$list_extends				= ",'$list_extends'";
	}
	
	$list_extends				||= '';
		
	return $list_extends;
}

#-------------------------------------------------------------------------------------< interface

sub _syntax_prepare_interface {

	
	my $accmod			= 'protected'; #&accessmod || var 'accessmod';
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
	
	$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)/BEGIN { __PACKAGE__->set_interface('$1-<kw_constant>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)/BEGIN { __PACKAGE__->set_interface('$1-<kw_variable>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)/BEGIN { __PACKAGE__->set_interface('$1-<kw_function>-$2'); }/gsx;
	
	#$block				=~ s/my\s+\$(\w+(?:\:\:\w+)*)\;\s*\{\s*no\swarnings\;\s*sub\s+\1\s*\(\)\:lvalue\s*\{\s*\_\_PACKAGE\_\_\-\>\_\_(\w+)\_VAR\_\_\;\s*\$\1\s*\}\s*\}/'$2-variable-$1' => 1,/gsx;
		
			 
	
	return "${accmod}..._<interface>_...<name>...<content>...{$block}";
	#return "${accmod}... <kw_interface> ...<name>...<content>...{$block}";
}

sub _syntax_prepare_interface_post {'<kw_interface>'}

sub _syntax_interface {
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod || 'protected';
	return __object($self, 'interface', $rule_name, $confs);
}

sub _syntax_interface_set {
	my ($self, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var 'accessmod';
	my $object_members	= &object_members;
	my $name			= &name;
	my $op_end			= &op_end;
	
	return "BEGIN { __PACKAGE__->set_interface('${accmod}-${object_members}-${name}'); }";
}

#-------------------------------------------------------------------------------------< abstract

sub _syntax_prepare_abstract {

	my $accmod			= 'protected'; #&accessmod || var 'accessmod';
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
			 
	#$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_constant>-$2');/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_variable>-$2');/gsx;
	#$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/__PACKAGE__->set_interface('$1-<kw_function>-$2');/gsx;
	
	$block				=~ s/($tk_accessmod)\s*$tk_constant\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_constant>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_variable\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_variable>-$2'); }/gsx;
	$block				=~ s/($tk_accessmod)\s*$tk_function\s*($tk_name)\;/BEGIN { __PACKAGE__->set_interface('$1-<kw_function>-$2'); }/gsx;
	
	return "${accmod}..._<abstract>_...<name>...<content>...{$block}";
	#return "${accmod}...<kw_abstract>...<name>...<content>...{$block}";
}

sub _syntax_prepare_abstract_post {'<kw_abstract>'}

sub _syntax_abstract {
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod || 'protected';
	return __object($self, 'abstract', $rule_name, $confs);
}

#-------------------------------------------------------------------------------------< object

sub __object {
	
	return '' if !&name;
	#return __object('class', $confs);
	my ($self, $object, $rule_name, $confs)			= @_;
	
	#my $accmod			= &accessmod || var 'accessmod';
	my $accmod			= $confs->{accessmod};
	my $name			= &name;
	my $args_attr		= &content;
	my $block 			= &block_brace;
	
	my ($sps1,$sps2,$sps3,$sps4) = (&sps1,&sps2,&sps3,&sps4);
	
	my $base_class		= "'rise::object::$object'";
	my $parent_class	= $confs->{parent} || '';
	
	my $list_extends	= '';
	my $list_implements	= '';
	my $extends			= '';
	my $implements		= '';
	my $res				= '';
	
	#$accmod				= 'protected' if $object =~ /abstract|interface/;
	
	
	if ($parent_class) {
		var('members')->{$parent_class} .= ' '.$accmod.'-'.$object.'-'.$name;
		var('members')->{$parent_class} =~ s/^\s+//;
		$name				= $parent_class . '::' . $name;
		$list_extends		= ",'$parent_class'";
	}
	
	$list_extends		.= __list_extends($self, $args_attr);
	$extends			= "use rise::core::extends ${base_class}${list_extends}; ";	
	
	$accmod				= var($accmod.'_'.$object);
	$accmod				= eval $accmod if $accmod;		
	
	################# reset function list from new class #####################
	#var('class_func')		= '';
	#var('class_var')		= '';
	#token func_all			=> 1;
	#rule _function_method	=> q/<func_all>\((NOT:__PACKAGE__)[<content>]\)/;
	##########################################################################

	#print ">>>>>> accmod - $accmod | parent_class - $parent_class | name - $name\n";
	#print ">>>>>> class_name - $name | func_list - ".var('class_func')."\n";

	$block 				=~ s/\{(.*)\}/$1/gsx;
			 
	#$block 				= parse($self, $block, &grammar, ['_variable_boost', '_var_boost3'], { parent => $parent_class });
	$block 				= parse($self, $block, &grammar, [@{var 'parser_'.$object}], { parent => $name });
	
	#var('excluding_class_code')->{$name} = $block;
	#$block = '%%%CLASS_CODE_' . $name . '%%%';
	#
	#return "{ package ${name}; use strict; use warnings;".&sps1.$extends.&sps2.$accmod.&sps3 . __object_header($object, $name || '') . &sps4.$block."}";
	
	$res				= "{ package ${name};".$sps1."use strict; use warnings;". $sps2 . $extends . $sps3 . $accmod . __object_header($self, $object, $name || '') . $sps4.$block."}";
	var('wrap_code')->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';
	
	return $res;
}

sub __object_OFF {
	my ($self, $object, $rule_name, $confs)			= @_;
	
	my $accmod			= &accessmod || var 'accessmod';
	#my $object			= &_object_; $object =~ s/\_(\w+)\_/$1/sx;
	my $name			= &name;
	my $sname			= &name;
	my $args_attr		= &content;
	my $block 			= &block_brace;
	
	my $base_class		= "'rise::object::$object'";
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent};
	
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	
	#my $class_ext		= '';
	#my $class_iface		= '';
	
	my $list_extends	= '';
	my $list_implements	= '';
	my $extends			= '';
	my $implements		= '';
	
	my $comma			= '';
	
	
	var('class_func')		= '';
	var('class_var')		= '';
	
	return '' if !$name;

	$name				= $parent_class . '::' . $name if $parent_class;
	$sname				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	
	$block 				=~ s/\{(.*)\}/$1/gsx;
	#$block 				= parse($self, $block, &grammar, '_class', { parent => $name }) if $object eq 'class';	
	
	#$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';
	#$parent_name		||= '';
	
	$list_extends		= ",'$parent_class'" if $parent_class;

	print ">>>>>> accmod - $accmod | parent_class - $parent_class | name - $name\n";
	
	$accmod				= var($accmod.'_'.$object);
	$accmod				= eval $accmod if $accmod;

	$list_extends		= __list_extends($self, $args_attr);

	$extends			= "use rise::core::extends ${base_class}${list_extends};";
	
	#return "{ package <name>; use strict; use warnings;...${extends}...${accmod}...__PACKAGE__->interface_confirm; sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
	return "{ package ${name}; use strict; use warnings;...${extends}...${accmod}..." . __object_header($object, $name || '') . "...${block} }";
}

sub _syntax_object {
	my $accmod			= &accessmod || var 'accessmod';
	my $object			= &_object_; $object =~ s/\_(\w+)\_/$1/sx;
	my $name			= &name;
	my $sname			= $name;
	my $args_attr		= &content;
	my $list_extends	= '';
	my $list_implements	= '';
	my $base_class		= "'rise::object::$object'";
	#my $class_ext		= '';
	#my $class_iface		= '';
	my $extends			= '';
	my $implements		= '';
	my $tk_name			= token 'name';
	my $tk_name_list	= token 'name_list';
	my ($parent_class)	= $name =~ m/(\w+(?:::\w+)*)::\w+/gsx;
	my $comma			= '';
	my $parent_name		= $parent_class || 'main';
	
	var('class_func')		= '';
	var('class_var')		= '';
	
	return '' if !$name;
	
	$sname				=~ s/\w+(?:::\w+)*::(\w+)/$1/gsx;
	
	$parent_class		= ",'$parent_class'" if $parent_class;
	$parent_class 		||= '';

	#print ">>>>>> accmod - $accmod | base_class - $base_class | name - $name\n";
	
	$accmod				= var($accmod.'_'.$object);
	$accmod				= eval $accmod if $accmod;

	$list_extends		= list_extends($args_attr);

	$extends			= "use rise::core::extends $base_class$parent_class$list_extends;";
	
	#return "{ package <name>; use strict; use warnings;...${extends}...${accmod}...__PACKAGE__->interface_confirm; sub super { \$<name>::ISA[1] } sub this { '<name>' } sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
	return "{ package <name>; use strict; use warnings;...${extends}...${accmod}..." . __object_header($object, $name || '') . "...";
}

sub __object_header {
	my $self			= shift;
	my $obj_type		= shift;
	my $name			= shift;
	my $header			= {
		class		=> " sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }",
		abstract	=> "",
		interface	=> " __PACKAGE__->interface_join;"
	};
	
	if ($self->{debug}) {
		$header->{class}	.= " __PACKAGE__->interface_confirm; sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
		$header->{abstract} .= " __PACKAGE__->interface_join;";
	}
	
	return $header->{$obj_type};
}

sub _syntax_prepare_name_object {
	
	my $accmod			= &accessmod || var 'accessmod';
	my $object			= &object;
	my $name			= &name;
	my $args_attr		= &args_attr;
	my $block			= &block_brace;
	my $base			= '';
	my $kw_class		= keyword 'class';
	my $object_type		= $object;
	
	$object_type		= 'base' if $object eq $kw_class;

	var('anon_fn_count') = 0;

	#$name				= var('namespace').'::'.$name if var('namespace');

	$block 				= _syntax_prepare_name_object_helper($name, $block);
	#$block 				= parse($self, $block, &grammar);
	
	#print ">>>> $name - $args_attr\n";

	return "_object_${object_type}_ ${accmod}... _<object>_ ...<name>...<args_attr>...${block}";
}

sub _syntax_prepare_name_object_helper {
	my ($name, $block) = @_;

	my $accessmod;
	my $objname;
	
	my $tk_accessmod	= token 'accessmod';
	my $tk_object		= token 'object';
	my $tk_name			= token 'name';
	my $tk_args_attr	= token 'args_attr';
	my $tk_content		= token 'content';
	my $tk_block		= token 'block_brace';

	$block 				=~ s{
			\b(?<accessmod>$tk_accessmod)?
				(?<sps1>\s*)(?<object>$tk_object)
				(?<sps2>\s*)(?<name>$tk_name)?
				(?<sps3>\s*)(?<args_attr>$tk_args_attr)?
				(?<sps4>\s*)(?<block_brace>$tk_block)?
		}{
			$accessmod = $+{accessmod}||var('accessmod');
			var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$+{name} . ' ' if $accessmod ne 'local';
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
	#		$accessmod = $+{accessmod}||var('accessmod');
	#		$objname=$+{name};if(!$objname){var('anon_fn_count')++;$objname=var('anon_code_pref').sprintf("%05d", var('anon_fn_count'));}
	#		var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#		$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{args_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#	}gsxe;
	
	#$block 				=~ s{
	#	\b(?<accessmod>$tk_accessmod)?\s*(?<object>$tk_object)\s*(?<name>$tk_name)?\s*(?<args_attr>$tk_args_attr)?\s*(?<block_brace>$tk_block)?
	#}{
	#	$accessmod = $+{accessmod}||var('accessmod');
	#	$objname=$+{name};if($objname eq '_ANON_CODE_'){var('anon_fn_count')++;$objname.=sprintf("%05d", var('anon_fn_count'));}
	#	var('members')->{$name} .= $accessmod.'-'.$+{object}.'-'.$objname . ' ' if $+{name};
	#	$accessmod.' _'.$+{object}.'_ '.$name.'::'.$objname.' '.($+{args_attr}||'').' '._syntax_prepare_object_name_helper($name.'::'.$objname, $+{block_brace}||'')
	#}gsxe;
	
	return $block;
}

sub _syntax_op_dot {'->'}

sub _syntax_optimise4 { ';' }
sub _syntax_optimise5 { ' ' }
sub _syntax_optimise6 { '' }

1;
