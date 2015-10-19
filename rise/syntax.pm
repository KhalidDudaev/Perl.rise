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
	var('local_var_count')			= 0;
	var('anon_code_pref')			= 'ACODE';
	#var('class_blocknum')			= undef;
	var('members')					= {};
	var('exports')					= {};
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

	#var('private_var')				= q/'__PACKAGE__->private_var("' . $parent_class . '", "' . $name .'");'/;
	#var('protected_var')			= q/'__PACKAGE__->protected_var("' . $parent_class . '", "' . $name .'");'/;
	#var('public_var')				= '';

	var('private_var')				= q{'__PACKAGE__->__RISE_ERR(\'PRIVATE_VAR\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);'};
	var('protected_var')			= q/'__PACKAGE__->__RISE_ERR(\'PROTECTED_VAR\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');'/;
	var('public_var')				= q/''/;
	var('local_var')				= q/''/;

	#var('private_code')				= q/'__PACKAGE__->private_code("' . $parent_class . '", "' . $name .'");'/;
	#var('protected_code')			= q/'__PACKAGE__->protected_code("' . $parent_class . '", "' . $name .'");'/;
	#var('public_code')				= q/''/;

	var('private_code')				= q{'__PACKAGE__->__RISE_ERR(\'PRIVATE_CODE\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);'};
	var('protected_code')			= q/'__PACKAGE__->__RISE_ERR(\'PROTECTED_CODE\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');'/;
	var('public_code')				= q/''/;

	var ('parser_variable')			= [
		'_variable_boost1',
		'_variable_boost2',
		'_variable_boost3',
		'_variable',
		'_constant',
	];

	var ('parser_function')			= [
		'_function',
		'_function_method',
		#@{var 'parser_variable'},
	];

	var ('parser_code')				= [

		'_foreach',
        '_foreach_var',
		'_for',
        # '_for_foreach_array',
		'_while',
		'_regex_match',
		'_regex_replace',

		'_function_defs',
		'_variable_list',


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
		'_comma_quarter',
		'_namespace',
		'_inject',
		'_using',
		'_class',
		'_abstract',
		'_interface',
	];

	var ('parser__')				= [

		'_commentC',
		'_excluding',


		'_nonamedblock',
		@{var 'parser_namespace'},
		'_unwrap_code',

		'_op_regex',
		# '_op_scalar',

        # '_op_array',
		# '_op_hash',

        '_op_sort_blockless',
        '_op_array_block',
        '_op_array_hash',

		# '_op_array1',
		# '_op_array2',
		# '_op_array21',
		# '_op_array3',
		# '_op_reverse',
        # '_context',
		'_op_dot',
		'_optimize4',

		'_optimize6',
		'_optimize7',
		'_optimize8',
		'_function_method_post1',
		'_function_method_post2',
		#'_function_boost_post1',
		#'_function_boost_post2',
		#'_variable_boost_post',
		#'_optimize5',

		'_including',
		'_optimize9'


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
	keyword export					=> 'export';

	#keyword numeric					=> 'numeric';
	#keyword string					=> 'string';
	#keyword array					=> 'array';
	#keyword hash					=> 'hash';

	keyword self					=> 'self';
    keyword context				    => '_';

	keyword for						=> 'for';
	keyword foreach					=> 'foreach';
	keyword while					=> 'while';

	keyword regex_kw1				=> 'regex';
	keyword regex_kw2				=> 're';

	keyword regex_match1				=> 'm';
	keyword regex_match2				=> 'match';

	keyword regex_replace1			=> 's';
	keyword regex_replace2			=> 'r';
	keyword regex_replace3			=> 'replace';

	keyword re_match1				=> 're.m';
	keyword re_match2				=> 're.match';
	keyword re_match3				=> 'regex.match';
	keyword re_repl1				=> 're.s';
	keyword re_repl2				=> 're.replace';
	keyword re_repl3				=> 'regex.replace';

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
	token export					=> keyword 'export';

	token re_match1					=> keyword 're_match1';
	token re_match2					=> keyword 're_match2';
	token re_match3					=> keyword 're_match3';
	token re_repl1					=> keyword 're_repl1';
	token re_repl2					=> keyword 're_repl2';
	token re_repl3					=> keyword 're_repl3';

	token regex_kw1					=> keyword 'regex_kw1';
	token regex_kw2					=> keyword 'regex_kw2';

	token regex_match1				=> keyword 'regex_match1';
	token regex_match2				=> keyword 'regex_match2';

	token regex_replace1			=> keyword 'regex_replace1';
	token regex_replace2			=> keyword 'regex_replace2';
	token regex_replace3			=> keyword 'regex_replace3';

	token regex_kw					=> q/regex_kw1|regex_kw2/;
	token regex_kw_match				=> q/regex_match1|regex_match1/;
	token regex_kw_replace			=> q/regex_replace1|regex_replace2|regex_replace3/;

	token regex_match				=> q/re_match1|re_match2|re_match3/;
	token regex_replace				=> q/re_repl1|re_repl2|re_repl3/;

	#token regex_match				=> q/(?:regex_kw)\.(?:regex_kw_match)/;
	#token regex_replace				=> q/(?:regex_kw)\.(?:regex_kw_replace)/;

	token regex_mods				=> q/word/;
	token regex_sorce				=> q/self_name/;
	token regex_pattern_txt			=> q/%%%TEXT_ number %%%/;
	token regex_pattern_var			=> q/self_name/;
	token regex_expr_txt			=> q/%%%TEXT_ number %%%/;
	token regex_expr_block			=> q/block_brace/;
	token regex_pattern_block		=> q/(?<REG_PATTERN_LEFT>%%%REGEXBLOCK\")|(?<REG_PATTERN_RIGHT>\"REGEXBLOCK%%%)/;
	#token regex_expr_function		=> q/self_name\s*code_args/;

	token comma_long_short			=> q/\=\>|\,/;
	token not						=> q/\!/;

	#token numeric					=> keyword 'numeric';
	#token str						=> keyword 'string';
	#token array						=> keyword 'array';
	#token hash						=> keyword 'hash';

	token variable_type				=> q/\:\s*\w+(?:\s*block_paren)?/;

	token self						=> keyword 'self';
    token context                   => keyword 'context';
	token for						=> keyword 'for';
	token foreach					=> keyword 'foreach';
	token while 					=> keyword 'while';

	token '"'						=> '\"';
	token comma						=> q/\,/;

	token before					=> q/^all/;
	token after						=> q/all$/;
	#token content					=> q/string+/;
	token content					=> q/all?/;
	token content1					=> q/all?/;
	token content2					=> q/all?/;

	token string					=> q/(?^s:.(?^:all))/;
	token string1					=> q/(?^s:.(?^:all))/;
	token string2					=> q/(?^s:.(?^:all))/;

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

	token name_ex					=> q/ident(?:(?:::|\.)ident)*/;

	#token name						=> q/word(?:\:\:word)*/;
	token name						=> q/\b(?:ident(?:(?:::|\.)ident)*)\b/;
	token name_type					=> q/\b(name(\s*:\s*ident)?)\b/;
	#token name						=> q/(?:\b[^\d\W]\w*\b)(?:::(?:\b[^\d\W]\w*\b))*/;

	#token name						=> q/[^\d\s](?:word\:\:)*word/;
	token name_list					=> q/name(?:\s*\,\s*name)*/;
	token name_list_wtype			=> q/name_type(?:\s*\,\s*name_type)*/;
	token func_args					=> q/name_type(\s*\=\s*content)?(?:\s*\,\s*name_type(\s*\=\s*content)?)*/;
	token namestrong				=> q/[^\d\W][\w:]+[^\W]/;
	token name_ext					=> q/name/;
	token name_impl					=> q/name_list/;

	#token comment					=> q`(?<![$@%])[#] nnline*`;
	#token comment					=> q`(?<![$@%])(?:\#|//) nnline*`;
	token comment_Perl				=> q`(?<![$@%])\# nnline*`;
	token comment_C					=> q`(?<![msqr\$\@\%\\\])\/\/ nnline*`;
	#token comment					=> q/comment_Perl|comment_C/;
	token comment					=> q/comment_Perl/;

	#token comment					=> q/(?<![$@%])\#string/;
	#token comment					=> q/(?<![$@%])\#string\n/;
	#token comment2					=> q/(?<![\$\@\%])\#.*?\n/;


	token for_each					=> q/\b(?:foreach|for)\b/;

	token accessmod_class			=> q/private|protected|public/;
	token accessmod					=> q/local|export|private|protected|public/;
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

	token excluding					=> q/POD|DATA|END|comment|regex|text/;
	token including					=> q/%%%TEXT_ number %%%/;
	token wrap_code					=> q/%%%CLASS_CODE_ name_ex %%%/;


	token EOP 						=> q/(?:\n\n|\Z)/;
	token CUT 						=> q/(?:\n=cut.*EOP)/;
	token POD 						=> q/(?:^=(?:head[1-4]|item).*?CUT|^=pod.*?CUT|^=for.*?CUT|^=begin.*?CUT)/;
	token DATA 						=> q/(?:^__DATA__\r?\n.*)/;
	token END 						=> q/(?:^__END__\r?\n.*)/;

	#token text						=> q/(?:qtext|textqq|textqw)/;
	#token text						=> q/(?:qtext|textqq|textqw|qregex)/;
	token text						=> q/(?:qtext|textqq|textqw)/;
	#token textqq					=> q/(?:''|'content[^\\\]')/;
	#token textqw					=> q/(?:""|"content[^\\\]")/;
	#token textqq					=> q/(?:\'content[^\\\']?\')/;
	#token textqw					=> q/(?:\"content[^\\\"]?\")/;

########################################################################################
	# token textqq					=> q/(?:\'[^\\\]*?\' | \'[^\']content[^\\\]\')/;
	# token textqw					=> q/(?:\"[^\\\]*?\" | \"[^\"]content[^\\\]\")/;
    # token textqa					=> q/(?:\`[^\\\]*?\` | \`[^\`]content[^\\\]\`)/;

    token textqq					=> q/(?:\'\'|\'(?(?<!\\\)[^\']|.)*?[^\\\]\')/;
	token textqw					=> q/(?:\"\"|\"(?(?<!\\\)[^\"]|.)*?[^\\\]\")/;
    token textqa					=> q/(?:\`\`|\`(?(?<!\\\)[^\`]|.)*?[^\\\]\`)/;
########################################################################################

	#token textqq					=> q/(?:\'(?:[^\\\']*(?:\\.[^\\\']*)*)\')/;
	#token textqw					=> q/(?:\"(?:[^\\\"]*(?:\\.[^\\\"]*)*)\")/;

	token regex						=> q/qregex_s|qregex_m/;
	#token qtext 					=> q/qtext_paren|qtext_brace|qtext_square|qtext_angle|qtext_slash|qtext_char/;
	#token qregex					=> q/[=!]\~\s*(?:\b(?:s\s*|m\s*)\b)?(?:in_paren|in_brace|in_square|in_angle|in_slash|in_char)/;
	#token qregex					=> q/(?:\s[^\n\r])+(?:\bs\b|(?<REGEX_MATH>\bm\b))\s*
	#	(?:\\
	#		|in_paren
	#		|in_brace
	#		|in_square
	#		|in_angle
	#		|in_slash_regex
	#	)
	#/;

	token qregex_m					=> q/(?<REGEX_MATH>\bm\b)\s*
		(?:REGEXNOMATH
			|in_paren
			|in_brace
			|in_square
			|in_angle
			|in_slash
		)
	/;

	token qregex_s					=> q/\bs\b\s*
		(?:REGEXNOMATH
			|in_paren \s* in_paren
			|in_brace \s* in_brace
			|in_square \s* in_square
			|in_angle \s* in_angle
			|in_slash_regex
		)
	/;

	token qtext						=> q/qvar\s*(?:in_paren|in_brace|in_square|in_angle|in_slash|in_char)/;
	token qvar						=> q/\bq[qwr]?\b/;
	token qquote					=> q/qvar/;

########################################################################################
	# token in_paren					=> q/(?:\(content[^\)]\))/;
	# token in_brace					=> q/(?:\{content[^\}]\})/;
	# token in_square					=> q/(?:\[content[^\]]\])/;
	# token in_angle					=> q/(?:\<content[^\>]\>)/;
	# token in_slash					=> q/(?:\/content[^\/]\/)/;

#    token in_paren					=> q/(?:\(\)|\((?(?<!\\\)[^\(\)]|.)*?[^\\\]\))/;
#	token in_brace					=> q/(?:\{\}|\{(?(?<!\\\)[^\{\}]|.)*?[^\\\]\})/;
#	token in_square					=> q/(?:\[\]|\[(?(?<!\\\)[^\[\]]|.)*?[^\\\]\])/;
#	token in_angle					=> q/(?:\<\>|\<(?(?<!\\\)[^\<\>]|.)*?[^\\\]\>)/;
#	token in_slash					=> q/(?:\/\/|\/(?(?<!\\\)[^\/]|.)*?[^\\\]\/)/;

    token in_paren					=> q/(?:\(\)|\((?(?<!\\\)[^\(\)]|.)*?(?<!\\\)\))/;
	token in_brace					=> q/(?:\{\}|\{(?(?<!\\\)[^\{\}]|.)*?(?<!\\\)\})/;
	token in_square					=> q/(?:\[\]|\[(?(?<!\\\)[^\[\]]|.)*?(?<!\\\)\])/;
	token in_angle					=> q/(?:\<\>|\<(?(?<!\\\)[^\<\>]|.)*?(?<!\\\)\>)/;
	token in_slash					=> q/(?:\/\/|\/(?(?<!\\\)[^\/]|.)*?(?<!\\\)\/)/;

########################################################################################


	token in_slash_regex			=> q/(?:\/\/\/|\/(?:(?(?<!\\\)[^\/]|.)*?[^\\\]\/){2})/;
	token in_slash_regex2			=> qr/ (?:\/content\/(?<!\\\/)content\/(?<!\\\/)) /sx;
	token in_slash_regex3			=> qr/ (?:\/content(?!\\\/)\/content(?!\\\/)\/) /sx;
	token in_slash_regex4			=> qr/ (?:\/content[^\\]\/content[^\\]\/) /sx;
	token in_char					=> q/(?:(?<qchar>[\W\w])content(?!\\\(?&qchar))(?&qchar))/;

	token qtext_paren				=> q/(?:q[qwr]?\s*\(content[^\\\)]\))/;
	token qtext_brace				=> q/(?:q[qwr]?\s*\{content[^\\\}]\})/;
	token qtext_square				=> q/(?:q[qwr]?\s*\[content[^\\\]]\])/;
	token qtext_angle				=> q/(?:q[qwr]?\s*\<content[^\\\>]\>)/;
	token qtext_slash				=> q/(?:q[qwr]?\s*\/content[^\\\/]\/)/;
	token qtext_char				=> q/(?:q[qwr]?\s*(?<qchar>[\W\w])content(?!\\\(?&qchar))(?&qchar))/;

	token block_paren				=> q/(?<BLOCK_PAREN>\((?>[^\(\)]+|(?&BLOCK_PAREN))*\))/; # (...)
	token block_brace				=> q/(?<BLOCK_BRACE>\{(?>[^\{\}]+|(?&BLOCK_BRACE))*\})/; # {...}
	token block_square				=> q/(?<BLOCK_SQUARE>\[(?>[^\[\]]+|(?&BLOCK_SQUARE))*\])/; # [...]
	token block_angle				=> q/(?<BLOCK_ANGLE>\<(?>[^\<\>]+|(?&BLOCK_ANGLE))*\>)/; # <...>
	token block_slash				=> q/(?<BLOCK_SLASH>\/(?>[^\/]+|(?&BLOCK_SLASH))*\/)/; # /.../


	token unblk_pref				=> q/[\}\;]\s*/;

	#token brackets_brace			=> q/(?:\{(?!\s)|(?<!\s)\})/;

	token condition					=> q/content/;
	token STATEMENT					=> q/content/;
	token THEN						=> q/content/;
	token ELSE						=> q/content/;

	token op_dot					=> q/(?<! [\s\W] ) \. (?! [\s\d\.] )/;
	#token op_dot					=> q/(?:[^\s])\.(?:[^\s\d\.])/;

	# token self_name					=> q/(?:this\.)*name/;
    token self_name					=> q/(?:this\.)*name(?:\.?\{[-+]?\w+\})*/;

	token op_regex					=> q/[=!]\~/;
	token op_regex_m				=> q/[=!]\~\s*m/;
	token op_regex_m				=> q/[=!]\~\s*s/;

	token op_scalar					=> q/\b(?:split)\b/;
    token op_array					=> q/\b(?:map|grep|join|reverse|sort|pop|push|shift|unshift|size|slice)\b/;
	token op_hash					=> q/\b(?:keys|values|each)\b/;
	token op_reverse				=> q/\b(?:reverse)\b/;

	# token op_array1					=> q/\b(?:pop|push|shift|slice|unshift|sort)\b/;

    token op_sort_blockless         => q/\bsort\b(?!\s*\{)/;
    token op_array_block            => q/\b(?:map|grep|sort)\b/;
    token op_array_hash             => q/\b(?:keys|values|each|map|grep|join|reverse|pop|push|shift|unshift|size|splice)\b (?! \s+ [\@\%] )/;

    token op_ahref_expr			    => q/\b(?:keys|values|each|reverse|pop|shift|size)\b/;

    token op_arr2arr_sort			=> q/\b(?:sort)\b/;

    token op_arr2scl    			=> q/\b(?:join|push|unshift)\b/;


	token op_array2					=> q/\b(?:pop|shift|slice|unshift|sort)\b/;
	# token op_array2					=> q/\b(?:grep|map|sort)\b/;
	token op_array3					=> q/\b(?:join)\b/;

    token ret_arr_ops				=> q/\b(?:map|grep|reverse|sort|keys|values|each)\b/;

    var ('IO_REF')                   = {
        keys    => ['__RISE_R2H', '__RISE_A2R'],
        values  => ['__RISE_R2H', '__RISE_A2R'],
        each    => ['__RISE_R2H', '__RISE_A2R'],
        reverse => ['__RISE_R2', '__RISE_2R'],
        pop     => ['__RISE_R2A',''],
        shift   => ['__RISE_R2A',''],
        size    => ['__RISE_R2A',''],
    };

	token space_try					=> q/(?![\n\r])\s\s/;

	token sigils					=> q/[\@\$\%\&\*]/;
	token sigil_S					=> q/\$/;
	token paren_L					=> q/\(/;
	token paren_R					=> q/\)/;

	################################################## rules ####################################################
	#rule _									=> q/<all>/;

	rule _excluding							=> q/<excluding>/;
	rule _nonamedblock						=> q/<unblk_pref><block_brace>/;
	rule _namespace							=> q/<namespace> <name> <block_brace>/;

	rule _inject							=> q/<inject> <content> <op_end>/;
	rule _using								=> q/<using> <name>[<content>]<op_end>/;
	rule _inherits							=> q/<inherits> <name>/;
	rule _implements						=> q/<implements> <name_list>/;

	#rule _object							=> q/[<_object_type_>] [<accessmod>] <_object_> <name> [<content>] \{/;
	rule _class								=> q/[<accessmod_class>] <class> <name> [<content>] <block_brace>/;
	rule _abstract							=> q/[<accessmod_class>] <abstract> <name> [<content>] <block_brace>/;
	rule _interface							=> q/[<accessmod_class>] <interface> <name> [<content>] <block_brace>/;
	rule _interface_set						=> q/[<accessmod_class>] <object_members> <name> <op_end>/;

	rule _foreach							=> q/<for_each> <block_paren> [<block_brace>]/;
	rule _foreach_var						=> q/<for_each> [<variable>] <name> <block_paren> [<block_brace>]/;
	rule _for								=> q/<for_each> \( <variable> <name> <condition> \) [<block_brace>]/;
    rule _for_foreach_array                 => q/<for_each> \( <ret_arr_ops>/;

	#rule _for_foreach						=> q/<for_each> [<variable>] [<name>] \(<condition>\) [<block_brace>]/;

	# rule _while								=> q/<while> \( <variable> <name> <condition>\) [<block_brace>]/;
    rule _while								=> q/<while> \(<condition>\) [<block_brace>]/;

	rule _regex_match						=> q/<regex_match>[ \:<regex_mods>][ [<sigils>]<regex_sorce> <comma_long_short>] [<not>](<regex_pattern_txt>|<self_name>)/;
	rule _regex_replace						=> q/<regex_replace>[ \:<regex_mods>][ [<sigils>]<regex_sorce>
												<comma_long_short>] [<not>](<regex_pattern_txt>|<self_name>)
												<comma_long_short> (<regex_expr_txt>|<regex_expr_block>|<self_name> <code_args>)/;

	rule _function 							=> q/[<accessmod>] <function> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
	rule _function_defs 					=> q/[<accessmod>] <function> [<args_attr>] <op_end><nline>/;
	rule _function_method					=> q/(NOT:__METHOD__)<name> \( (NOT:__PACKAGE__)/;
	#rule _function_method					=> q/<name>\((NOT:__PACKAGE__)/;
	rule _function_method_post1				=> q/(__METHOD__)+/;
	rule _function_method_post2				=> q/__PACKAGE__\,\)/;

	rule _variable_list						=> q/[<accessmod>] <variable> \( <name_list_wtype> \) [<op_end>]/;
	rule _variable							=> q/[<accessmod>] <variable> <name> [<variable_type>] [<op_end>]/;
	rule _constant							=> q/[<accessmod>] <const> <name> = <content> <op_end>/;
	#rule _variable_boost2					=> q/((_NOT:sigils)(_NOT:sub)<spss>)<name>/;
	#rule _variable_boost2					=> q/(_NOT:__VARBOOSTED__)(_NOT:sigils)<name>/;
	#rule _variable_boost2					=> q/(_NOT:sigils|\.)(_NOT:sub\s)(NOT:__VARBOOSTED__)<name>/;
	#rule _variable_boost2					=> q/(_NOT:sigils|\.)(_NOT:sub\s)<name>(NOT:__VARBOOSTED__)/;
	rule _variable_boost2					=> q/(_NOT:sigils|\.)(_NOT:sub\s)<name>/;
	rule _variable_boost_post				=> q/__VARBOOSTED__/;
	# rule _variable_boost2					=> q/<word> (_NOT:sigils)<name>/;
	rule _variable_boost1						=> q/[<accessmod>] <variable> <name>/;
	rule _var_boost2						=> q/(_NOT:sigils|\.)(_NOT:sub\s)<var_all>/;
	rule _variable_boost3						=> q/variable \$/;
	rule _var_boost_post1					=> q/_var_ \$/;
	rule _var_boost_post2					=> q/\.\$/;

	rule _op_regex							=> q/<sigils><self_name> <op_regex> REGEX_MATH/;
	# rule _op_scalar							=> q/<op_scalar> <string>\,/;
    # rule _op_array							=> q/<op_array>/;
	# rule _op_hash							=> q/<op_hash>/;

    # rule _op_arref_block					=> q/<op_arref_block> <block_brace>/;
    rule _op_sort_blockless					=> q/<op_sort_blockless>/;
    rule _op_array_block					=> q/<op_array_block> \{/;
    rule _op_array_hash 					=> q/<op_array_hash>/;

    # rule _op_ahref_expr 					=> q/<op_ahref_expr> [<paren_L>]/;

	# rule _op_array1							=> q/<op_array1> <block_brace>/;
	# rule _op_array2							=> q/<op_array2> [<paren_L>] [<sigils>]<self_name>/;
	# rule _op_array21						=> q/<op_array2> <string>\,/;
	# rule _op_array3							=> q/<op_array3> <string>\,/;
	# rule _op_hash							=> q/<op_hash> [<paren_L>] [<sigils>]<self_name>/;
	# rule _op_hash							=> q/<op_hash> [<paren_L>]/;
	# rule _op_reverse						=> q/<op_reverse> [<paren_L>]/;
    rule _context                           => q/(_NOT:sigils)\b\_\b/;
	rule _comma_quarter 					=> q/<name_ops> <name_list>/;
	rule _op_dot							=> q/op_dot/;
	rule _optimize4 						=> q/\s+\;/;
	#rule _optimize5 						=> q/\s\s+(_NOT:\n|\t)/;
	rule _optimize5 						=> q/space_try/;
	rule _optimize6 						=> q/_UNNAMEDBLOCK_/;
	rule _optimize7 						=> q/__RISE_R2A __RISE_[A]2R/;
	rule _optimize8 						=> q/REGEX_MATH/;
	rule _optimize9							=> q/<regex_pattern_block>/;
	rule _including							=> q/<including>/;
	rule _unwrap_code						=> q/<all>/;
	rule _commentC							=> q/<comment_C>/;

	############################# post rules ########################################
	# rule _parser_list_iter					=> q/LI: \( <name_list> \) \{ <content> \}/;
	# rule _parser_if							=> q/IF: \( [<condition>] \) \{<THEN>\}[ ELSE: \{<ELSE>\} ]/;

	############################# actions ########################################
	#action _								=> \&_;

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
	action _foreach_var 						=> \&_syntax_foreach_var;
	action _for 							=> \&_syntax_for;
	#action _for_foreach 					=> \&_syntax_for_foreach;
	action _for_foreach_array 				=> \&_syntax_for_foreach_array;

	action _while 							=> \&_syntax_while;

	action _regex_match						=> \&_syntax_regex_match;
	action _regex_replace					=> \&_syntax_regex_replace;

	action _function_defs 					=> \&_syntax_function_defs;
	action _function 						=> \&_syntax_function;
	action _function_method					=> \&_syntax_function_method;
	action _function_method_post1			=> \&_syntax_function_method_post1;
	action _function_method_post2			=> \&_syntax_function_method_post2;

	action _variable_list 					=> \&_syntax_variable_list;
	action _variable 						=> \&_syntax_variable;
	action _constant 						=> \&_syntax_constant;
	action _variable_boost1						=> \&_syntax_variable_boost1;
	action _var_boost2						=> \&_syntax_var_boost2;
	action _variable_boost3						=> \&_syntax_variable_boost3;
	action _variable_boost2					=> \&_syntax_variable_boost2;
	action _variable_boost_post				=> \&_syntax_variable_boost_post;

	action _unwrap_code						=> \&_syntax_unwrap_code;

	action _op_regex						=> \&_syntax_op_regex;
	# action _op_scalar						=> \&_syntax_op_scalar;
	# action _op_array						=> \&_syntax_op_array;
	# action _op_hash							=> \&_syntax_op_hash;

    action _op_sort_blockless	        	=> \&_syntax_op_sort_blockless;
    action _op_array_block	        		=> \&_syntax_op_array_block;
    action _op_array_hash	        		=> \&_syntax_op_array_hash;

    # action _op_ahref_expr	        		=> \&_syntax_op_ahref_expr;


	# action _op_array1						=> \&_syntax_op_array1;
	# action _op_array2						=> \&_syntax_op_array2;
	# action _op_array21						=> \&_syntax_op_array21;
	# action _op_array3						=> \&_syntax_op_array3;
	# action _op_reverse						=> \&_syntax_op_reverse;

	action _context							=> \&_syntax_context;
	action _comma_quarter					=> \&_syntax_comma_quarter;
	action _op_dot							=> \&_syntax_op_dot;
	action _optimize4		 				=> \&_syntax_optimize4;
	action _optimize5		 				=> \&_syntax_optimize5;
	action _optimize6		 				=> \&_syntax_optimize6;
	action _optimize7						=> \&_syntax_optimize7;
	action _optimize8						=> \&_syntax_optimize8;
	action _optimize9						=> \&_syntax_optimize9;

	action _including						=> \&_syntax_including;
	action _commentC 						=> \&_syntax_commentC;

	order = var 'parser__';

	#print dump(order);
	#print rule '_regex_match';
	#print "\n";
	#print rule '_regex_replace';

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

	if ( eval &condition ) {
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
		my $opt			= '';

		$opt = 'REGEX_MATH ' if $+{REGEX_MATH};

		push @{&var('excluding')}, &excluding;
		return $opt . '%%%TEXT_' . sprintf("%03d", $#{&var('excluding')}) . '%%%';
}

sub _syntax_including {
	my $including		= &including;
	my $res				= 'NOMATH';
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
	# my $name			= &name;
	my $cond			= &block_paren;
	# my $block			= &block_brace;
	my $tk_self_name	= token 'self_name';
	my $tk_sigils		= token 'sigils';
	# my $for				= '';

	# $name				= '<name> = $_;' if $name;

	#$cond				=~ s/^($tk_sigils)?($tk_self_name)$/'@'.'{'.($1||'&').$2.'}'/sxe;
	#$cond				=~ s/^(\[.*?\])$/\@\{$1\}/sx;

  $cond				=~ s/\((.*)\)/$1/sx;

	$cond				=~ s/^(\s*)($tk_sigils)?($tk_self_name)(\s*)$/$1.'__RISE_R2A '.($2||'').$3.$4/sxe;
	$cond				=~ s/^(\s*)(\[.*?\])$/$1 __RISE_R2A $2/sx;

	# $block 				=~ s/\{(.*)\}/$1/gsx;
	# $block				= '{ '.$name.''.$block.'}' if &block_brace;

	return '<for_each>...('.$cond.')...<block_brace>';
}

sub _syntax_foreach_var {
	my ($self, $rule_name, $confs)			= @_;
	my $name			= &name;
	my $cond			= &block_paren;
	my $block			= &block_brace;
	my $tk_self_name	= token 'self_name';
	my $tk_sigils		= token 'sigils';
	my $for				= '';

	$name				= '<name> = $_;' if $name;

	#$cond				=~ s/^($tk_sigils)?($tk_self_name)$/'@'.'{'.($1||'&').$2.'}'/sxe;
	#$cond				=~ s/^(\[.*?\])$/\@\{$1\}/sx;

  $cond				=~ s/\((.*)\)/$1/sx;

  # $cond				=~ s/^(\s*)($tk_sigils)?($tk_self_name)/$1.'__RISE_R2A '.($2||'&').$3/sxe;
  # $cond				=~ s/^(\s*)($tk_sigils)?($tk_self_name)/$1.'__RISE_R2A '.($2||'').$3/sxe;
  $cond				=~ s/^(\s*)($tk_sigils)?($tk_self_name)(\s*)$/$1.'__RISE_R2A '.($2||'').$3.$4/sxe;
	$cond				=~ s/^(\s*)(\[.*?\])$/$1 __RISE_R2A $2/sx;

	$block 				=~ s/\{(.*)\}/$1/gsx;
	$block				= '{ '.$name.''.$block.'}' if &block_brace;

	$for 				= '<for_each><sps1>('.$cond.')<sps4>'.$block;
	$for 				= '{ <kw_local> <variable><sps2><name><sps3>; '.$for.'}' if &variable;
	return $for;
}

sub _syntax_for { "{ <kw_local> <variable> <name>; <for_each>...(...<name>...<condition>...)...<block_brace>}" }

sub _syntax_for_foreach_array { "<for_each>...( __RISE_R2A ...<ret_arr_ops>" }

sub _syntax_for_foreach {
	my ($self, $rule_name, $confs)			= @_;


	my $variable		= &variable;
	my $name			= &name;
	my $condition		= &condition;
	my $block			= &block_brace;

	my $tk_variable		= token 'variable';
	my $tk_name			= token 'name';
	my $tk_self_name	= token 'self_name';
	my $tk_sigils		= token 'sigils';
	my $for				= '';
	my $for_block		= '';
	my $for_var_block	= '';

	my $cond			= '';


	$block 				=~ s/\{(.*)\}/$1/gsx;

	#($variable, $name, $cond) = $content =~ m/($tk_variable)?\s*($tk_name)?\s*(.*?)/gsx;


	$name				= ' '.$name.' = $_;' if $name;

	#$cond				=~ s/^($tk_sigils)?($tk_self_name)$/'@'.'{'.($1||'&').$2.'}'/sxe;
	#$cond				=~ s/^(\[.*?\])$/\@\{$1\}/sx;

	$condition			=~ s/^($tk_sigils)?($tk_self_name)$/'__RISE_R2A '.($1||'&').$2/sxe;
	$condition			=~ s/^(\[.*?\])$/__RISE_R2A $1/sx;

	$block				= '{'.$name.''.$block.'}' if &block_brace;



	$for				= '<for_each>...(...'.$name.'...'.$condition.'...)...'.$block;

	#$for 				= '{ <kw_local> <variable> <name>; '.$for.'}' if $variable;
	$for 				= '{ <kw_local> <variable> <name>; '.$for.'}' if $variable;

	return $for;
}

sub _syntax_while {
    my ($self, $rule_name, $confs)			= @_;
    my $condition		= &condition;
    my $tk_self_name	= token 'self_name';
	my $tk_sigils		= token 'sigils';

    $condition			=~ s/^($tk_sigils)?($tk_self_name)$/'__RISE_R2A '.($1||'&').$2/sxe;
    # $condition			=~ s/^(\[.*?\])$/__RISE_R2A $1/sx;

    # "{ <kw_local> <variable> <name>; <while>...(...<name>...$condition...)...<block_brace>}"
    return "<while>...(...$condition...)...<block_brace>"
}
#sub _syntax_prepare_while {
#	my $while = '<while>...(...<condition>...)...{ <name> = $_;<STATEMENT>}';
#	$while = '{ <kw_local> <variable> <name>; '.$while.'}' if &variable;
#	return $while;
#}

sub _syntax_regex_match {
	#my $res				= '';
	my $re_op			= &not || '=';
	#my $pattern			= &regex_pattern_txt || '{$'.&self_name.'}';
	my $pattern			= '%%%REGEXBLOCK'.&regex_pattern_txt.'REGEXBLOCK%%%' if &regex_pattern_txt;
	my $mods			= &regex_mods;
    my $source          = '';

    $source             = '__RISE_A2R <sigils><regex_sorce>' if &regex_sorce;
	$pattern			||= '{'.&self_name.'}';
    $re_op              .= '~<sps4>';
    $re_op              = '' if !&regex_sorce;

	return "${source}<sps3>${re_op}m<sps1>${pattern}${mods}";
}

sub _syntax_regex_replace {
	#my $res				= '';
	my $re_op			= &not || '=';
	my $pattern			= '%%%REGEXBLOCK'.&regex_pattern_txt.'REGEXBLOCK%%%' if &regex_pattern_txt;
	#my $expr_txt		= ''.&regex_expr_txt.'' if &regex_expr_txt;
	my $expr_block		= &regex_expr_block;
	#my $fn_name			= &fn_name;
	#my $fn_args			= &fn_args;
	my $mods			= &regex_mods;

	$mods				.= 'e' if &regex_expr_block;
	$pattern			||= '{'.&self_name.'}';
    $re_op              .= '~<sps4>';
    $re_op              = '' if !&regex_sorce;
	$expr_block			||= '%%%REGEXBLOCK'.&regex_expr_txt.'REGEXBLOCK%%%';
	 #$expr_block		= &regex_expr_block;

	#$pattern			= '"$'.&self_name.'"' if !$pattern;

	return "<sigils><regex_sorce><sps3>${re_op}s<sps1>${pattern}${expr_block}${mods}";
}

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
	my $members_list;

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

	#my $members_fn		= '-function-'.$name;
	$members_list		= var('members')->{$parent_class}||'';


	$members_list		=~ s/$tk_accmod//gsx;
	$members_list		=~ s/\-function\-//gsx;
	#$members_list		=~ s/^\s+(.*?)\s+$/$1/sx;
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
		var('members')->{$parent_class.'::'.$name} .= var('members')->{$parent_class}; # for recursion caller

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

    if ($accmod eq 'export'){
        $accmod = 'public';
        var('exports')->{$parent_class} .= ' '.$name;
		var('exports')->{$parent_class} =~ s/^\s+//;
		var('exports')->{$parent_class.'::'.$name} .= var('exports')->{$parent_class}; # for recursion caller
    }

	$accmod = __accessmod($self, 'code_'.$accmod, $parent_class, $name);
	#$accmod				= var($accmod.'_code');
	#$accmod				= eval var($accmod.'_code') if $accmod ne '';	#$self->{debug}


	$name				= $parent_class . '::' . $name;

	#$args				=~ s/\s//gsx;
	#$args				=~ s/\((.*?)\)/$1/gsx;

	#if ($args) {
		$args				=~ s/^\((.*?)\)$/$1/;
		$self_args			.= ',' . $args if $args;

		my @args = split /\,/,$self_args;
		my $args_list			= '';
		my $args_def			= '';
		my $proto			= '';
		my $i = 0;

		s{
			(?<name>\b\w+(?:\s*\:\s*\w+)?\b)
			(\s*\=\s*(?<def>.*))?
		  }{
			$args_list	.= $+{name} . ',';
			$args_def 	.= '$_['.$i.']';
			$args_def	.=('||'.$+{def}) if $+{def};
			$args_def	.=',';
			$proto		.= '$';
			$i++;
		}sxe for @args;

		$args_list	=~ s/\,$//;
		$args_def	=~ s/\,$//;
		#$attr	||= '('.$proto.')';

		$self_args	= $args_list;
	#}

	$self_args =~ s/^\,//;

	#$arguments			= &kw_local." ".&kw_variable." ($self_args) = \@_;" if $self_args;
	$arguments			= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;



	$arguments			= parse($self, $arguments, &grammar, ['_variable_list','_variable'], { parent => $name });
	$block 				=~ s/\{(.*)\}/$1/gsx;
	$block 				= parse($self, $block, &grammar, ['_variable_boost2', '_variable_boost3'], { parent => $parent_class });
	#$block 				= parse($self, $block, &grammar, [@{var 'parser_variable'}], { parent => $parent_class });
	$block 				= parse($self, $block, &grammar, [@{var 'parser_code'}], { parent => $name });
	#$block 				= parse($self, $block, &grammar, ['_var_boost2', '_variable_boost3'], { parent => $parent_class });
	#var('wrap_code')->{$name} = $block;
	#$block = '%%%WRAP_CODE_' . $name . '%%%';

	$res				= "${anon_code}{ package ${name}; use rise::core::extends 'rise::object::function', '${parent_class}'; use rise::core::function; BEGIN { __PACKAGE__->__RISE_COMMANDS } sub ${s1}${fn_name}${s2}${attr}${s3}{ ${accmod} ${arguments}${s4}${block}}}";
	#$res				= "${anon_code}{ package ${name}; use rise::core::function_new; sub ${s1}${fn_name}${s2}${attr}${s3}{ ${accmod} ${arguments}${s4}${block}}}";

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

	my $var_def				= &name_list_wtype;
	my $var_init			= &name_list_wtype;
	my $tk_name				= token 'name';
	my $tk_name_type		= token 'name_type';
	my $op_end				= '';

	$var_def				=~ s/($tk_name_type)\,?/<accessmod> <variable> $1;/gsx;
	$var_init				=~ s/(?<!\$)\b($tk_name)\b(?:\s*\:\s*\w+)?/\$$1/gsx;

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

sub _syntax_variable_boost1 {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent} || '';

	my $accmod			= &accessmod || var('accessmod');
	my $name			= &name;
	my $tk_accmod		= token 'accessmod';
	my $tk_name			= token 'name';
	my $members_var		= $accmod.'-var-'.$name;
	my $members_list	= var('members')->{$parent_class} || '';




	if ($members_list) {

		#$members_list			=~ s/\b(?:$tk_accmod)\-(?!var)\w+\-\w+(?:::\w+)*//gsx;
		#$members_list			=~ s/\b(?:$tk_accmod)\-var\-(\w+(?:::\w+)*)/\\b$1\\b/gsx;
		##$members_list			=~ s/^\s+(.*?)\s+$/$1/sx;
		#$members_list			=~ s/\\b\s+\\b/\\b|\\b/gsx;
		##$members_list			=~ s/\#//gsx;
		#$members_list			=~ s/\s+//gsx;

		#----------------------------------------------------------


		#$members_list		=~ s/$tk_accmod//gsx;
		#$members_list		=~ s/\b\-(?!var)\w+\-\w+(?:::\w+)*//gsx;
		#$members_list		=~ s/\-var\-//gsx;
		#$members_list		=~ s/\s/\\b|\\b/gsx;

		#----------------------------------------------------------

		$members_list = join ('\b|\b', $members_list =~ /\b\w+\-var\-($tk_name)\b/gsx);
	}

	var('members')->{$parent_class} .= ' '.$members_var if $members_var !~ /$members_list/gsx;  # if $accmod ne 'local';
	var('members')->{$parent_class} =~ s/^\s+//;

	token 'var_all'		=> $members_list||1;
	rule '_var_boost2'	=> '(_NOT:\$)<var_all>';

	return "$accmod <kw_variable> $name";
}

sub _syntax_var_boost2		{ '$<var_all>' }

sub _syntax_variable_boost3		{ '<kw_variable> ' }

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
	my $variable_type	= &variable_type;
	my $var_type		= '';
	my $var_type_args	= '';
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

    if ($accmod eq 'export'){
        $accmod = 'public';
        var('exports')->{$parent_class} .= ' '.$name;
		var('exports')->{$parent_class} =~ s/^\s+//;
		var('exports')->{$parent_class.'::'.$name} .= var('exports')->{$parent_class}; # for recursion caller
    }

	$accmod = __accessmod($self, 'var_'.$accmod, $parent_class, $name);
	#$accmod				= eval var($accmod.'_var');

	if (&accessmod eq 'local') {
		#$accmod			= '';
		$local_var		= "local *$name; ";
	}
	($var_type, $var_type_args)	= $variable_type =~ m/^\:\s*(\w+)(?:\((.*?)\))?$/;

	$var_type_args		= ", ".$var_type_args if $var_type_args;
	$var_type_args		||= '';

	$var_type			= "__PACKAGE__->__RISE_CAST('$var_type', \\\$$name".$var_type_args."); " if $var_type;
	$var_type			||= '';

	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	$op_end				= " \$$name".&op_end." " if !&op_end;

	#return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<op_end>' ) {<name><op_end>}/;
	#return "my \$$name; $local_var { no warnings; sub $name ():lvalue { \$$name } } $op_end";
	#return "my \$$name; { no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { $accmod\$$name };}$op_end";
	return "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings; $op_end";
}

sub __accessmod {
	my ($self, $accmod, $parent_class, $name)			= @_;

	return '' if !$self->{debug};
	#print "+++++++++++  ".$parent_class.' - '.$name."\n";
	my %access = (

		code_private	=> '__PACKAGE__->__RISE_ERR(\'CODE_PRIVATE\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);',
		code_protected	=> '__PACKAGE__->__RISE_ERR(\'CODE_PROTECTED\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');',
		code_public		=> '',

		#var_private		=> '__RISE_VAR_PRIV(\''.$parent_class.'\', \''.$name.'\');',
		#var_protected	=> '__RISE_VAR_PROT(\''.$parent_class.'\', \''.$name.'\');',
		var_private		=> '__PACKAGE__->__RISE_ERR(\'VAR_PRIVATE\', \''.$name.'\') unless (caller eq \''.$parent_class.'\' || caller =~ m/^' . $parent_class . '\b/o);',
		var_protected	=> '__PACKAGE__->__RISE_ERR(\'VAR_PROTECTED\', \''.$name.'\') unless caller->isa(\''.$parent_class.'\');',
		var_public		=> '',
		var_local		=> '',



	);

	return $access{$accmod};
}

sub _syntax_variable_NEW {
	my ($self, $rule_name, $confs)			= @_;

	my $accmod			= &accessmod || var 'accessmod';
	my $name			= &name;
	my $parent_class	= $confs->{parent};
	#my $parent_name		= $confs->{parent} || 'main';
	my $boost_vars		= '';
	my $local_var		= '';
	my $op_end			= '';
	my $obj_name		= $parent_class.'::'.$name;
	my $obj_name_local	= $obj_name;
	my $name_local		= $name;

	my $members_var		= $accmod.'-var-'.$name;
	my $members_list	= var('members')->{$parent_class}||'';

	$members_list		=~ s/\s/\|/gsx;
	var('members')->{$parent_class} .= ' '.$members_var if $members_var !~ /$members_list/;  # if $accmod ne 'local';
	var('members')->{$parent_class} =~ s/^\s+//;

	#$accmod				= var($accmod.'_var');




	if (&accessmod eq 'local') {
		var('local_var_count')++;
		$accmod			= var 'accessmod';
		$obj_name_local		.= '_LOCAL' . var('local_var_count');
		$name_local			.= '_LOCAL' . var('local_var_count');
		$local_var		= "$local_var *$name = *$name_local; sub $name ():lvalue; ";
		#$obj_name		= $obj_name_local;
	}



	#$accmod				= eval $accmod if $accmod ne '';
	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	$op_end				= " \$$name".&op_end." " if !&op_end;

	#return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<op_end>' ) {<name><op_end>}/;
	#return "my \$$name; $local_var { no warnings; sub $name ():lvalue { \$$name } } $op_end";
	#return "my \$$name; { no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { $accmod\$$name };}$op_end";
	#return "my \$$name; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name };$op_end";
	return $local_var."my \$$name; { package $obj_name_local; no warnings; use rise::core::variable \\\$$name, '$accmod'; }$op_end";
	#return "my \$$name; { package $obj_name; no warnings; use rise::core::variable \\\$$name, '$accmod'; }$op_end"
}

sub _syntax_variable_boost2_OFF {
	my $word			= &word;
	my $sigils			= &sigils;
	my $name			= &name;
	my $regexp			= var('class_var');
	var('class_var')	= '';
	#$content 			=~ s/(?:(?<!(?:var|sub)\s)|(?<!\$|\*)|(?<!\-\>))\b($regexp)\b/\$$1/gsx if $regexp;
	$name 			=~ s/\b($regexp)\b/\$$1/gsx if $regexp;
	return "$word $name";
}

sub _syntax_variable_boost2 {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};

	my $name			= &name;
	#my $args			= &content; #$args ||= '';
	#my $this			= '';
	#my $tk_accmod		= token 'accessmod';
	my $tk_name			= token 'name';
	#my $var_list		= var('members')->{$parent_class}||'';
	my $sigil			= "";
	my $varboost		= "";
	#my $members_var		= '-var-'.$name;
	my $members_list	= var('members')->{$parent_class}||'';


	#######################################################################################
	#$members_list		=~ s/$tk_accmod//gsx;
	#$members_list		=~ s/\-var\-//gsx;
	#$members_list		=~ s/\s/\|/gsx;

	$members_list		= join ('\b|\b', $members_list =~ /\b\w+\-var\-($tk_name)\b/gsx);
	#######################################################################################


	if ($members_list && $name =~ m/\b(?:$members_list)\b/gsx) {
		$sigil				= "\$";
		$varboost			= "__VARBOOSTED__";
		#print "VAR $parent_class->$name | fnlist - *$members_list* \n";
	}

	return "${sigil}${name}";
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

    if ($accmod eq 'export'){
        $accmod = 'public';
        var('exports')->{$parent_class} .= ' '.$name;
		var('exports')->{$parent_class} =~ s/^\s+//;
		var('exports')->{$parent_class.'::'.$name} .= var('exports')->{$parent_class}; # for recursion caller
    }

	$accmod				= __accessmod($self, 'var_'.$accmod, $parent_class, $name);
	#$accmod				= eval var($accmod.'_var'); # if &accessmod ne 'local';
	#$accmod				= var($accmod.'_var');
	if (&accessmod eq 'local') {
		#$accmod			= '';
		$local_var		= "local *$name; ";
	}
	#$accmod				= eval $accmod if $accmod ne '';
	#$name				=~ s/\w+(?:::\w+)*::(\w+)/$1/sx;
	#$sname				= $name;
	#$parent_name		=~ s/(\w+(?:::\w+)*)::\w+/$1/gsx;
	#$accmod			= '_'.uc($accmod).'_VAR_; ' ;


	#$accmod				= $accmod . '("' . $name . '", "' . $parent_name .'");' if $accmod ne '';

	return "${local_var}sub $name () { $accmod<content> }";
}
#-------------------------------------------------------------------------------------< namespace

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

sub _syntax_class {
	return '' if !&name;
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod_class || var 'accessmod';
	return __object($self, 'class', $rule_name, $confs);
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

sub _syntax_interface {
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod_class || 'protected';
	return __object($self, 'interface', $rule_name, $confs);
}

sub _syntax_interface_set {
	my ($self, $rule_name, $confs)			= @_;

	my $accmod			= &accessmod_class || var 'accessmod';
	my $object_members	= &object_members;
	my $name			= &name;
	my $op_end			= &op_end;

	return "BEGIN { __PACKAGE__->set_interface('${accmod}-${object_members}-${name}'); }";
}

#-------------------------------------------------------------------------------------< abstract

sub _syntax_abstract {
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod_class || 'protected';
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
    my $list_exports    = '';
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

	#$block 				= parse($self, $block, &grammar, ['_variable_boost2', '_variable_boost3'], { parent => $parent_class });
	$block 				= parse($self, $block, &grammar, [@{var 'parser_'.$object}], { parent => $name });

	#var('excluding_class_code')->{$name} = $block;
	#$block = '%%%CLASS_CODE_' . $name . '%%%';
	#
	#return "{ package ${name}; use strict; use warnings;".&sps1.$extends.&sps2.$accmod.&sps3 . __object_header($object, $name || '') . &sps4.$block."}";

	$res				= "{ package ${name};".$sps1."use strict; use warnings;". $sps2 . $extends . $sps3 . $accmod . __object_header($self, $object, $name || '', $confs) . $sps4.$block."}";
	var('wrap_code')->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';

	return $res;
}

sub __object_header {
	my $self			= shift;
	my $obj_type		= shift;
	my $name			= shift;
    my $confs           = shift;
    my $parent_class	= $confs->{parent} || 'main';

	my $header			= {
		# class		=> " sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }; BEGIN { __PACKAGE__->__RISE_COMMANDS }",
		class		=> " BEGIN { no strict 'refs'; *{'".$name."::'.\$_} = \\&{'".$parent_class."::EXPORTED::'.\$_} for keys \%".$parent_class."::EXPORTED::; }; sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }; BEGIN { __PACKAGE__->__RISE_COMMANDS }",
		abstract	=> "",
		interface	=> " __PACKAGE__->interface_join;"
	};

    if (exists var('exports')->{$name}) {
        # $header->{class}	.= ' sub import { no strict "refs"; my $self	= caller(0); *{$self . "::$_"} = \&$_ for (split /\s+/,"'.var('exports')->{$name}.'"); }';
        # $header->{class}	.= ' sub import { no strict "refs"; my $self	= caller(0); *{$self . "::$_"} = \&$_ for (qw/'.var('exports')->{$name}.'/); }';
        $header->{class}	.= ' { no strict "refs"; my $__CALLER_CLASS__	= (caller(0))[0]; for (qw/'.var('exports')->{$name}.'/){ *{$__CALLER_CLASS__ . "::$_"} = \&$_; *{$__CALLER_CLASS__ . "::EXPORTED::$_"} = \&$_; }}';
    }

	if ($self->{debug}) {
		$header->{class}	.= " __PACKAGE__->interface_confirm; sub __OBJLIST__ {'".(var('members')->{$name}||'')."'}...";
		$header->{abstract} .= " __PACKAGE__->interface_join;";
	}

	return $header->{$obj_type};
}

#-------------------------------------------------------------------------------------

sub _syntax_op_regex { "__RISE_A2R <sigils><self_name><sps1><op_regex>" }
sub _syntax_op_scalar { "__RISE_A2R <op_scalar><sps1><string>," }

sub _syntax_op_array {
	my $op_array			= '__RISE_' . uc &op_array;
	return $op_array;
}

sub _syntax_op_sort_blockless { "sort {}" }

sub _syntax_op_array_block {

	# return '__RISE_A2R <op_array>__OFF__...<block_brace> __RISE_R2A';

	my $op_array			= '__RISE_' . uc &op_array_block . '_BLOCK';
    return $op_array.' {';
}

sub _syntax_op_array_hash { return '__RISE_' . uc &op_array_hash }

sub _syntax_op_ahref_expr {

    return "__RISE_A2R <op_hash>...<paren_L>...__RISE_R2H ";
}

sub _syntax_op_array1 {
	my $sigils			= &sigils || '&';
	return "<op_array1>...<paren_L>...\@{${sigils}<self_name>}";
}

sub _syntax_op_array2  { "__RISE_A2R <op_array2>...<block_brace> __RISE_R2A" }
sub _syntax_op_array21 { "__RISE_A2R <op_array2>...<string>, __RISE_R2A" }
sub _syntax_op_array3  { "<op_array3>...<string>, __RISE_R2A" }

sub _syntax_op_hash {
	# my $sigils			= &sigils || '&';
	# my $selfname		= &self_name;
	# $selfname 			= "\%{${sigils}<self_name>}" if &self_name !~ /\_\_RISE/; # if $sigils eq '$';

	return "__RISE_A2R <op_hash>...<paren_L>...__RISE_R2H ";
}

# sub _syntax_op_hash {
#     my $op_hash			= '__RISE_' . uc &op_hash;
# 	return $op_hash;
# }

sub _syntax_op_reverse { '__RISE_2R <op_reverse>...<paren_L>...__RISE_R2 ' }


sub _syntax_op_array3_OFF {
	my ($self, $rule_name, $confs)			= @_;

	my $parent_class	= $confs->{parent};
	my $string1			= &string1;
	my $op_array2		= &op_array2;
	my $string2			= &string2;
	#my $op_end			= &op_end;

	my $tk_sigils		= &tk_sigils;
	my $tk_self_name	= &tk_self_name;

	my ($sps1,$sps2,$sps3,$sps4) = (&sps1,&sps2,&sps3,&sps4);

	my $var				= '';
	my $res;

	if ($string2 =~ m/^($tk_sigils)?($tk_self_name)(.*?)$/) {

		my $sigil			= $1 || '&';

		$var 				= $sigil.$2;
		$var 				= "\@{".$sigil.$2."}" if $sigil eq '$';
		$var 				= "\@{".$sigil.$2."}" if $sigil eq '&';

		$var				.= $3 if $3;

	}




	#$block 				=~ s/\{(.*)\}/$1/gsx;

	#$block 				= parse($self, $block, &grammar, ['_op_array1','_op_array2'], { parent => $parent_class });

	#$res				= '['.$op_array2.$sps1.$string1.','.$sps2.$var.$sps3.']'.$op_end;
	$res				= $op_array2.$sps1.$string1.','.$sps2.$var;

	#var('wrap_code')->{$name} = $res;
	#$res = '%%%WRAP_CODE_' . $name . '%%%';

	return $res;
}

sub _syntax_context {"\$_"}

sub _syntax_comma_quarter {
		my $name_ops		= &name_ops;
		my $name			= &name_list;
		$name				= __name2name($name);
		return $name_ops . ' ' . $name;
}

sub  __name2name {
	my $name = shift;
	$name =~ s/\./\:\:/gsx;
	return $name;
}

sub _syntax_op_dot {'->'}

sub _syntax_optimize4 { ';' }
sub _syntax_optimize5 { ' ' }
sub _syntax_optimize6 { '' }
sub _syntax_optimize7 { '<sps1>' }
sub _syntax_optimize8 { '' }
sub _syntax_optimize9 {
	my $res;
	$res = '{' if $+{REG_PATTERN_LEFT};
	$res = '}' if $+{REG_PATTERN_RIGHT};
	return $res;
}

1;
