package rise::syntax2;

use strict;
use warnings;
use v5.008;
use utf8;
# use DateTime;
######################## DEBUG ##########################
use feature 'say';
use Data::Dump 'dump';
#########################################################
use Clone 'clone';

# use lib '../lib/rise/';

use rise::lib::grammar ':simple';
#use rise::action;

our $VERSION = '0.000';
# our $conf							= {};

# my $cenv 							= {};
# my $this							= {};
# my $PARSER							= {};
#my $parser							= new rise::lib::grammar;
#my $a								= rise::action->new(__PACKAGE__->new);
# my $LocalTZ = DateTime::TimeZone->new( name => 'local' );
# my $dt      = DateTime->now(time_zone => $LocalTZ);
# my $dt                              = DateTime->now();
# my $auth_set                        = 'unknown';
# my $ver_set                         = $dt->year . '.' . sprintf("%02d", $dt->month) . sprintf("%02d", $dt->day) . $dt->hms('');

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	# %$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    my $self                    = {};
    %$self						= (%$self, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    #__init();
	return bless($self, $class);                         					# обьявляем класс и его свойства
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

	# %$conf						= (%$conf, %$self);
	#print dump($conf)."\n";

    var 'excluding';
    var 'wrap_variable';
    var 'wrap_code_header';
    var 'wrap_code';
    var 'wrap_observe';

    var('env')						= '$rise::core::object::object::renv';
	var('app_stack')				= [];
	#var('parse_token_sign')			= '-';
	var('accessmod_namespace')	    = '';
	var('accessmod_class')			= $self->{accmod_class} || 'private';
	var('accessmod')				= $self->{accmod} || 'private';
	#var('command_inherit')			= 'use parents';
	#var('text')						= [];
	#var('namespace')				= '';
	var('className')				= '';
	#var('function')					= '';
	var('anon_fn_count')			= 0;
	var('local_var_count')			= 0;
	var('anon_code_pref')			= 'ACODE';
	#var('class_blocknum')			= undef;
	var('memberPref')				= 'm1234';
	var('members')					= {};
	var('exports')					= {};
	var('auth')				        = {};
	var('ver')				        = {};
	var('pkg_self')				    = '__RISE_SELF__';
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


	var ('parser_member_observe')	= [
        '_function_observe',
        '_variable_observe',
        # '_unwrap_observe',
	];

	var ('parser_variable')	= [
        '_variable_list',
		'_variable_optimize',
        # '_variable_observe',
		'_variable_compile',
		'_constant_compile',
	];

    var ('parser_loops')            = [
        ########## LOOPS ##########
        '_for',
        '_foreach',
        '_foreach_var',
        # '_for_foreach_array',
        '_while',
        ###########################
    ];

	var ('parser_function')			= [
        '_function_defs',
        # '_function_observe',
        # '_variable_observe',
		'_function_compile',
		'_function_call',
        # '_member_name',
	];

	var ('parser_thread')			= [
		'_thread_compile',
		'_thread_call',
	];

    var ('parser_code')	= [
        # '_variable_list',
        @{&var_parser_member_observe},
        '_unwrap_observe',
        # '_function_observe',
        # '_variable_observe',

        '_regex_match',
		'_regex_replace',

		@{&var_parser_function},
		@{&var_parser_thread},
		@{&var_parser_loops},
        @{&var_parser_variable},
        '_foreach_arr',
	];

    var ('parser_code_function')	= [

        @{&var_parser_code},
        '_variable_call',
        '_member_name_function',
	];

	var ('parser_code_class')	= [
        @{&var_parser_code},
        '_member_name_class',
        # '_member_name',
	];

	var ('parser_class')	= [
		'_class',
		'_inject',
		'_using',
		@{&var_parser_code_class},
	];

	var ('parser_interface')	= [
		'_interface_set',
	];

	var ('parser_abstract')		= [
		'_interface_set',
		'_inject',
		'_using',
		@{&var_parser_code_class},
	];

	var ('parser_namespace')	= [
		'_comma_quarter',
		'_namespace',
		'_inject',
		'_using',
        #-----------------------------------------------------------------------
        # // TODO ПРОВЕРИТЬ
		'_class',
		'_abstract',
		'_interface',
        # @{var 'parser_class'},
        # @{var 'parser_abstract'},
        # @{var 'parser_interface'},
        #-----------------------------------------------------------------------
	];

	var ('parser__')	= [

		'_commentC',
        '_auth',
        '_vers',
		'_excluding',

        # '_op_sort_blockless',
        # '_op_array_block',
        # '_op_array_hash',

		'_nonamedblock',
        # '_namespace',
		@{var 'parser_namespace'},
        '_unwrap_code',
        '_op_regex',

        '_op_scalar',

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

        '_op_for_each',
        '_op_dot',
        '_concat',
        '_optimize4',

        '_optimize6',
        '_optimize7',
        '_optimize71',
        '_optimize8',
        '_function_call_post1',
        '_function_call_post2',
        # '_member_name',
        '_thread_call_post1',
        '_thread_call_post2',
        #'_function_boost_post1',
        #'_function_boost_post2',
        #'_variable_boost_post',
        #'_optimize5',

        '_class_ops',

        '_unwrap_code_header',
        '_unwrap_code_footer',
        '_unwrap_variable',

        '_including',
        '_optimize9',
	];

	keyword namespace				=> 'namespace';
	keyword class					=> 'class';
	keyword abstract				=> 'abstract';
	keyword interface				=> 'interface';
	keyword using					=> 'using';
	keyword using2					=> 'import';
	keyword inherits				=> 'extends';
	keyword implements				=> 'implements';
	keyword inject					=> 'inject';
	keyword auth					=> 'auth';
	keyword vers					=> 'vers';
	keyword new					    => 'new';

	keyword function1				=> 'function';
	keyword function2				=> 'func';
	keyword method					=> 'method';
	keyword fmethod					=> 'fmethod';
    keyword thread					=> 'thread';

	keyword variable				=> 'var';
	keyword constant				=> 'const';
	keyword private					=> 'private';
	keyword protected				=> 'protected';
	keyword public					=> 'public';
	keyword override				=> 'override';
	keyword local					=> 'local';
	keyword export					=> 'export';

	keyword dot					    => '\.';
	keyword self					=> 'self';
	keyword fnargs					=> 'args';
	# keyword self_pkg       			=> '__RISE_SELF__';
	keyword self_pkg       			=> '__RISE_SELF__';
	keyword self_fn       			=> '__PACKAGE__';
    keyword context				    => '_';
    # keyword concat				    => '_\+';
    keyword concat				    => '\~';

	keyword for						=> 'for';
	keyword foreach					=> 'foreach';
	keyword while					=> 'while';

	# keyword regex_kw				=> '(?:re|regex)';
	keyword regex_kw1				=> 'regex';
	keyword regex_kw2				=> 're';

	# keyword regex_match			    => '(?:m|match)';
	keyword regex_match1			=> 'm';
	keyword regex_match2			=> 'match';

	# keyword regex_replace			=> '(?:s|r|replace)';
	keyword regex_replace1			=> 's';
	keyword regex_replace2			=> 'r';
	keyword regex_replace3			=> 'replace';

	keyword re_match				=> '(?:re|regex)\.(?:m|match)';
	keyword re_match1				=> 're\.m';
	keyword re_match2				=> 're\.match';
	keyword re_match3				=> 'regex\.match';
	keyword re_repl				    => '(?:re|regex)\.[sr]';
	keyword re_repl1				=> 're\.[sr]';
	keyword re_repl2				=> 're\.replace';
	keyword re_repl3				=> 'regex\.replace';

	################################################## rules ####################################################

	token namespace					=> keyword 'namespace';
	token class						=> keyword 'class';
	token abstract					=> keyword 'abstract';
	token interface					=> keyword 'interface';
	token inject					=> keyword 'inject';
	token using						=> keyword 'using';
	token inherits					=> keyword 'inherits';
	token implements				=> keyword 'implements';
	token auth				        => keyword 'auth';
	token vers				        => keyword 'vers';
	token new				        => keyword 'new';
	token function1					=> keyword 'function1';
	token function2					=> keyword 'function2';
	# token function					=> q/(?:function1|function2)/;
	token function					=> keyword 'function1';
	token method					=> keyword 'method';
	token fmethod					=> keyword 'fmethod';
	token thread					=> keyword 'thread';
	token variable					=> keyword 'variable';
	token constant					=> keyword 'constant';
	token private					=> keyword 'private';
	token protected					=> keyword 'protected';
	token public					=> keyword 'public';
	token override					=> keyword 'override';
	token local						=> keyword 'local';
	token export					=> keyword 'export';
	token self						=> keyword 'self';
	token self_pkg					=> keyword 'self_pkg';
	token self_fn					=> keyword 'self_fn';
	token self_con					=> q/(?:\$?self_pkg|self_fn)/;

	token re_match1					=> keyword 're_match1';
	token re_match2					=> keyword 're_match2';
	token re_match3					=> keyword 're_match3';
	token re_repl1					=> keyword 're_repl1';
	token re_repl2					=> keyword 're_repl2';
	token re_repl3					=> keyword 're_repl3';

	# token regex_keyword					=> keyword 'regex_kw';
	token regex_kw1					=> keyword 'regex_kw1';
	token regex_kw2					=> keyword 'regex_kw2';

	token regex_match1				=> keyword 'regex_match1';
	token regex_match2				=> keyword 'regex_match2';

	token regex_replace1			=> keyword 'regex_replace1';
	token regex_replace2			=> keyword 'regex_replace2';
	token regex_replace3			=> keyword 'regex_replace3';

	token regex_kw					=> q/(?:regex_kw1|regex_kw2)/;
	token regex_kw_match			=> q/(?:regex_match1|regex_match2)/;
	token regex_kw_replace			=> q/(?:regex_replace1|regex_replace2|regex_replace3)/;

	# token regex_match				=> q/re_match1|re_match2|re_match3/;
	# token regex_replace				=> q/re_repl1|re_repl2|re_repl3/;
	token regex_match				=> q/regex_kw\.regex_kw_match/;
	token regex_replace				=> q/regex_kw\.regex_kw_replace/;
	token regex_m_want				=> q/[=}),]/;

	token regex_mods				=> q/word/;
	token regex_sorce				=> q/self_name/;
	token regex_pattern_txt			=> q/%%%TEXT_ number %%%/;
	token regex_pattern_var			=> q/self_name/;
	token regex_expr_txt			=> q/%%%TEXT_ number %%%/;
	token regex_expr_block			=> q/block_brace/;
	token regex_pattern_block		=> q/(?<REG_PATTERN_LEFT>%%%REGEXBLOCK\")|(?<REG_PATTERN_RIGHT>\"REGEXBLOCK%%%)/;

	token comma_long_short			=> q/\=\>|\,/;
	token not						=> q/\!/;
	token equal						=> q/\=/;

	token member_type				=> q/\:\s*\w+(?:\s*block_paren)?/;
    # token spec_vars                 => q/(?:
    #     _|_|a|b|ARGV|\d+|\&|\{\^MATCH\}|\`|\{\^PREMATCH\}|\'|\{\^POSTMATCH\}|\+
    #     |\^N|\+|\-|\^R|\{\^RE_DEBUG_FLAGS\}|\{\^RE_TRIE_MAXBUF\}
    #     |\{\^ENCODING\}|\{\^OPEN\}|\{\^UNICODE\}|\{\^UTF8CACHE\}|\{\^UTF8LOCALE\}
    #     |\.|\/|\||\,|\\|\"|\;|\%|\=|\-|\~|\^|\:|\^L|\^A|\?|\!|\!|\^E|\@
    #     |\{\^CHILD_ERROR_NATIVE\}|\$|\<|\>|\(|\)|0|\^O|\]|\^C|\^D|\^F|\^I|\^M|\^P
    #     |\^R|\^S|\^T|\^V|\^W|\{\^WARNING_BITS\}|\^X|\{\^GLOBAL_PHASE\}|\^H
    #     |\{\^TAINT\}|\{\^WIN32_SLOPPY_STAT\}|ARGV|ARGVOUT|F|INC|ENV|SIG|\[
    # )/;

    token spec_vars                 => q/(?:[\@\$\%])(?:\W|\^\w+|\w+|\d+|{\^\w+})/;
    # token spec_vars                 => q/(?:\W|\^\w+|\w+|\d+|{\^\w+})/;

    # token op_dot					=> q/(?<! [\s\W] ) \. (?! [\s\d\.] )/;
	# token op_dot					=> q/\./;
	token op_dot					=> keyword 'dot';
	# token op_dot2					=> q/(?:[^\s])\.(?:[^\s\d\.])/;
	token op_dot2					=> q/(?<!\.)\.(?![\d\.])/;

    token context                   => keyword 'context';
    token concat                    => '(?<![!=])'.keyword('concat');

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
	#token letter					=> q/[_a-ZA-Z]/;
    token symbol                    => q/./;
	token letter					=> q/\w/;
	token digit						=> q/\d/;
	token nletter					=> q/\W/;
	token all						=> q/symbol*/;
	#token all						=> q/string*/;
	token sps						=> q/\s*/;
	token spss						=> q/\s+/;

	token nnline					=> q/[^\r\n]/;
	#token nline						=> q/[\r\n]/;
	token nline						=> q/\r|\n|\r\n/;
	token op_end					=> q/\;/;

	token name_ex					=> q/ident(?:(?:::|\.)ident)*/;

	#token name						=> q/word(?:\:\:word)*/;
	# token name						=> q/\b(?:ident(?:(?:::|\.)ident)*)\b/;
	token name						=> q/\b(?:ident(?:(?:::)ident)*)\b/; # в имени не должно быть "." т.к. возникает ошибка при конвертации вызова метода как функции в rule "_function_call"
	# token name						=> q/(?<!\%)\b(?:ident(?:(?:::)ident)*)\b(?!\%)/; # в имени не должно быть "." т.к. возникает ошибка при конвертации вызова метода как функции в rule "_function_call"
	#token name						=> q/(?:\b[^\d\W]\w*\b)(?:::(?:\b[^\d\W]\w*\b))*/;
	#token name						=> q/[^\d\s](?:word\:\:)*word/;
    token name_dot					=> q/\b(?:ident(?:(?:\.)ident)*)\b/;
	token name_type					=> q/\b(name(\s*:\s*ident)?)\b/;
	token name_list					=> q/name(?:\s*\,\s*name)*/;
	token name_dot_list				=> q/name_dot(?:\s*\,\s*name_dot)*/;
	token name_list_wtype			=> q/name_type(?:\s*\,\s*name_type)*/;
	token namestrong				=> q/[^\d\W][\w:]+[^\W]/;
	token name_ext					=> q/name/;
	token name_impl					=> q/name_list/;
    # token self_name					=> q/(?:this\.)*name/;
    token self_name					=> q/(?:self\.)*name(?:\.?\{[-+]?\w+\})*/;
    token spec_name					=> q/sigils?(?:self\.)*\b(?:word(?:(?:::)word)*)\b(?:\.?\{[-+]?\w+\})*/;

	token func_args					=> q/name_type(\s*\=\s*content)?(?:\s*\,\s*name_type(\s*\=\s*content)?)*/;

	token comment_Perl				=> q`(?<![$@%])\# nnline*`;
	token comment_C					=> q`(?<![msqr\$\@\%\\\])\/\/ nnline*`;
	#token comment					=> q/comment_Perl|comment_C/;
	token comment					=> q/comment_Perl/;

	token for_each					=> q/\b(?:foreach|for)\b/;

	token accessmod_class			=> q/private|protected|public/;
	token accessmod					=> q/local|export(?:\s*:\w+)*|private|protected|public/;
	# token accessmod					=> q/(?:(?:override)\s+)?(?:local|export(?::\w+)*|private|protected|public)/;
    # token accessmod					=> q/(?:(?:local|export(?::\w+)*|private|protected|public)?(?:\s+override)?)/;
	token class_type				=> q/namespace|class|abstract|interface/;
	#token function					=> q/function/;
	token name_ops					=> q/class_type|function|thread|variable|constant|using|inherits|implements|new/;
	# token class_ops					=> q/class_type|function|thread|variable|constant|using|inherits|implements|new/;
	token object_members			=> q/function|thread|variable|constant/;
	token object					=> q/(?<!\S)(?:class_type|object_members)(?!\S)/;

	token _object_type_				=> q/\b_object_ word _\b/;
	token _object_					=> q/_class_|_abstract_|_interface_/;
	token _namespace_				=> q/_namespace_/;
	token _base_					=> q/_base_/;
	token _class_					=> q/_class_/;
	token _interface_				=> q/_interface_/;
	token _abstract_				=> q/_abstract_/;
	token _class_type_				=> q/_namespace_|_base_|_class_|_abstract_|_interface_/;
	token _var_						=> q/_var_/;
	token _const_					=> q/_const_/;
	token op_for_each				=> q/__ (?:FOR|FOREACH) __/;
	token op_for_each_cond			=> q/__ (?:FOR_COND|FOREACH_COND) __/;

	token code_args					=> q/\(content\)/;
	token code_type					=> q/(?:\:\s*word\s*)*/;

	#token code_attr					=> q/(?:\(\W*\))?(?:\:\s*content\s*)?/;
	#token code_attr					=> q/(?:\(\W*\))?(?:\:[\w\s\(\)\,]+)?/;
	#token code_attr					=> q/(?:\:\s*content\s*)/;
	#token code_attr					=> q/(?:\:\s*content)/;
	#token code_attr					=> q/(?:\:content)+/;
	token code_attr					=> q/(?:\:\s*word\s*)*/;
	#token code_attr					=> q/(?:[^\{\}\n]*)?/;
	#token code_attr					=> q/[^\{\}\n]*/;


	token args_attr					=> q/(?:[^\{\}](?!object|accessmod))*/;
	#token args_attr					=> q/(?:[^\{\}\;])*/;
	#token args_attr					=> q/(?:\(\W*\))?(?:\s*\:\s*content)?/;
	#token args_attr					=> q/(?:\([\\\@\$\%\&\*\;\,]*\))?(?:\:[\w\s\(\)\,]+)?/;
	#token args_attr					=> q/[^\{\}\n]+[\;]*?/;

	token list						=> q/\(content\)/;
	token inherit_list				=> q/inherits/;
	token implement_list			=> q/implements/;

	token excluding					=> q/POD|DATA|END|comment|regex|text/;
	token including					=> q/%%%TEXT_ number %%%/;
	# token wrap_code					=> q/%%%CLASS_CODE_ name_ex %%%/;
	# token wrap_variable				=> q/%%%CLASS_CODE_ name_ex %%%/;


	token EOP 						=> q/(?:\n\n|\Z)/;
	token CUT 						=> q/(?:\n=cut.*EOP)/;
	token POD 						=> q/(?:^=(?:head[1-4]|item).*?CUT|^=pod.*?CUT|^=for.*?CUT|^=begin.*?CUT)/;
	token DATA 						=> q/(?:^__DATA__\r?\n.*)/;
	token END 						=> q/(?:^__END__\r?\n.*)/;

	token text						=> q/(?:qtext|textqq|textqw)/;

########################################################################################
	# token textqq					=> q/(?:\'[^\\\]*?\' | \'[^\']content[^\\\]\')/;
	# token textqw					=> q/(?:\"[^\\\]*?\" | \"[^\"]content[^\\\]\")/;
    # token textqa					=> q/(?:\`[^\\\]*?\` | \`[^\`]content[^\\\]\`)/;

    token textqq					=> q/(?:\'\'|\'(?(?<!\\\)[^\']|.)*?[^\\\]\')/;
	token textqw					=> q/(?:\"\"|\"(?(?<!\\\)[^\"]|.)*?[^\\\]\")/;
    token textqa					=> q/(?:\`\`|\`(?(?<!\\\)[^\`]|.)*?[^\\\]\`)/;
########################################################################################

	token regex						=> q/qregex_s|qregex_m/;

	token qregex_m					=> q/(?<REGEX_MATH>\bm\b)\s*(?:REGEXNOMATH
		|in_paren
		|in_brace
		|in_square
		|in_angle
		|in_slash
	)/;

	# token qregex_s					=> q/\bs\b\s*(?:REGEXNOMATH
	token qregex_s					=> q/(?<REGEX_REPLACE>\bs\b)\s*(?:REGEXNOMATH
		|in_paren \s* in_paren
		|in_brace \s* in_brace
		|in_square \s* in_square
		|in_angle \s* in_angle
		|in_slash_regex
	)/;

	token qtext					   => q/qvar\s*(?:NOMATH
        |in_paren
        |in_brace
        |in_square
        |in_angle
        |in_slash
        |textqq
        |textqw
        |textqa
        |in_char
    )/;

	token qvar						=> q/\bq[qwr]?\b/;
	token qquote					=> q/qvar/;

########################################################################################
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

	# token unblk_pref				=> q/[\}\;]\s*/;
    token unblk_pref				=> q/(?:\}|\;|\%\%\%)\s*/;

	token condition					=> q/content/;
	token STATEMENT					=> q/content/;
	token THEN						=> q/content/;
	token ELSE						=> q/content/;

	token op_regex					=> q/[=!]\~/;
	token op_regex_all				=> q/[=!]\~\s*[ms]/;
	token op_regex_m				=> q/[=!]\~\s*m/;
	token op_regex_s				=> q/[=!]\~\s*s/;

	token op_scalar					=> q/\b(?:split)\b/;
    token op_array					=> q/\b(?:map|grep|join|reverse|sort|pop|push|shift|unshift|size|slice)\b/;
	token op_hash					=> q/\b(?:keys|values|each)\b/;
	token op_reverse				=> q/\b(?:reverse)\b/;

	# token op_array1					=> q/\b(?:pop|push|shift|slice|unshift|sort)\b/;
    token op_sort_blockless         => q/\bsort\b(?!\s*\{)/;
    token op_array_block            => q/\b(?:map|grep|sort)\b/;
    token op_array_hash             => q/\b(?:keys|values|each|map|grep|join|reverse|pop|push|shift|unshift|splice)\b/;
    # token op_array_hash             => q/(?<!name_ops\s+)\b(?:keys|values|each|map|grep|join|reverse|pop|push|shift|unshift|size|splice)\b/;
    # token op_array_hash             => q/\b(?:keys|values|each|map|grep|join|reverse|pop|push|shift|unshift|size|splice)\b (?! \s+ [\@\%] )/;
    # token op_ahref_expr			    => q/\b(?:keys|values|each|reverse|pop|shift|size)\b/;
    token op_arr2arr_sort			=> q/\b(?:sort)\b/;
    token op_arr2scl    			=> q/\b(?:join|push|unshift)\b/;
	token op_array2					=> q/\b(?:pop|shift|slice|unshift|sort)\b/;
	# token op_array2					=> q/\b(?:grep|map|sort)\b/;
	token op_array3					=> q/\b(?:join)\b/;

    token ret_arr_ops				=> q/\b(?:map|grep|reverse|sort|keys|values|each)\b/;

    # &var_IO_REF                   = {
    #     keys    => ['__RISE_R2H', '__RISE_A2R'],
    #     values  => ['__RISE_R2H', '__RISE_A2R'],
    #     each    => ['__RISE_R2H', '__RISE_A2R'],
    #     reverse => ['__RISE_R2', '__RISE_2R'],
    #     pop     => ['__RISE_R2A',''],
    #     shift   => ['__RISE_R2A',''],
    #     size    => ['__RISE_R2A',''],
    # };

	token space_try					=> q/(?![\n\r])\s\s/;

	token sigils					=> q/[\@\$\%\&\*]/;
	token sigil_S					=> q/\$/;
	token paren_L					=> q/\(/;
	token paren_R					=> q/\)/;
    token wrap_code                 => q/%%%WRAP_CODE_.*?%%%/;
    token wrap_code_header          => q/%%%WRAP_CODEHEADER_.*?%%%/;
    token wrap_variable             => q/%%%WRAP_VARIABLE_.*?%%%/;

	################################################## rules ####################################################
	#rule _									=> q/<all>/;

	rule _excluding							=> q/<excluding>/;
	rule _nonamedblock						=> q/<unblk_pref><block_brace>/;
    rule _auth                              => q/<auth> <name>/;
    rule _vers                              => q/<vers> <number>/;
	rule _namespace							=> q/<namespace> <name> <block_brace>/;

	rule _inject							=> q/<inject> <content> <op_end>/;
	rule _using								=> q/<using> <name>[<content>]<op_end>/;
	rule _inherits							=> q/<inherits> <name>/;
	rule _implements						=> q/<implements> <name_list>/;

	rule _class								=> q/[<accessmod_class>] <class> <name> [<content>] <block_brace>/;
	rule _class_ops							=> q/<new> <name>/;
	# rule _class								=> q/[<accessmod_class>] <class> <name> [<code_args>] [<content>] <block_brace>/;
	rule _abstract							=> q/<abstract> <name> [<content>] <block_brace>/;
	rule _interface							=> q/<interface> <name> [<content>] <block_brace>/;
	rule _interface_set						=> q/[<accessmod_class>] <object_members> <name> <op_end>/;

	rule _for								=> q/<for_each> \( [<variable>] <name> \=<condition> \) [<block_brace>]/;
	rule _foreach							=> q/<for_each> <block_paren> [<block_brace>]/;
	rule _foreach_var						=> q/<for_each> [<variable>] <name> <block_paren> [<block_brace>]/;
    rule _for_foreach_array                 => q/<op_for_each> \( <ret_arr_ops>/;
    # rule _for_foreach_array                 => q/<op_for_each> \(  (_NOT:__RISE_R2A) <ret_arr_ops>/;
    # rule _for_foreach_array                 => q/<op_for_each> \( (_NOT:__RISE_R2A) (<ret_arr_ops>|<self_name>)/;
	rule _foreach_arr						=> q/<op_for_each> <block_paren> [<block_brace>]/;

	#rule _for_foreach						=> q/<for_each> [<variable>] [<name>] \(<condition>\) [<block_brace>]/;

	# rule _while								=> q/<while> \( <variable> <name> <condition>\) [<block_brace>]/;
    rule _while								=> q/<while> \(<condition>\) [<block_brace>]/;

	rule _regex_match						=> q/<regex_match>[ \:<regex_mods>][ [<sigils>]<regex_sorce>
                                                <comma_long_short>] [<not>](<regex_pattern_txt>|<self_name>)/;
	rule _regex_replace						=> q/<regex_replace>[ \:<regex_mods>][ [<sigils>]<regex_sorce>
												<comma_long_short>] [<not>](<regex_pattern_txt>|<self_name>)
												<comma_long_short> (<regex_expr_txt>|<regex_expr_block>|<self_name> <code_args>)/;

    rule _member_name                       => q/<name>/;
    rule _member_name_class				    => q/(_NOT:\#)<name>(NOT:\#)/;
	# rule _member_name_function				=> q/<name>/;
	rule _member_name_function				=> q/(_NOT:\$)<name>/;

	rule _variable_list						=> q/[<accessmod>] <variable> \( <name_list_wtype> \) [<op_end>]/;
	rule _variable_observe					=> q/[<accessmod>] <variable> <name> [<member_type>]/;
	# rule _varconst_observe					=> q/[<accessmod>] (<variable>|<constant>) <name> [<member_type>]/;
	# rule _variable_boost					=> q/(_NOT:sigils|\.)(_NOT:sub\s)<name>/;
    # rule _variable_boost					=> q/(_NOT:sigils|\.|\:)(_NOT:sub\s)(_NOT:new\s)(_NOT:require\s)<name>/;
	# rule _variable_boost					=> q/(_NOT:sigils|\.|\:)(_NOT:sub\s)<var_all>/;
	rule _variable_optimize					=> q/variable \$/;
	#rule _variable_boost					=> q/((_NOT:sigils)(_NOT:sub)<spss>)<name>/;
	#rule _variable_boost					=> q/(_NOT:__VARBOOSTED__)(_NOT:sigils)<name>/;
	rule _variable_compile			        => q/[<accessmod>] <variable> <name> [<member_type>] [<op_end>]/;
	rule _variable_compile_class			=> q/[<accessmod>] <variable> <name> [<member_type>] [<op_end>]/;
	rule _variable_compile_function			=> q/[<accessmod>] <variable> <name> [<member_type>] [<op_end>]/;
	rule _constant_compile					=> q/[<accessmod>] <const> <name> = <content> <op_end>/;
    rule _variable_call					    => q/(_NOT:op_dot)<name>(NOT:%)/;
    # rule _variable_call					    => q/((_NOT:op_dot) |(_NOT:\$))<name>(NOT:%)/;

	# rule _variable_boost_post				=> q/__VARBOOSTED__/;
	# rule _variable_boost					=> q/<word> (_NOT:sigils)<name>/;
	# rule _var_boost2						=> q/(_NOT:sigils|\.)(_NOT:sub\s)<var_all>/;
	# rule _var_boost_post1					=> q/_var_ \$/;
	# rule _var_boost_post2					=> q/\.\$/;



    rule _function_observe 					=> q/[<accessmod>] [<override>] <function> <name> [<code_args>] [<code_type>] <block_brace>/;

    # rule _function_compile 							=> q/[<accessmod>] <function> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
    # rule _function_compile 							=> q/[<accessmod>] [<override>] <function> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
    rule _function_compile 					=> q/[<accessmod>] [<override>] <function> [<name>] [<code_args>] [<code_type>] <block_brace>/;
	rule _function_defs 					=> q/[<accessmod>] <function> [<args_attr>] <op_end><nline>/;
	# rule _function_call					=> q/(_NOT:__METHOD__)<name> \( (NOT:__PACKAGE__)/;
	# rule _function_call					    => q/(_NOT:op_dot)<name> \((NOT: \$self_pkg)/;
	rule _function_call					    => q/(_NOT:op_dot)<name> \((NOT: self_con)/;
	# rule _function_call					=> q/(_NOT:op_dot)(NOT:<name_ops>)<name> \((NOT: __PACKAGE__)/;
	rule _function_call_post1				=> q/(__METHOD__)+/;
	# rule _function_call_post2				=> q/self_pkg\,\)/;
	rule _function_call_post2				=> q/<self_con>\,\)/;

    rule _thread_compile 					=> q/[<accessmod>] <thread> [<name>] [<code_args>] [<code_attr>] <block_brace>/;
    # rule _thread_call					    => q/(NOT:__METHOD__)<name> \( (NOT:$self_pkg)/;
    # rule _thread_call					    => q/(_NOT:op_dot)<name> \((NOT: $self_pkg)/;
    rule _thread_call					    => q/(_NOT:op_dot)<name> \((NOT: self_con)/;
    rule _thread_call_post1				    => q/(__METHOD__)+/;
    # rule _thread_call_post2				    => q/self_pkg\,\)/;
    rule _thread_call_post2				    => q/<self_con>\,\)/;

	# rule _op_regex							=> q/<sigils><self_name> <op_regex> REGEX_MATH/;
	rule _op_regex							=> q/<spec_name> <op_regex> REGEX_MATH/;
	# rule _op_regex							=> q/ <equal> <spec_name> <op_regex> REGEX_MATH/;
    # rule _op_regex							=> q/<symbol><regex_m_want> <spec_name> <op_regex> REGEX_MATH/;
	# rule _op_regex							=> q/<spec_name> <op_regex> (REGEX_MATH|REGEX_REPLASE)/;
	# rule _op_regex							=> q/<spec_name> <op_regex> <regex_pattern_txt>/;
	# rule _op_regex							=> q/<equal> <spec_name> <op_regex> (REGEX_MATH|REGEX_REPLASE)/;
	# rule _op_regex							=> q/<equal> <spec_name> <op_regex_m>/;
	rule _op_scalar							=> q/(_NOT:(OR:\-\>op_dot))<op_scalar>/;
	# rule _op_scalar							=> q/(_NOT:(OR:\-\>op_dot))<op_scalar> <string>\,/;
	# rule _op_scalar							=> q/<op_scalar> <string>\,/;
    # rule _op_array							=> q/<op_array>/;
	# rule _op_hash							=> q/<op_hash>/;

    # rule _op_arref_block					=> q/<op_arref_block> <block_brace>/;
    rule _op_sort_blockless					=> q/<op_sort_blockless>/;
    rule _op_array_block					=> q/<op_array_block> \{/;
    rule _op_array_hash 					=> q/(_NOT:(OR:\-\>op_dot))<op_array_hash>/;
    rule _op_for_each                       => q/(<op_for_each>|<op_for_each_cond>)/;

    # rule _context                           => q/(_NOT:sigils)\b_\b/;
	rule _comma_quarter 					=> q/<name_ops> <name_dot_list>/;
	# rule _comma_quarter 					=> q/<name_ops> <self_name>/;

    # rule _op_dot							=> q/(_NOT:op_dot) <op_dot> (NOT:op_dot)/;
    # rule _op_dot							=> q/<op_dot>(NOT:(OR:\W\d\.))/;
    rule _op_dot							=> q/<op_dot2>/;
    # rule _op_dot							=> q/(NOT:\.)<op_dot>(NOT:(OR:\d\.))/;
    # rule _op_dot							=> q/(_NOT:op_dot) <op_dot> (NOT:(OR:\W\d\.))/;

    # rule _op_dot							=> q/(_NOT:(OR:\s\W))op_dot(NOT:(OR:\s\d\.))/;
	# rule _op_dot							=> q/<op_dot>(NOT:(OR:\s\d\.))/;
	# rule _op_dot							=> q/op_dot(NOT:\d)/;
	# rule _op_dot							=> q/op_dot <word>/;
	# rule _op_dot							=> q/<op_dot>/;
	rule _concat							=> q/<concat>/;
	rule _optimize4 						=> q/\s+\;/;
	#rule _optimize5 						=> q/\s\s+(_NOT:\n|\t)/;
	rule _optimize5 						=> q/space_try/;
	rule _optimize6 						=> q/_UNNAMEDBLOCK_/;
	rule _optimize7 						=> q/__RISE_R2A __RISE_(A)?2R/;
	rule _optimize71 						=> q/__RISE_R2A (__RISE_R2A )+/;
	rule _optimize8 						=> q/REGEX_MATH/;
	rule _optimize9							=> q/<regex_pattern_block>/;
	rule _including							=> q/<including>/;
	rule _unwrap_code						=> q/<all>/;
	rule _unwrap_code_header				=> q/<all>/;
	rule _unwrap_code_footer				=> q/<all>/;
    rule _unwrap_variable					=> q/<all>/;
    rule _unwrap_observe					=> q/<all>/;

	rule _commentC							=> q/<comment_C>/;

	############################# post rules ########################################

	############################# actions ########################################
	#action _								=> \&_;

	action _excluding 						=> \&_syntax_excluding;
	action _nonamedblock					=> \&_syntax_nonamedblock;

	action _auth 						    => \&_syntax_auth;
	action _vers 						    => \&_syntax_vers;
	action _namespace 						=> \&_syntax_namespace;
	action _class 							=> \&_syntax_class;
	action _class_ops 					    => \&_syntax_class_ops;
	action _abstract 						=> \&_syntax_abstract;
	action _interface 						=> \&_syntax_interface;
	action _interface_set					=> \&_syntax_interface_set;
	action _inject 							=> \&_syntax_inject;
	action _using 							=> \&_syntax_using;
	action _inherits			 			=> \&_syntax_inherits;
	action _implements 						=> \&_syntax_implements;

	action _for 							=> \&_syntax_for;
	action _foreach 						=> \&_syntax_foreach;
	action _foreach_var 					=> \&_syntax_foreach_var;
	action _foreach_arr 					=> \&_syntax_foreach_arr;
	action _for_foreach_array 				=> \&_syntax_for_foreach_array;

	action _while 							=> \&_syntax_while;

	action _regex_match						=> \&_syntax_regex_match;
	action _regex_replace					=> \&_syntax_regex_replace;

    action _function_observe 				=> \&_syntax_function_observe;
	action _function_defs 					=> \&_syntax_function_defs;
	action _function_compile 				=> \&_syntax_function_compile;
	action _function_call					=> \&_syntax_function_call;
	action _function_call_post1				=> \&_syntax_function_call_post1;
	action _function_call_post2				=> \&_syntax_function_call_post2;
	action _member_name				        => \&_syntax_member_name;
	action _member_name_class				=> \&_syntax_member_name_class;
	action _member_name_function			=> \&_syntax_member_name_function;

	action _thread_compile 					=> \&_syntax_thread_compile;
	action _thread_call                     => \&_syntax_thread_call;
	action _thread_call_post1			    => \&_syntax_thread_call_post1;
	action _thread_call_post2			    => \&_syntax_thread_call_post2;

	action _variable_list 					=> \&_syntax_variable_list;
	action _variable_compile			    => \&_syntax_variable_compile;
	action _variable_compile_class			=> \&_syntax_variable_compile_class;
	action _variable_compile_function		=> \&_syntax_variable_compile_function;
	action _constant_compile 				=> \&_syntax_constant_compile;
	action _variable_observe				=> \&_syntax_variable_observe;
	# action _varconst_observe				=> \&_syntax_varconst_observe;
	# action _variable_boost					=> \&_syntax_variable_boost;
	action _variable_optimize				=> \&_syntax_variable_optimize;
	# action _variable_boost_post				=> \&_syntax_variable_boost_post;
	action _variable_call				    => \&_syntax_variable_call;

	action _unwrap_code						=> \&_syntax_unwrap_code;
	action _unwrap_code_header				=> \&_syntax_unwrap_code_header;
	action _unwrap_code_footer				=> \&_syntax_unwrap_code_footer;
    action _unwrap_variable				    => \&_syntax_unwrap_variable;
    action _unwrap_observe				    => \&_syntax_unwrap_observe;

	action _op_regex						=> \&_syntax_op_regex;

    action _op_scalar	        	        => \&_syntax_op_scalar;

    action _op_sort_blockless	        	=> \&_syntax_op_sort_blockless;
    action _op_array_block	        		=> \&_syntax_op_array_block;
    action _op_array_hash	        		=> \&_syntax_op_array_hash;
    action _op_for_each	        		    => \&_syntax_op_for_each;

	action _comma_quarter					=> \&_syntax_comma_quarter;
	action _op_dot							=> \&_syntax_op_dot;
	action _concat							=> \&_syntax_concat;
	action _optimize4		 				=> \&_syntax_optimize4;
	action _optimize5		 				=> \&_syntax_optimize5;
	action _optimize6		 				=> \&_syntax_optimize6;
	action _optimize7						=> \&_syntax_optimize7;
	action _optimize71						=> \&_syntax_optimize71;
	action _optimize8						=> \&_syntax_optimize8;
	action _optimize9						=> \&_syntax_optimize9;

	action _including						=> \&_syntax_including;
	action _commentC 						=> \&_syntax_commentC;

	# order(var 'parser__');
	order(&var_parser__);

	#print dump(order);
	# print &tk_function;
	# print rule '_op_for_each';
	# print "\n";
	# print rule '_op_dot';
	# print "\n";

    # $self->syntax->{RULE}             = $self->grammar->compile_RBNF($self->syntax->{RULE});
    grammar->{RULE}		= compile_RBNF(grammar->{RULE});

}

#$parser->grammar = grammar;

sub compile {
	my $self			= shift;
	my $source			= shift;
	# my $source2			= shift;
	# say '-------- syntax compile ---------';
	# say $source;
	# say '---------------------------------';
	$self->parse ($source, grammar);
}

# sub rules { grammar }
#sub parser { $parser }

#######################################################################################
#sub parse_parser_qr {'(?^<word>:<content>)'}

sub __add_stack {
	my $class_list			= shift; $class_list =~ s/\s+//gsx;
	my $apppath				= $class_list; $apppath	=~ s/\:\:/\//gsx;
	push @{&var_app_stack}, (split /\,/, $apppath) if $class_list;
	return 1;
}

sub parse_parser_list_iter {
	my $list 		= &name_list;
	my $name		= &tk_name;

	my ($before, $after) = &content =~ m/(.*)_LI_(.*)/;
	$list =~ s/($name)\,?/$before.$1.$after/gsxe;

	return $list;
}

sub parse_parser_if {
	my $res = '';

	if ( eval &condition ) {
		$res = &THEN;
	} else {
		$res = &ELSE;
	};

	return $res;
}
#######################################################################################


#-------------------------------------------------------------------------------------< excluding_ON

sub _syntax_commentC {
	my $comment = &comment_C;
	$comment =~ s/^\/\//\#/gsx;
	return $comment;
}

sub _syntax_excluding {
		my $opt			= '';

		$opt = 'REGEX_MATH' if $+{REGEX_MATH};

		push @{&var_excluding}, &excluding;
		return $opt . '%%%TEXT_' . sprintf("%03d", $#{&var_excluding}) . '%%%';
}

sub _syntax_including {
    my ($self, $rule_name, $confs)			= @_;
    $self->{NOPARSE}    = 1;
	my $including		= &including;
	my $res				= 'NOMATH';
	$including			=~ s/%%%TEXT_(\d+)%%%/$1/gsx;
	$res				= &var_excluding->[$including] if $including;
	return $res;
}

sub _syntax_unwrap_code {
	# say 'unwrap_code';
	my $all				= &all;
	my $res				= '';
	1 while $all =~ s/%%%WRAP_CODE_(\w+(?:::\w+)*)%%%/&var_wrap_code->{$1}||''/gsxe;
	return $all;
}

sub _syntax_unwrap_code_header {
	my $all				= &all;
	my $res				= '';
	1 while $all =~ s/%%%WRAP_CODEHEADER_(\w+(?:::\w+)*)%%%/&var_wrap_code_header->{$1}||''/gsxe;
	return $all;
}

sub _syntax_unwrap_code_footer {
	my $all				= &all;
	my $res				= '';
	1 while $all =~ s/%%%WRAP_CODEFOOTER_(\w+(?:::\w+)*)%%%/&var_wrap_code_footer->{$1}||''/gsxe;
	return $all;
}

sub _syntax_unwrap_variable {
    my $all				= &all;
    my $res				= '';
    1 while $all =~ s/%%%WRAP_VARIABLE_(\w+(?:::\w+)*)%%%/&var_wrap_variable->{$1}||''/gsxe; #die ("ERROR UNWRAP: " . $1) if exists &var_wrap_code->{$1};
    return $all;
}

sub _syntax_unwrap_observe {
    my $all				= &all;
    my $res				= '';
    1 while $all =~ s/%%%WRAP_OBSERVE_(\w+(?:::\w+)*)%%%/&var_wrap_observe->{$1}||''/gsxe; #die ("ERROR UNWRAP: " . $1) if exists &var_wrap_code->{$1};
    return $all;
}

#-------------------------------------------------------------------------------------< inject | using | inherits | implements
sub _syntax_inject {
	my ($self, $rule_name, $confs)			= @_;
	my $content				= &content;
	$content 				=~ s/\<TEXT_(\d+)\>/&var_excluding->[$1]/gsxe;
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

sub _syntax_for {
    my ($self, $rule_name, $confs)			= @_;
    my $parent_class        = $confs->{parent};
    my $name			= &name;
    my $cond			= &condition;
    my $block			= &block_brace;
    my $for             = '';
    my $for_each        = '';
    my ($sps1,$sps2,$sps3,$sps4,$sps5,$sps6) = (&sps1,&sps2,&sps3,&sps4,&sps5,&sps6);

    $for_each           = '__FOR_COND__' if &for_each eq 'for';
    $for_each           = '__FOREACH_COND__' if &for_each eq 'foreach';

    # $block 				= $self->parse($block, &grammar, [@{&var_parser_loops}], { parent => $parent_class });

    $for 				= $for_each.$sps1.' ('.$sps3.$name.' ='.$sps4.$cond.$sps5.')'.$sps6.$block;
	$for 				= '{ <kw_local> '.$sps2.'<variable> '.$name.'; '.$for.'}' if &variable;

    say ">>> FOR " . $for;

    return $for;
    # return "{ <kw_local> <variable> <name>; $for_each...(...<name>...<condition>...)...$block}";
}

sub _syntax_foreach {
	my ($self, $rule_name, $confs)			= @_;
    my $parent_class    = $confs->{parent};
    # my $members_list    = &var_members->{$parent_class} || '';
    my $for_each        = '';
	my $cond			= &block_paren;
    my $block			= &block_brace;
	my $tk_self_name	= &tk_self_name;
	my $tk_sigils		= &tk_sigils;
    my ($sps,$sigil,$name)     = $cond =~ m/^\((\s*)($tk_sigils)?($tk_self_name)/sx;

    # &var_members->{$parent_class} .= ' local-var-'.$name if &variable;
    # &var_members->{$parent_class} =~ s/^\s+//;

    $for_each           = '__FOR__' if &for_each eq 'for';
    $for_each           = '__FOREACH__' if &for_each eq 'foreach';

    $cond               = __for_arr($parent_class, $cond);
    # $cond 				= $self->parse($cond, &grammar, [@{&var_parser_variable}], { parent => $parent_class });
    $block 				= $self->parse($block, &grammar, [@{&var_parser_loops}], { parent => $parent_class });

	return "$for_each...($cond)...$block";
}

sub _syntax_foreach_var {
	my ($self, $rule_name, $confs)			= @_;
    my $parent_class        = $confs->{parent};
    # my $members_list        = &var_members->{$parent_class} || '';
    my $for_each        = '';
    my $kw_var			= &variable;
	my $name			= &name;
	my $cond			= &block_paren;
	my $block			= &block_brace;
	my $tk_self_name	= &tk_self_name;
	my $tk_sigils		= &tk_sigils;
    # my ($sps,$sigil,$self_name)     = $cond =~ m/^\((\s*)($tk_sigils)?($tk_self_name)/sx;
	my $for				= '';

    # &var_members->{$parent_class} .= ' local-var-'.$name if &variable;
    # &var_members->{$parent_class} =~ s/^\s+//;

    $for_each           = '__FOR__' if &for_each eq 'for';
    $for_each           = '__FOREACH__' if &for_each eq 'foreach';
	# $name				= '<name> = $_;' if $name;
    $cond               = __for_arr($parent_class, $cond);

    # $cond                           =~ s/\((.*)\)/$1/sx;
    # $cond                           =~ s/^(\s*)($tk_sigils)?($tk_self_name)/$1.'__RISE_R2A '.($2||'').$3/sxe;
	# $cond                           =~ s/^(\s*)(\[.*?\])$/$1 __RISE_R2A $2/sx;

    # $cond                           = $self->parse($cond, &grammar, [@{&var_parser_variable}], { parent => $parent_class });

    if ($block) {
        $block 				=~ s/\{(.*)\}/$1/gsx;
        $block 				= $self->parse($block, &grammar, [@{&var_parser_loops}], { parent => $parent_class });
    	$block				= '{ '.$name.' = $_;'.$block.'}';
    }

    # $for 				= $for_each.'<sps1>('.$cond.')<sps4>'.$block;
    $for 				= $for_each.&sps1.'('.$cond.')'.&sps2.$block;
	$for 				= '{ '.&kw_local.' '.$kw_var.&sps2.$name.&sps3.'; '.$for.'}' if $kw_var;

	return $for;
}

sub _syntax_for_foreach_array {

    # print ">>>>>>>>>>> FOR_FOREACH_ARRAY \n";

    # my ($self, $rule_name, $confs)			= @_;
    # my $for_each            = '';
    # my $self_name           = &self_name;
    # my $parent_class        = $confs->{parent};
    # my $members_list        = &var_members->{$parent_class} || '';
    # my $tk_accmod           = &tk_accessmod;
    # my $tk_self			      = &tk_self;
    # my $R2A                 = '__RISE_R2A';

    # $for_each           = '__FOR__' if &for_each eq 'for';
    # $for_each           = '__FOREACH__' if &for_each eq 'foreach';

    # return "<for_each>...( $R2A ...<ret_arr_ops><self_name>";
    # return "$for_each...( $R2A ...<ret_arr_ops>";
    return "<op_for_each>...( __RISE_R2A...<ret_arr_ops>";
}

sub _syntax_foreach_arr {
    my ($self, $rule_name, $confs)			= @_;
    my $parent_class    = $confs->{parent};
    my $members_list    = &var_members->{$parent_class} || '';
    my $for_each        = &op_for_each;
	my $cond			= &block_paren;
    my $block			= &block_brace;
	my $tk_self_name	= &tk_self_name;
	my $tk_sigils		= &tk_sigils;
    my $ret_arr_ops     = &tk_ret_arr_ops;
    # my ($name)          = $cond =~ m/^\(\s*\@\s+$tk_sigils?($tk_self_name)/sx;
    my ($name)          = $cond =~ m/^\(\s*\@\s*\{\(\s*$tk_sigils?($tk_self_name)/sx;

    # print ".$name.\n";


    # $name                           ||= '';
    $members_list		            = join ('\b|\b', $members_list =~ /\b\w+\-(?:const|var|function|thread)\-(\w+)\b/gsx);
    # $cond                           =~ s/\@//sx if $name && $members_list && $name !~ m/$ret_arr_ops/sx && $name !~ m/\b(?:$members_list)\b/sx;
    $cond                           =~ s/^\(\s*\@\s*\{\((.*?)\)\}\s*\)$/($1)/sx if $name && $members_list && $name !~ m/$ret_arr_ops/sx && $name !~ m/\b(?:$members_list)\b/sx;
    # $cond                           =~ s/\@\s*($ret_arr_ops)/__RISE_R2A $1/gsx;

    # print $name . "\n" if $name;
    # print $cond ."\n";

    # $for_each           = '__FOR__' if &for_each eq 'for';
    # $for_each           = '__FOREACH__' if &for_each eq 'foreach';

    # $cond               = __for_arr($parent_class, $cond);
    # $cond 				= $self->parse($cond, &grammar, [@{&var_parser_variable}], { parent => $parent_class });
    $block 				= $self->parse($block, &grammar, [@{&var_parser_loops}], { parent => $parent_class });

	return "$for_each...$cond...$block";
}

sub _syntax_while {
    my ($self, $rule_name, $confs)			= @_;
    my $parent_class        = $confs->{parent};
    my $block			= &block_brace;
    my $condition		= &condition;
    my $tk_self_name	= &tk_self_name;
	my $tk_sigils		= &tk_sigils;

    $condition			=~ s/^($tk_sigils)?($tk_self_name)/'__RISE_R2A '.($1||'').$2/sxe;

    # $block 				= $self->parse($block, &grammar, [@{&var_parser_loops}], { parent => $parent_class });

    return "<while>...(...$condition...)...$block"
}

sub __for_arr {
    my ($parent_class, $cond)		= @_;
    my $tk_self_name	            = &tk_self_name;
	my $tk_sigils		            = &tk_sigils;
    # my $members_list                = &var_members->{$parent_class} || '';
    # my ($sps,$sigil,$name)          = $cond =~ m/^\((\s*)($tk_sigils)?($tk_self_name)/sx;
    my $R2A                         = '@ ';
    # my $R2A                         = '';

    # $name                           ||= '';
    # $members_list		            = join ('\b|\b', $members_list =~ /\b\w+\-(?:const|var|function|thread)\-(\w+)\b/gsx);
    # $R2A                            = '__RISE_R2A' if $members_list && $name =~ m/\b(?:$members_list)\b/gsx;

    $cond                           =~ s/\((.*)\)/$1/sx;
    $cond                           =~ s/^(\s*)($tk_sigils)?($tk_self_name.*?)$/$1.$R2A.'{('.($2||'').$3.')}'/sxe;
	$cond                           =~ s/^(\s*)(\[.*?\])$/$1 $R2A\{\($2\)\}/sx;

    say ">>> $cond";

    # print "$R2A - $name\n";
    # print $parent_class ."\n";
    # print $name . "\n" if $name;
    # print $members_list ."\n";

    return $cond;
    # return '@{'.$cond.'}';
}

# sub __for_arr {
#     my ($name, $parent_class)		= @_;
#     my $members_list        = &var_members->{$parent_class} || '';
#     my $R2A                 = '';
#
#     $members_list		= join ('\b|\b', $members_list =~ /\b\w+\-(?:const|var|function|thread)\-(\w+)\b/gsx);
#     $R2A = '__RISE_R2A' if $members_list && $name =~ m/\b(?:$members_list)\b/gsx;
#
#     print "$R2A - $name\n";
#     # print $parent_class ."\n";
#     # print $name . "\n" if $name;
#     print $members_list ."\n";
#
#     return $R2A;
# }
#-------------------------------------------------------------------------------------< regex
sub _syntax_regex_match {
	my $re_op			= &not || '=';
	my $pattern			= '%%%REGEXBLOCK'.&regex_pattern_txt.'REGEXBLOCK%%%' if &regex_pattern_txt;
	my $mods			= &regex_mods;
    my $source          = '';

    # $source             = '__RISE_A2R <sigils><regex_sorce>' if &regex_sorce;
    $source             = '<sigils><regex_sorce>' if &regex_sorce;
	$pattern			||= '{'.&self_name.'}';
    $re_op              .= '~<sps4>';
    $re_op              = '' if !&regex_sorce;

	# return "${source}<sps3>${re_op}m<sps1>${pattern}${mods}";
	return "${source}<sps3>${re_op}REGEX_MATHm<sps1>${pattern}${mods}";
}

sub _syntax_regex_replace {
	my $re_op			= &not || '=';
	my $pattern			= '%%%REGEXBLOCK'.&regex_pattern_txt.'REGEXBLOCK%%%' if &regex_pattern_txt;
	my $expr_block		= &regex_expr_block;
	my $mods			= &regex_mods;

	$mods				.= 'e' if &regex_expr_block;
	$pattern			||= '{'.&self_name.'}';
    $re_op              .= '~<sps4>';
    $re_op              = '' if !&regex_sorce;
	$expr_block			||= '%%%REGEXBLOCK'.&regex_expr_txt.'REGEXBLOCK%%%';

	return "<sigils><regex_sorce><sps3>${re_op}s<sps1>${pattern}${expr_block}${mods}";
}

#-------------------------------------------------------------------------------------< member name

sub  _syntax_member_name {
    return ''.&name;
}

sub  _syntax_member_name_class {
    my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent}; # || &var_className;
	my $parent_type     = $confs->{parent_type}||'';
	my $name			= &name;
	# my $fncall_self		= '';
	# my $tk_accmod		= &tk_accessmod;
	# my $fn_list			= &var_members->{$parent_class}||'';
	# my $method			= '__METHOD__';
	my $members_list	= &var_members->{$parent_class}||'';
    my $lable           = '';
    # my $res;

    $members_list = join '\b|\b', $members_list =~ m/\w+\-\w+\-(\w+)/gsx;
    if ($members_list && $name =~ m/^\b(?:$members_list)\b$/sx) {
        $lable = &var_memberPref;
    }

    # $members_list		=~ s/\w+\-//gsx;
    # $members_list		=~ s/\s+/\\b\|\\b/gsx;
    # $members_list       = '\b'.$members_list.'\b';
    # $members_list		=~ s/\w+\-\w+\-//gsx;
    # if ($members_list && $name =~ m/(?:$members_list)/sx) {
    #     $lable = &var_memberPref;
    # }

    # say ">>>> $parent_type - $lable$name";

    return $lable.$name;
}

sub  _syntax_member_name_function {
    my ($self, $rule_name, $confs)			= @_;
	my $parent_class       = $confs->{parent};
	# my $parent_type     = $confs->{parent_type}||'';
	my $name               = &name;
    my $name_full          = $parent_class . '::' . $name;
    my $name_selected;
    my $members_list       = '';
    my $lable              = '';

    # say "### $name_full";
    foreach my $n ($name_full =~ m/(\w+)/gsx){
        $name_selected      .= $n;
        $members_list       .= ' ' . join ' ', (&var_members->{$name_selected}||'') =~ m/\w+\-\w+\-(\w+)/gsx;
        $name_selected      .= '::';
    }

    $members_list           =~ s/^\s+(.*?)\s+$/$1/sx;
    $members_list           =~ s/\s+/\\b\|\\b/gsx;
    $members_list           = '\b' . $members_list . '\b';

    if ($members_list && $name =~ m/^\b(?:$members_list)\b$/sx) {
        $lable = &var_memberPref;
    }

    # say "$parent_class::$name - $members_list";

    return $lable.$name;
}

#-------------------------------------------------------------------------------------< variable
sub _syntax_nonamedblock {
	my $block			= &block_brace;
	my $unblk_pref		= &unblk_pref;
	my $tk_accmod		= &tk_accessmod;
	my $tk_var			= &tk_variable;
	my $tk_const		= &tk_constant;

	$block 				=~ s/\b(?:$tk_accmod)?\s*($tk_var|$tk_const)/local $1/gsx;

	return "${unblk_pref}_UNNAMEDBLOCK_${block}";
}

sub _syntax_variable_list {
	my ($self, $rule_name, $confs)			= @_;
	my $var_def				= &name_list_wtype;
	my $var_init			= &name_list_wtype;
	my $tk_name				= &tk_name;
	my $tk_name_type		= &tk_name_type;
	my $op_end				= '';

	$var_def				=~ s/($tk_name_type)\,?/<accessmod> <variable> $1;/gsx;
	# $var_init				=~ s/(?<!\$)\b($tk_name)\b(?:\s*\:\s*\w+)?/\$$1/gsx;
	$var_init				=~ s/(?<!\$)\b($tk_name)\b(?:\s*\:\s*\w+)?/$1/gsx;
	$op_end					= " ($var_init) " if !&op_end;

	return $var_def.$op_end;
}

sub _syntax_variable_observe_OFF {
	my ($self, $rule_name, $confs)			= @_;
	my $accmod			= &accessmod || &var_accessmod;
	my $name			= &name;
	my $tk_accmod		= &tk_accessmod;
	my $tk_name			= &tk_name;
    my $parent_class    = $confs->{parent};
	my $members_var		= $accmod.'-var-'.$name;
	my $members_list	= &var_members->{$parent_class} || '';

    my ($s1,$s2,$s3,$s4,$s5,$s6)   = (&sps1,&sps2,&sps3,&sps4,&sps5,&sps6);

    $members_list		=~ s/\s+/\\b\|\\b/gsx;

    warn "ERROR VARIABLE: variable $name redefined in class $parent_class\n" if $members_var =~ /\b$members_list\b/gsx;

	&var_members->{$parent_class} .= ' '.$members_var if $members_var !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
	# &var_members->{$parent_class} .= ' local-var-self' if 'local-var-self' !~ /$members_list/gsx;
	&var_members->{$parent_class} =~ s/^\s+//;
    $members_list = &var_members->{$parent_class};

    #######################################################################################
    $members_list = join ('\b|\b', $members_list =~ m/\b\w+\-var\-($tk_name)\b/gsx);
    $members_list = '\b'.$members_list.'\b';
    #######################################################################################

    # print "$parent_class -> ".$members_list."\n";

	# token var_all			=> $members_list||1;
	# rule _variable_boost	=> q/(_NOT:sigils|\.|\:)(_NOT:sub\s)<var_all>/;

	# rule _variable_boost	=> q/(_NOT:\$self\.|\.|\:)(_NOT:sub\s)<var_all>/;

    # say "$parent_class::$name - $members_list";

	return "$accmod <kw_variable> $name";
	# return "...<kw_variable>...$name";
}

sub _syntax_variable_observe {
	my ($self, $rule_name, $confs)			= @_;
	my $accmod			= &accessmod || &var_accessmod;
    # my $varconst        = &variable || &constant;
	my $name			= &name;
    my $member_type     = &member_type || '';
	# my $tk_accmod		= &tk_accessmod;
	# my $tk_name			= &tk_name;
	my $member          = $accmod.'-var-'.$name.$member_type;
    my $parent_class	= $confs->{parent};

	my $members_list	= &var_members->{$parent_class} || '';
    my ($s1,$s2,$s3,$s4,$s5,$s6)   = (&sps1,&sps2,&sps3,&sps4,&sps5,&sps6);

    # $members_list		=~ s/\s+/\\b\|\\b/gsx;

    # warn "ERROR VARIABLE: variable $name redefined in class $parent_class\n" if $member =~ /\b$members_list\b/gsx;

    &var_members->{$parent_class} .= ' ';
	&var_members->{$parent_class} .= ' '.$member; # if $member !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
	&var_members->{$parent_class} =~ s/^\s+//;

    if ($accmod =~ s/export//sx){

        my @export_tags                 = $accmod =~ m/\:\w+/gsx;
        push @export_tags, ':import' if !$accmod;

        foreach my $t ($name, ':all', ':function', @export_tags){ no strict 'refs';
            &var_exports->{$parent_class}{$t} .= ' '.$name;
            &var_exports->{$parent_class}{$t} =~ s/^\s+//;
            &var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        }
    }

    # say "$parent_class::$name - " . &var_members->{$parent_class};

	return "${accmod} ".&kw_variable." ${name}${member_type}";
}

sub _syntax_variable_boost {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	my $name			= &var_all;
	my $tk_name			= &tk_name;
	my $sigil			= "";
	my $varboost		= "";
	my $members_list	= &var_members->{$parent_class}||'';


	#######################################################################################
	$members_list		= join ('\b|\b', $members_list =~ /\b\w+\-var\-($tk_name)\b/gsx);
    $members_list = '\b'.$members_list.'\b';
	#######################################################################################


	if ($members_list && $name =~ m/\b(?:$members_list)\b/gsx) {
    # if (($members_list && $name =~ m/\b(?:$members_list)\b/gsx) || $name =~ m/\bself\b/gsx) {
		$sigil				= "\$";
		# $sigil				= '$self.';
		$varboost			= "__VARBOOSTED__";
		#print "VAR $parent_class->$name | fnlist - *$members_list* \n";
	}

	return "${sigil}${name}";
	# return '$self.'.$name;
}

sub _syntax_variable_optimize		{ '<kw_variable> ' }

sub _syntax_variable_compile {
	my ($self, $rule_name, $confs)			= @_;

	my $accmod			= &accessmod || &var_accessmod;
	my $name			= &name;
	my $member_type	    = &member_type;
	my $var_type		= '';
	my $var_type_ref	= $name;
	my $var_type_args	= '';
	my $parent_class	= $confs->{parent};
	my $boost_vars		= '';
	my $local_var		= '';
    my $wrap_local      = '';
	my $op_end			= '';
    my $res;

    $accmod             = &kw_public if $confs->{parent_type} eq 'function';

    ############################################# add variable to class members ###############################################
	# my $members_var		= $accmod.'-var-'.$name.$member_type;
    # my $members_list	    = &var_members->{$parent_class}||'';
    #
    # &var_members->{$parent_class} .= ' ';
	# &var_members->{$parent_class} .= ' '.$members_var;
	# &var_members->{$parent_class} =~ s/^\s+//;
    ############################################################################################################################

    if ($confs->{parent_type} eq 'class') {
        # if ($accmod =~ s/export//sx){
        #
        #     my @export_tags                 = $accmod =~ m/\:\w+/gsx;
        #
        #     push @export_tags, ':import' if !$accmod;
        #     $accmod                         = 'public';
        #
        #     foreach my $t ($name, ':all', ':var', @export_tags){ no strict 'refs';
        #         &var_exports->{$parent_class}{$t} .= ' '.$name;
        # 		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
        # 		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        #     }
        # }

        $accmod = '';

    	if (&accessmod eq 'local') {
    		#$accmod			= '';
    		$local_var		= "local *".&var_memberPref."$name; ";
            $wrap_local     = 'local';
    	}

        $var_type_ref = &var_pkg_self."->{'$name'}";
    }

	($var_type, $var_type_args)	= $member_type =~ m/^\:\s*(\w+)(?:\((.*?)\))?$/;
	$var_type_args		= ", ".$var_type_args if $var_type_args;
	$var_type_args		||= '';
    $var_type			= "__PACKAGE__->__RISE_CAST('$var_type', \\\$${var_type_ref}${var_type_args}); " if $var_type;
    $var_type			||= '';

    # say ">>>> " . $var_type . "\n";

	# $op_end				= " \$$name".&op_end." " if !&op_end;
	$op_end				= " $name".&op_end." " if !&op_end;

	$res = "${var_type}${local_var}sub ".&var_memberPref."${name} ():lvalue; *".&var_memberPref."${name} = sub ():lvalue {${accmod} \$".&var_pkg_self."->{'${name}'} };";
    $res = "my \$$name; ${var_type}no warnings; ${local_var}sub ".&var_memberPref."$name ():lvalue; *".&var_memberPref."$name = sub ():lvalue { ${accmod} \$$name }; use warnings;" if $local_var;
    $res = "my \$$name; ${var_type}no warnings; ${local_var}sub ".&var_memberPref."$name ():lvalue; *".&var_memberPref."$name = sub ():lvalue { \$$name }; use warnings;" if $confs->{parent_type} eq 'function';


    &var_wrap_variable->{$wrap_local.$parent_class.'::'.$name} = $res;

	$res = '%%%WRAP_VARIABLE_'.$wrap_local . $parent_class.'::'.$name . '%%% ' . $op_end;

    return $res;
}

sub _syntax_variable_compile_class {
	my ($self, $rule_name, $confs)			= @_;

	my $accmod			= &accessmod || &var_accessmod;
	my $name			= &name;
	my $member_type	    = &member_type;
	my $var_type		= '';
	my $var_type_args	= '';
	my $parent_class	= $confs->{parent};
	my $boost_vars		= '';
	my $local_var		= '';
    my $wrap_local      = '';
	my $op_end			= '';

    my $res;

    ############################################# add variable to class members ###############################################
    # say "PARENT FOR VR >>> " . $parent_class . ": " . $name;
	my $members_var		= $accmod.'-var-'.$name.$member_type;
	my $members_list	= &var_members->{$parent_class}||'';

	$members_list		=~ s/\s+/\\b\|\\b/gsx;

    # say ">>>> " .$members_var;

    # warn "ERROR VARIABLE: variable $name redefined in class $parent_class\n" if $members_var =~ m/\b$members_list\b/gsx;
    &var_members->{$parent_class} .= ' ';
	# &var_members->{$parent_class} .= ' '.$members_var if $members_var !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
	# &var_members->{$parent_class} .= ' '.$members_var if $accmod ne 'local';
	&var_members->{$parent_class} .= ' '.$members_var;
	&var_members->{$parent_class} =~ s/^\s+//;

    # say "MEMBER -> " . &var_members->{$parent_class} ." | " .$members_var . " -> " . $members_list;

    ############################################################################################################################

    if ($accmod =~ s/export//sx){

        my @export_tags                 = $accmod =~ m/\:\w+/gsx;

        push @export_tags, ':import' if !$accmod;
        $accmod                         = 'public';

        foreach my $t ($name, ':all', ':var', @export_tags){ no strict 'refs';
            &var_exports->{$parent_class}{$t} .= ' '.$name;
    		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        }
    }

	# $accmod = __accessmod($self, 'var_'.$accmod, $parent_class, $name);
	#$accmod				= eval var($accmod.'_var');
    $accmod = '';

	if (&accessmod eq 'local') {
		#$accmod			= '';
		$local_var		= "local *$name; ";
        $wrap_local     = 'local';
	}


	($var_type, $var_type_args)	= $member_type =~ m/^\:\s*(\w+)(?:\((.*?)\))?$/;
	$var_type_args		= ", ".$var_type_args if $var_type_args;
	$var_type_args		||= '';
	# $var_type			= "__PACKAGE__->__RISE_CAST('$var_type', \\\$$name".$var_type_args."); " if $var_type;
	$var_type			= "__PACKAGE__->__RISE_CAST('$var_type', \\\$".&var_pkg_self."->{'$name'}".$var_type_args."); " if $var_type;
	$var_type			||= '';

    # say ">>>> " . $var_type . "\n";

	# $op_end				= " \$$name".&op_end." " if !&op_end;
	$op_end				= " $name".&op_end." " if !&op_end;

	# $res = "my \$${name}; ${var_type}no warnings; ${local_var}sub ${name} ():lvalue; *${name} = sub ():lvalue { ${accmod} \$${name} }; use warnings; ${op_end}";
	# $res = "my \$${name}; ${var_type}no warnings; ${local_var}sub ${name} ():lvalue; *${name} = sub ():lvalue { ${accmod} \$${name} }; use warnings;";

    # $res = "${var_type} ${local_var}sub ${name} ():lvalue; no warnings; *__${name}__ = sub ():lvalue { ${accmod} my \$self = shift; \$self->{'${name}'} }; *${name} = sub ():lvalue { ${accmod} \$".&var_pkg_self."->{'${name}'} }; use warnings;";
	# $res = "${var_type} ${local_var}sub ${name} ():lvalue; *__${name}__ = sub ():lvalue { ${accmod} my \$self = shift; \$self->{'${name}'} }; *${name} = sub ():lvalue { ${accmod} \$".&var_pkg_self."->{'${name}'} }; ";

    # $res = "${var_type}${local_var}sub ${name} ():lvalue; *${name} = sub ():lvalue {${accmod} \$".&var_pkg_self."->{'${name}'} };";
    $res = "${var_type}${local_var}sub ".&var_memberPref."${name} ():lvalue; *".&var_memberPref."${name} = sub ():lvalue {${accmod} \$".&var_pkg_self."->{'${name}'} };";

    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { no strict; ${accmod} my \$self = ref \$_[0] || \$_[0] || \$".&var_pkg_self.";  \$self->{'$name'} }; use warnings;";
    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { ${accmod} \$".&var_pkg_self."->{'$name'} }; use warnings;";
    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { no strict; ${accmod} my \$self = shift; if (\$self) { *$name = sub ():lvalue { ${accmod} \$self = shift || \$".&var_pkg_self."; \$self->{'$name'}; }; } \$self ||= \$".&var_pkg_self."; \$self->{'$name'} ||= \$".&var_pkg_self."->{'$name'}; \$self->{'$name'} }; use warnings;";
    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { no strict; ${accmod} my \$self = shift || \$".&var_pkg_self."; \$self->{'$name'} ||= \$".&var_pkg_self."->{'$name'}; *$name = sub ():lvalue { ${accmod} my \$self = shift || \$".&var_pkg_self."; \$self->{'$name'} }; \$self->{'$name'} }; use warnings;";
    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { no strict; ${accmod} my \$self = shift || \$".&var_pkg_self."; \$self->{'$name'} ||= \$".&var_pkg_self."->{'$name'}; \$self->{'$name'} }; use warnings;";
    # $res = "${var_type} ${local_var}sub $name ():lvalue; no warnings; *$name = sub ():lvalue { no strict; ${accmod} my \$self = shift || \$".&var_pkg_self."; \$self->{'$name'} }; use warnings;";
    # $res = "no warnings; sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} my \$self = shift; \$self->{$name}; }; use warnings;";

    $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings;" if $local_var;
    # $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings;" if &accessmod eq 'local';
    # $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings;";

    &var_wrap_variable->{$wrap_local.$parent_class.'::'.$name} = $res;
	$res = '%%%WRAP_VARIABLE_'.$wrap_local . $parent_class.'::'.$name . '%%% ' . $op_end;

    return $res;
}

sub _syntax_variable_compile_function {
	my ($self, $rule_name, $confs)			= @_;

	# my $accmod			= &accessmod || &var_accessmod;
	my $name			= &name;
	my $member_type	    = &member_type;
	my $var_type		= '';
	my $var_type_args	= '';
	my $parent_class	= $confs->{parent};
	my $boost_vars		= '';
	my $local_var		= '';
	my $op_end			= '';
    my $res;

    ############################################ add variable to function members ###############################################
    # &var_members->{$parent_class} ||= '';
	# my $members_var		= $accmod.'-var-'.$name;
	# my $members_var		= &kw_public.'-var-'.$name;
	my $members_var		= &kw_public.'-var-'.$name.$member_type;
	my $members_list	= &var_members->{$parent_class}||'';

	$members_list		=~ s/\s+/\\b\|\\b/gsx;

    # warn "ERROR VARIABLE: variable $name redefined in class $parent_class\n" if $members_var =~ m/\b$members_list\b/gsx;
    &var_members->{$parent_class} .= ' ';
	# &var_members->{$parent_class} .= ' '.$members_var if $members_var !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
	# &var_members->{$parent_class} .= ' '.$members_var if $accmod ne 'local';
	&var_members->{$parent_class} .= ' '.$members_var;
	&var_members->{$parent_class} =~ s/^\s+//;
    ###########################################################################################################################

    # if ($accmod =~ s/export//sx){
    #
    #     my @export_tags                 = $accmod =~ m/\:\w+/gsx;
    #
    #     push @export_tags, ':import' if !$accmod;
    #     $accmod                         = 'public';
    #
    #     foreach my $t ($name, ':all', ':var', @export_tags){ no strict 'refs';
    #         &var_exports->{$parent_class}{$t} .= ' '.$name;
    # 		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    # 		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
    #     }
    # }

	# $accmod = __accessmod($self, 'var_'.$accmod, $parent_class, $name);
	#$accmod				= eval var($accmod.'_var');

	# if (&accessmod eq 'local') {
	# 	#$accmod			= '';
	# 	$local_var		= "local *$name; ";
	# }

	($var_type, $var_type_args)	= $member_type =~ m/^\:\s*(\w+)(?:\((.*?)\))?$/;

	$var_type_args		= ", ".$var_type_args if $var_type_args;
	$var_type_args		||= '';

	$var_type			= "__PACKAGE__->__RISE_CAST('$var_type', \\\$$name".$var_type_args."); " if $var_type;
	$var_type			||= '';

	# $op_end				= " \$$name".&op_end." " if !&op_end;
	$op_end				= " $name".&op_end." " if !&op_end;

	# $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings; $op_end";

	# $res = "${var_type} ${local_var}sub $name ():lvalue; { no strict; no warnings; *$name = sub ():lvalue { ${accmod} my \$self = shift || \$${parent_class}::__SELF__; \$self->{$name} }; }";
    # $res = "no warnings; sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} my \$self = shift; \$self->{$name}; }; use warnings;";
    # $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings;" if &accessmod eq 'local';

    # $res = "my \$$name; ${var_type}no warnings; ${local_var}sub $name ():lvalue; *$name = sub ():lvalue { ${accmod} \$$name }; use warnings;";
    # $res = "my \$$name; ${var_type}no warnings; sub $name ():lvalue; *$name = sub ():lvalue { \$$name }; use warnings;";
    $res = "my \$$name; ${var_type}no warnings; sub $name ():lvalue; *$name = sub ():lvalue { \$$name }; use warnings;";

    &var_wrap_variable->{$parent_class.'::'.$name} = $res;
	$res = '%%%WRAP_VARIABLE_' . $parent_class.'::'.$name . '%%% ' . $op_end;

    return $res;
}

sub _syntax_variable_call {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	my $name			= &name;
	my $this			= '';
	my $tk_accmod		= &tk_accessmod;
	# my $fn_list			= &var_members->{$parent_class}||'';
	# my $method			= '__METHOD__';
	my $members_list	= &var_members->{$parent_class}||'';

	# $members_list		=~ s/$tk_accmod//gsx;
	# $members_list		=~ s/\-var\-//gsx;
	# $members_list		=~ s/^\s+(.*?)\s+$/$1/sx;
	# $members_list		=~ s/\s/\\b\|\\b/gsx;

    $members_list = join '\b|\b', $members_list =~ m/var-(\w+)/gsx;

    # print $members_list . "\n";

	# if ($members_list && $name =~ m/\b(?:$members_list)\b/sx && $name !~ m/WRAP\_VARIABLE\_/sx) {
	if ($members_list && $name =~ m/\b(?:$members_list)\b/sx && $name !~ m/WRAP\_/sx) {
		$this			= '$';
        # say ">>> CALL $parent_class::$name - $members_list";
	}


	return "...$this${name}";
}
#-------------------------------------------------------------------------------------< constant
sub _syntax_constant_compile {
	my ($self, $rule_name, $confs)			= @_;

	my $accmod			= &accessmod || &var_accessmod;
	my $name			= &name;
	my $parent_class	= $confs->{parent};
	my $local_var		= '';
    my $members_const		= $accmod.'-const-'.$name;
    my $members_list	= &var_members->{$parent_class}||'';
    my $res;

    $members_list		=~ s/\s/\\b\|\\b/gsx;

    &var_members->{$parent_class} .= ' ';
	&var_members->{$parent_class} .= ' '.$members_const if $accmod ne 'local' and $members_const !~ /$members_list/;
	&var_members->{$parent_class} =~ s/^\s+//;

    if ($accmod =~ s/export//sx){
        my @export_tags                 = $accmod =~ m/\:\w+/gsx;

        push @export_tags, ':import' if !$accmod;
        $accmod                         = 'public';

        foreach my $t ($name, ':all', ':const', @export_tags){ no strict 'refs';
            &var_exports->{$parent_class}{$t} .= ' '.$name;
    		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        }
        # print dump &var_exports->{$parent_class};
    }

	$accmod				= __accessmod($self, 'var_'.$accmod, $parent_class, $name);

	if (&accessmod eq 'local') {
		#$accmod			= '';
		$local_var		= "local *$name; ";
	}

	$res = "${local_var}sub $name () { $accmod<content> }";

    return $res;
}

#-------------------------------------------------------------------------------------< function_defs | prepare function | function

#/[<accessmod>] [<override>] <function> [<name>] [<code_args>] [<code_type>] <block_brace>/
sub _syntax_function_observe {
	my ($self, $rule_name, $confs)			= @_;
    my $header;
	my $accmod             = &accessmod || &var_accessmod . ' ';
    my $override           = &override;
	my $name               = &name;
	my $args               = &code_args || '';
	my $type               = &code_type || '';
	my $block              = &block_brace;

	my $parent_class       = $confs->{parent};
	my $parent_type        = $confs->{parent_type}||'';

	my ($s1,$s2,$s3,$s4,$s5,$s6)   = (&sps1,&sps2,&sps3,&sps4,&sps5,&sps6);

    # my $members_list_parent        = &var_members->{$parent_class} || '';
    # my $members_list_current        = &var_members->{$parent_class.'::'.$name} || '';
    my $members_func;

    my $res;

	if ($name){
        ############################################# add functions to class members ###############################################
    	$members_func		= $accmod.'-function-'.$name.$type;

        &var_members->{$parent_class} .= ' ';
    	&var_members->{$parent_class} .= ' '.$members_func; # if $members_func !~ /\b$members_list_parent\b/gsx;  # if $accmod ne 'local';
    	&var_members->{$parent_class} =~ s/^\s+//;

		&var_members->{$parent_class.'::'.$name} .= ' ';
		&var_members->{$parent_class.'::'.$name} .= ' '.$members_func; # if $members_func !~ /\b$members_list_current\b/gsx;  # if $accmod ne 'local';; # for recursion caller
        &var_members->{$parent_class.'::'.$name} =~ s/^\s+//;
        ############################################################################################################################
	}

    if ($accmod =~ s/export//sx){
        my @export_tags                 = $accmod =~ m/\:\w+/gsx;

        push @export_tags, ':import' if !$accmod;

        foreach my $t ($name, ':all', ':function', @export_tags){ no strict 'refs';
            &var_exports->{$parent_class}{$t} .= ' '.$name;
    		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        }
    }

    $block = $self->parse($block, &grammar, [@{&var_parser_member_observe}], { parent => $parent_class.'::'.$name, parent_type => 'function' });

    # &var_wrap_observe->{$name.'_BLOCK'} = $block;
    # $block = '%%%WRAP_OBSERVE_' . $name . '_BLOCK%%%';

    $res                = "${accmod}${s1}${override}${s2}".&kw_function1."${s3}${name}${s4}${args}${s5}${type}${s6}${block}";

    &var_wrap_observe->{$name} = $res;
    $res = '%%%WRAP_OBSERVE_' . $name . '%%%';

    # say "$parent_class::$name - " . &var_members->{$parent_class};

	return $res;
}

sub _syntax_function_defs {
	my ($self, $rule_name, $confs)			= @_;
	return "...sub <name><args_attr><op_end>... ... ...<nline>";
}

sub _syntax_function_call {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	my $parent_type     = $confs->{parent_type}||'';
	my $name			= &name;
	my $fncall_self		= '';
	my $tk_accmod		= &tk_accessmod;
	# my $fn_list			= &var_members->{$parent_class}||'';
	# my $method			= '__METHOD__';
	my $members_list	= &var_members->{$parent_class}||'';

	# say 'funcall parent --> ' . $parent_type;

	# $members_list		=~ s/$tk_accmod//gsx;
	# $members_list		=~ s/\-function\-//gsx;
	# $members_list		=~ s/^\s+(.*?)\s+$/$1/sx;
    # $members_list		=~ s/\s+/\|/gsx;

    $members_list = join '\b|\b', $members_list =~ m/function-(\w+)/gsx;

	if ($members_list && $name =~ m/^\b(?:$members_list)\b/sx) {
		$fncall_self			= '$'.&var_pkg_self.',';
		$fncall_self			= '__PACKAGE__,' if $parent_type eq 'function';
		# print ">>> $parent_class->$name | fnlist - *$members_list* \n";
	}

	return "${name}...(${fncall_self}";
}

sub  _syntax_function_call_post1 {''}
sub  _syntax_function_call_post2 {&self_con.')'}

sub _syntax_function_compile {
	my ($self, $rule_name, $confs)			= @_;
    my $header;
    my $override           = &override ? ' no warnings qw/redefine prototype/;' : '';
	my $accmod             = &accessmod || &var_accessmod;
	my $name               = &name;
	my $args               = &code_args || '';
	my $type               = &code_type || '';
	# my $attr               = &code_attr || '';
	my $block              = &block_brace;
	my $parent_class       = $confs->{parent};
	my $parent_type        = $confs->{parent_type}||'';
	my $fn_name            = &var_memberPref.&name;
	my ($s1,$s2,$s3,$s4)   = (&sps1,&sps2,&sps3,&sps4);
	my $anon_code          = '';
	my $anon_code_open     = '';
	my $anon_code_close    = '';
	my $arguments          = '';
	# my $self_args          = &kw_self;
	my $self_args          = '';
	my $fn_list;
	my $res                = '';
    my $isExport           = 0;
	my $retval			   = '';
    my $members_func;
    # my $members_list;

    # if (&override){
    #     $override = " no warnings qw/redefine prototype/;";
    #     # $accmod                         = keyword 'private' if !$accmod;
    # }

	if (!$name){
		&var_anon_fn_count++;
		$name			  = &var_anon_code_pref.sprintf("%05d", &var_anon_fn_count);
        $name             =~ s/\s//gsx;
		$fn_name		  = &var_memberPref.$name;
		# $anon_code		  = 'return &'.$name.'; ' ;
        $anon_code		  = 'return '.&var_memberPref.$name.'($'.&var_pkg_self.',@_); ';
        # $anon_code		  = 'return '.$name.'(__PACKAGE__, @_); ' if $parent_type eq 'function';
        $anon_code		  = 'return '.&var_memberPref.$name.'($self, @_); ' if $parent_type eq 'function';
		$anon_code_open   = 'sub { ';
		$anon_code_close  = '}';
		# $self_args		  = '';
	}

	# if ($name){
    #     ############################################# add functions to class members ###############################################
    #     # &var_members->{$parent_class} ||= '';
    #     # say "PARENT FOR FN >>> " . $parent_class . ": " . $name;
    #
    # 	$members_func		= $accmod.'-function-'.$name;
    #     # print ">>> $members_func \n";
    # 	# $members_list	    = &var_members->{$parent_class}||'';
    # 	# $members_list		=~ s/\s+/\\b\|\\b/gsx;
    #
    #     # warn "ERROR FUNCTION: function $name redefined in class $parent_class\n" if $members_func =~ m/\b$members_list\b/gsx;
    #     &var_members->{$parent_class} .= ' ';
    # 	&var_members->{$parent_class} .= ' '.$members_func; # if $members_func !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
    # 	&var_members->{$parent_class} =~ s/^\s+//;
    #
	# 	# &var_members->{$parent_class.'::'.$name} .= &var_members->{$parent_class}; # for recursion caller
	# 	&var_members->{$parent_class.'::'.$name} .= ' ';
	# 	&var_members->{$parent_class.'::'.$name} .= ' '.$members_func; # for recursion caller
    #     &var_members->{$parent_class.'::'.$name} =~ s/^\s+//;
    #     ############################################################################################################################
	# }

    # if ($accmod =~ s/export//sx){
    #     $isExport                       = 1;
    #
    #     my @export_tags                 = $accmod =~ m/\:\w+/gsx;
    #
    #     push @export_tags, ':import' if !$accmod;
    #     $accmod                         = keyword 'public';
    #
    #     foreach my $t ($name, ':all', ':function', @export_tags){ no strict 'refs';
    #         &var_exports->{$parent_class}{$t} .= ' '.$name;
    # 		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    # 		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
    #     }
    # }

	# $accmod                = __accessmod($self, 'code_'.$accmod, $parent_class, $name);
    $accmod                 = '';

	# $name                  = $parent_class . '::' . $name;
	$name                  = $parent_class . '::' . &var_memberPref . $name;

	$args				=~ s/^\((.*?)\)$/$1/;
	$self_args			.= ',' . $args if $args;

	my @args = split /\,/,$self_args;
	my $args_list			= '';
	my $args_def			= '';
	my $proto			= '';
	# my $i = 0;
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

	$self_args	= $args_list;
	$self_args =~ s/^\,//;

	# $arguments			= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;

    # $arguments			= &kw_local." ".&kw_variable." ".&kw_self." = \$_[0]; ";
	# $arguments			.= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;
	# $arguments			= $self->parse($arguments, &grammar, [@{&var_parser_variable_function}], { parent => $name });

	$arguments			= &kw_local." ".&kw_variable." ".&kw_self." = shift; ".&kw_local." ".&kw_variable." ".&kw_fnargs." = \\\@_; ";
	$arguments			.= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;

	# $arguments			= $self->parse($arguments, &grammar, [@{&var_parser_variable_function}], { parent => $name });
	$arguments			= $self->parse($arguments, &grammar, ['_variable_list', '_variable_observe', @{&var_parser_variable}, '_variable_call' ], { parent => $name, parent_type => 'function' });
	&var_wrap_code_header->{'FNARGS_'.$name} = $arguments;
	$arguments = '%%%WRAP_CODEHEADER_FNARGS_' . $name . '%%%';

	# say 'fn args ->' . $arguments;
	# $arguments			=~ s/\_\_RISE\_SHIFT/shift/sx;


	if ($type) {
        my ($fn_type, $fn_type_args)	= $type =~ m/\:\s*(\w+)(?:\((.*?)\))?/;

        $fn_type_args ||= '';

		$retval				= "my \$_RETVAL_; __PACKAGE__->__RISE_CAST('$fn_type', \\\$_RETVAL_, $fn_type_args); ";
		$block 				=~ s/return(.*?)(\s*(?:\;|\}|\)|if))/\$_RETVAL_ = $1; return \$_RETVAL_$2/sx;
	}

    $block 				=~ s/\{(.*)\}/$1/gsx;
    $header             = "use rise::core::object::function2;$override sub __function__ { __PACKAGE__ } ";
    &var_wrap_code_header->{$name} = $header;
    $header = '%%%WRAP_CODEHEADER_' . $name . '%%%';

    # my $block_parent    = $name;
    # $block_parent       = $parent_class if $anon_code;
    # $block 				= $self->parse($block, &grammar, [@{&var_parser_code_function}], { parent => $block_parent });

    $block 				= $self->parse($block, &grammar, [@{&var_parser_code_function}], { parent => $name, parent_type => 'function' });
    # $block 				= $self->parse($block, &grammar, ['_member_name_function'], { parent => $name, parent_type => 'function' });
    # &var_wrap_code->{$name} = $block;
	# $block = '%%%WRAP_CODE_' . $name . '%%%';


	$res				= "${anon_code_open}${anon_code}{ package ${name}; ${header}${s1}$retval sub ${fn_name}${s2}${s3}{ ${accmod} ${arguments}${s4}${block}}}${anon_code_close}";
    # $res 				= $self->parse($res, &grammar, ['_member_name_function'], { parent => $name, parent_type => 'function' });

    &var_wrap_code->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';

	return $res;
}

#-------------------------------------------------------------------------------------< thread_defs | prepare thread | thread

sub _syntax_thread_call {
	my ($self, $rule_name, $confs)			= @_;
	my $parent_class	= $confs->{parent};
	my $parent_type     = $confs->{parent_type}||'';
	my $name			= &name;
	my $fncall_self		= '';
	my $tk_accmod		= &tk_accessmod;
	# my $fn_list			= &var_members->{$parent_class}||'';
	# my $method			= '__METHOD__';
	my $members_list	= &var_members->{$parent_class}||'';

	$members_list		=~ s/$tk_accmod//gsx;
	$members_list		=~ s/\-thread\-//gsx;
    $members_list		=~ s/^\s+(.*?)\s+$/$1/sx;
	$members_list		=~ s/\s+/\|/gsx;

    if ($members_list && $name =~ m/\b(?:$members_list)\b/sx) {
		$fncall_self			= '$'.&var_pkg_self.',';
		$fncall_self	= '__PACKAGE__,' if $parent_type eq 'function';
	}

	return "${name}...(${fncall_self}";
}

sub _syntax_thread_call_post1 {''}
sub _syntax_thread_call_post2 {&self_con.')'}

sub _syntax_thread_compile {
	my ($self, $rule_name, $confs)			= @_;
    my $header;
    my $override           = '';
	my $accmod             = &accessmod || &var_accessmod;
	my $name               = &name;
	my $args               = &code_args || '';
    my $type               = &code_type || '';
	# my $attr               = &code_attr || '';
	my $block              = &block_brace;
	my $parent_class       = $confs->{parent};
    my $parent_type        = $confs->{parent_type}||'';
	my $trd_name           = &name;
	my ($s1,$s2,$s3,$s4)   = (&sps1,&sps2,&sps3,&sps4);
	my $anon_code          = '';
	my $anon_code_open     = '';
	my $anon_code_close    = '';
	my $arguments          = '';
	# my $self_args          = &kw_self;
	my $self_args          = '';
	my $trd_list;
	my $res                = '';
    my $isExport           = 0;
    my $retval			   = '';
    my $members_thrd;
    # my $members_list;

	if (!$name){
		&var_anon_fn_count++;
		$name			  = &var_anon_code_pref.sprintf("%05d", &var_anon_fn_count);
        $name             =~ s/\s//gsx;
		$trd_name		  = &var_memberPref.$name;
        # $anon_code		  = 'return &'.$name.'; ' ;
        $anon_code		  = 'return '.$name.'($'.&var_pkg_self.',@_); ';
        $anon_code		  = 'return '.$name.'(__PACKAGE__, @_); ' if $parent_type eq 'function';
		$anon_code_open   = 'sub { ';
		$anon_code_close  = '}';
		# $self_args		  = '';
	}

    if ($name){
        ############################################# add threads to class members ###############################################
    	$members_thrd		= $accmod.'-thread-'.$name;
    	# $members_list	    = &var_members->{$parent_class}||'';
    	# $members_list		=~ s/\s+/\\b\|\\b/gsx;

        # warn "ERROR FUNCTION: function $name redefined in class $parent_class\n" if $members_thrd =~ m/\b$members_list\b/gsx;
        &var_members->{$parent_class} .= ' ';
    	&var_members->{$parent_class} .= ' '.$members_thrd; # if $members_thrd !~ /\b$members_list\b/gsx;  # if $accmod ne 'local';
    	&var_members->{$parent_class} =~ s/^\s+//;

		# &var_members->{$parent_class.'::'.$name} .= &var_members->{$parent_class}; # for recursion caller
		&var_members->{$parent_class.'::'.$name} .= ' ';
		&var_members->{$parent_class.'::'.$name} .= ' '.$members_thrd; # for recursion caller
        &var_members->{$parent_class.'::'.$name} =~ s/^\s+//;
        ############################################################################################################################
	}

    if (&override){
        $override = " no warnings qw/redefine prototype/;";
        # $accmod                         = keyword 'private' if !$accmod;
    }

    if ($accmod =~ s/export//sx){
        $isExport                       = 1;

        my @export_tags                 = $accmod =~ m/\:\w+/gsx;

        push @export_tags, ':import' if !$accmod;
        $accmod                         = keyword 'public';

        foreach my $t ($name, ':all', ':thread', @export_tags){ no strict 'refs';
            &var_exports->{$parent_class}{$t} .= ' '.$name;
    		&var_exports->{$parent_class}{$t} =~ s/^\s+//;
    		&var_exports->{$parent_class.'::'.$name}{$t} .= &var_exports->{$parent_class}{$t}; # for recursion caller
        }
    }

	$accmod                = __accessmod($self, 'code_'.$accmod, $parent_class, $name);

	$name                  = $parent_class . '::' . &var_memberPref . $name;

	$args				=~ s/^\((.*?)\)$/$1/;
	$self_args			.= ',' . $args if $args;

	my @args = split /\,/,$self_args;
	my $args_list			= '';
	my $args_def			= '';
	my $proto			= '';
	# my $i = 0;
	my $i = 1;

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

	$self_args	= $args_list;

	$self_args =~ s/^\,//;

	# $arguments			= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;
    $arguments			= &kw_local." ".&kw_variable." ".&kw_self." = \$_[0]; ";
    $arguments			.= &kw_local." ".&kw_variable." ($self_args) = ($args_def);" if $self_args;
	$arguments			= $self->parse($arguments, &grammar, [@{&var_parser_variable_function}], { parent => $name });

    if ($type) {
        my ($thr_type, $thr_type_args)	= $type =~ m/\:\s*(\w+)(?:\((.*?)\))?/;

        $thr_type_args ||= '';

		$retval				= "my \$_RETVAL_; __PACKAGE__->__RISE_CAST('$thr_type', \\\$_RETVAL_, $thr_type_args); ";
		$block 				=~ s/return(.*?)(\s*(?:\;|\}|\)|if))/\$_RETVAL_ = $1; return \$_RETVAL_$2/sx;
	}

    $block 				=~ s/\{(.*)\}/$1/gsx;
    $header             = "use rise::core::object::thread2;$override";
    &var_wrap_code_header->{$name} = $header;
    $header = '%%%WRAP_CODEHEADER_' . $name . '%%%';

    $block 				= $self->parse($block, &grammar, [@{&var_parser_code_function}], { parent => $name, parent_type => 'function' });

    $res				= "${anon_code_open}${anon_code}{ package ${name}; ${header}${s1}$retval sub ${trd_name}${s2}${s3}{ ${accmod} my \$thr; \$thr = threads->create(sub{${arguments}${s4}${block}}, \@_); { no strict; no warnings; \@{${parent_class}::THREAD::${trd_name}}[\$thr->tid] = \$thr; } return \$thr; }}${anon_code_close}";
	&var_wrap_code->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';

	return $res;
}

#-------------------------------------------------------------------------------------< namespace
sub _syntax_auth {
    my ($self, $rule_name, $confs)			= @_;
    my $auth                                = &name;
    my $fname                               = $self->{FNAME};
    my $res;

    # $fname                                  =~ s/\.puma$//sx;
    &var_auth->{$fname}                   	= $auth;


    # &var_auth->{$class}                   = 'our $'.$class.'::AUTHORITY = "' . $auth . '";';

    # $res                                    = '$main::'.$class.'::AUTHORITY = "' . $auth . '";';
    $res                                    = '# AUTHORITY ' . $auth;
    push @{&var_excluding}, $res;
    return '%%%TEXT_' . sprintf("%03d", $#{&var_excluding}) . '%%%';
}

sub _syntax_vers {
    my ($self, $rule_name, $confs)			= @_;
    my $ver                                 = &number;
    my $fname                               = $self->{FNAME};
    my $res;

    # $fname                                  =~ s/\.puma$//sx;
    &var_ver->{$fname}                    	= $ver;

    # $res                                    = '$main::'.$class.'::VERSION = "' . $ver .'";';
    $res                                    = '# VERSION ' . $ver;
    push @{&var_excluding}, $res;
    return '%%%TEXT_' . sprintf("%03d", $#{&var_excluding}) . '%%%';
}

# sub _syntax_namespace {
# 	my ($self, $rule_name, $confs)			= @_;
# 	my $name			= &name;
# 	# my $parent_name		= $confs->{parent} || 'main';
# 	my $parent_name		= $confs->{parent};
# 	my $block 			= &block_brace;
# 	my ($s1,$s2,$s3,$s4) = (&sps1,&sps2,&sps3,&sps4);
#
# 	return '' if !$name;
#
# 	$name				= $parent_name . '::' . $name if $parent_name;
#
# 	$block 				=~ s/\{(.*)\}/$1/gsx;
# 	$block 				= $self->parse($block, grammar, [@{&var_parser_namespace}], { parent => $name });
#
# 	#print ">>>>>> parent_class - ". &name ." | name - ".&name."\n";
#
# 	return "{ package ${name};${s1}use rise::core::object::namespace;${s2} ${s3} ${s4}${block}}"
# }

sub _syntax_namespace {
    return '' if !&name;
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						||= &var_accessmod_namespace;
    # &var_className = &name;
	return __object($self, 'namespace', $rule_name, $confs);
}

#-------------------------------------------------------------------------------------< class

sub _syntax_class {
	return '' if !&name;
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod_class || &var_accessmod;
    &var_className = &name;
	return __object($self, 'class', $rule_name, $confs);
}

sub _syntax_class_ops {
	return '' if !&name;
	my ($self, $rule_name, $confs)			= @_;

	return '<new> <name>::';
}

#-------------------------------------------------------------------------------------< interface

sub _syntax_interface {
	my ($self, $rule_name, $confs)			= @_;
	$confs->{accessmod}						= &accessmod_class || 'protected';
	return __object($self, 'interface', $rule_name, $confs);
}

sub _syntax_interface_set {
	my ($self, $rule_name, $confs)			= @_;
	my $accmod			= &accessmod_class || &var_accessmod;
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

	my ($self, $object, $rule_name, $confs)			= @_;
	my $accmod			= $confs->{accessmod};
	my $name			= &name;
	# my $class_args		= &code_args;
	my $args_attr		= &content;
    my $class_args      = '';
	my $block 			= &block_brace;

	my ($sps1,$sps2,$sps3,$sps4) = (&sps1,&sps2,&sps3,&sps4);

	my $base_class		= "'rise::core::object::$object'";
	# my $parent_class	= $confs->{parent} || 'main';
	my $parent_class	= $confs->{parent};

	my $list_extends	= '';
	my $list_implements	= '';
    my $list_exports    = '';
	my $extends			= '';
	my $implements		= '';
	my $res				= '';

    # print $class_args;
    ($class_args, $args_attr) = $args_attr =~ m/^(\(.*?\))?\s*(.*?)$/sx;

	if ($parent_class) {
        &var_members->{$parent_class} .= ' ';
		&var_members->{$parent_class} .= ' '.$accmod.'-'.$object.'-'.$name;
		&var_members->{$parent_class} =~ s/^\s+//;
		$name				= $parent_class . '::' . $name;
		# $list_extends		= ",'$parent_class'";
	}

	$list_extends		.= __list_extends($self, $args_attr) if $args_attr;
	if ($list_extends) {
        $extends			= "use rise::core::ops::extends2 ${list_extends};";
        $self->{$name}{extends} = 1;
    }
	# $extends			= "use rise::core::ops::extends ${base_class}${list_extends}; ";

	$accmod				= var($accmod.'_'.$object);
	$accmod				= eval $accmod if $accmod;
    $accmod             ||= '';
    # $accmod				= __accessmod($self, $object.'_'.$accmod, $parent_class, $name);

	$block 				=~ s/\{(.*)\}/$1/gsx;

	#$block 				= $self->parse($block, &grammar, ['_variable_boost', '_variable_optimize'], { parent => $parent_class });
	$block 				= $self->parse($block, &grammar, [@{var 'parser_'.$object}], { parent => $name, parent_type => $object });
	# $block 				= $self->parse($block, &grammar, [@{&var_parser_code}], { parent => $name });

    # &var_wrap_code_header->{$name.'_CLASS_SELF_H'} = '__PACKAGE__->{\'SELF\'} = shift;';
    # &var_wrap_code_footer->{$name.'_CLASS_SELF_F'} = 'return __PACKAGE__->{\'SELF\'};';
    # $block 				= '( bless {} )->__CLASS_CODE__; sub __CLASS_CODE__ { %%%WRAP_CODEHEADER_' . $name.'_CLASS_SELF_H%%% '.$block.'%%%WRAP_CODEFOOTER_' . $name.'_CLASS_SELF_F%%% }';

	$res				= "{ package ${name};".$sps1."use rise::core::object::${object}2;". $sps2 . $extends . $sps3 . $accmod . __object_header($self, $object, $name || '', $class_args, $confs) . $sps4.$block."}";
	# $res				= "{ package ${name};".$sps1."use strict; use warnings; use rise::core::object::class;". $sps2 . $extends . $sps3 . $accmod . __object_header($self, $object, $name || '', $confs) . $sps4.$block."}";

    # &var_members->{$name} = '';
    # &var_exports->{$name} = '';

	&var_members = {};
	&var_exports = {};

    &var_wrap_code->{$name} = $res;
	$res = '%%%WRAP_CODE_' . $name . '%%%';

	return $res;
}

sub __object_header {
	my $self			= shift;
	my $obj_type		= shift;
	my $name			= shift;
    my $class_args      = shift;
    my $confs           = shift;
    # my $parent_class	= $confs->{parent} || 'main';
    my $res;
    my $fname           = $self->{FNAME};

    # $fname                                  =~ s/\.puma$//sx;



    my $auth            = exists &var_auth->{$fname}	? &var_auth->{$fname}	: $self->{AUTHORITY};
    my $ver             = exists &var_ver->{$fname}		? &var_ver->{$fname}	: $self->{VERSION};

    # my $auth            = &var_auth->{$fname} if exists &var_auth->{$fname};
    # my $ver             = &var_ver->{$fname} if exists &var_ver->{$fname};
	#
    # my $auth            ||= $self->{AUTHORITY};
    # my $ver             ||= $self->{VERSION};

    my $header          = {};

	# say '------------ syntax -------------';
	# say $self->{FNAME};
	# say $auth;
	# say $ver;
	# say '---------------------------------';

	$header			= {
        # namespace   => "use rise::core::object::namespace;",
        namespace   => '',
		class		=> 'our $AUTHORITY = "'.$auth.'"; sub AUTHORITY {"'.$auth.'"}; our $VERSION = "'.$ver.'"; sub VERSION {"'.$ver.'"}; my $'.&var_pkg_self.' = bless {}; sub '.&var_pkg_self.' ():lvalue { $'.&var_pkg_self.' } sub __class__ { __PACKAGE__ } ',
		# class		=> " sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }; ",
		# class		=> " sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }; BEGIN { __PACKAGE__->__RISE_COMMANDS }",
		# class		=> " BEGIN { no strict 'refs'; *{'".$name."::'.\$_} = \\&{'".$parent_class."::IMPORT::'.\$_} for keys \%".$parent_class."::IMPORT::; }; sub super { \$${name}::ISA[1] } my \$<kw_self> = '${name}'; sub <kw_self> { \$<kw_self> }; BEGIN { __PACKAGE__->__RISE_COMMANDS }",
		abstract	=> '',
		interface	=> ' __PACKAGE__->interface_join;'
	};

    # print ">>> " . &var_members->{$name} . "\n";

    if ($class_args) {

        $class_args				=~ s/^\((.*?)\)$/$1/;
        my $self_args			= ',' . $class_args if $class_args;

        my @args = split /\,/,$self_args;
    	my $args_list			= '';
    	my $args_def			= '';
    	# my $proto			= '';
    	# my $i = 0;
    	my $i = 1;

    	s{
    		(?<name>\b\w+(?:\s*\:\s*\w+)?\b)
    		(\s*\=\s*(?<def>.*))?
    	  }{
    		$args_list	.= $+{name} . ',';
    		$args_def 	.= '$_['.$i.']';
    		$args_def	.=('||'.$+{def}) if $+{def};
    		$args_def	.=',';
    		# $proto		.= '$';
    		$i++;
    	}sxe for @args;

        $self_args      = $args_list;
    	$self_args      =~ s/\,$//;
    	$args_def       =~ s/\,$//;

        # my $args            = &kw_public.' var ' . $class_args . '; sub __CLASS_ARGS__ { my $self = shift; '.$class_args.' = @_; };';
        # $args 				= $self->parse($args, &grammar, [@{&var_parser_variable_class}], { parent => $name });

        my $args            = &kw_public.' var (' . $self_args . '); sub __CLASS_ARGS__ { ('.$self_args.') = ('.$args_def.'); };';
        $args 				= $self->parse($args, &grammar, [@{&var_parser_variable_class}], { parent => $name });

        $header->{class}	.= $args;
    }

    $header->{class}	.= "sub __CLASS_MEMBERS__ {q{".(&var_members->{$name}||'')."}}...";
    # $class_args            = ' var ' . $class_args . '; sub __CLASS_ARGS__ { my $self = shift; '.$class_args.' = @_; };' if $class_args;

    if (exists &var_exports->{$name}) {
        my $exports         = dump(&var_exports->{$name});

        $exports            =~ s/\s*\"\s*/\"/gsx;
        $exports            =~ s/[\r\n]+//gsx;
        $exports            =~ s/\=\>\"(.*?)\"/=>[qw\/$1\/]/gsx;

        $header->{class}	.= ' sub __EXPORT__ { '.$exports.' }';
        # print dump &var_exports->{$name};
    }

	if ($self->{debug} && $self->{$name}{extends}) {
        # $header->{class}	.= "sub __CLASS_MEMBERS__ {'".(&var_members->{$name}||'')."'}...";
		# $header->{class}	.= " BEGIN { sub __CLASS_MEMBERS__ {'".(&var_members->{$name}||'')."'}... };";
		# $header->{class}	.= " __PACKAGE__->interface_confirm; sub __CLASS_MEMBERS__ {'".(&var_members->{$name}||'')."'}...";
		$header->{abstract} .= " __PACKAGE__->interface_join;";
	}

    &var_wrap_code_header->{$name} = $header->{$obj_type};
    $res = '%%%WRAP_CODEHEADER_' . $name . '%%% ';

	return $res;
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

sub __list_extends {
	my $self					= shift;
	my $args_attr				= shift;
	my $tk_name_list			= &tk_name_list;
	my $list_extends			= '';
	my $list_implements			= '';
	my $comma					= '';
	my $tk_extends				= &tk_inherits;
	my $tk_implements			= &tk_implements;
	my $sps						= '';
    my $npsmbl                  = '';

	$args_attr					=~ s/$tk_extends\s+(?<ext>$tk_name_list)//sx;		$list_extends		= $+{ext} || '';
	$args_attr					=~ s/$tk_implements\s+(?<imp>$tk_name_list)//sx;	$list_implements	= $+{imp} || '';
	$args_attr					=~ s/(?<sps>\s*)//; $sps = $+{sps};

    print "ERROR EXTENDS -> $args_attr\n" if $args_attr;
    print "NONPRINT SMBL -> $args_attr\n" if $args_attr =~ m/\W/gsx;
    # print "EXTENDS -> $list_extends\n" if $list_extends;
    # print "IMPLEMENTS -> $list_implements\n" if $list_implements;

    $npsmbl = "NONPRINT SMBL" if $args_attr =~ m/\W/gsx;
	return ";${sps}__PACKAGE__->extends_error; $npsmbl" if $args_attr;

	$comma						= ',' if $list_extends;

	$list_extends				.= $comma . $sps . $list_implements if $list_implements && $self->{debug};
	if ($list_extends) {
		$list_extends				=~ s/(?<scomma>\s*\,\s*)/'$+{scomma}'/gsx;
		$list_extends				=~ s/\s?\,\s?/,/gsx;
		$list_extends				= "'$list_extends'";
		# $list_extends				= ",'$list_extends'";
	}
	$list_extends				||= '';

	return $list_extends;
}

#-------------------------------------------------------------------------------------

sub _syntax_op_regex {
    # my $specv = &spec_name;
    # print "############ $specv ##############\n";
    # return "__RISE_A2R <sigils><self_name>...<op_regex>";
    return "__RISE_MATCH <spec_name>...<op_regex>...";
    # return "<symbol><regex_m_want>...__RISE_A2R <spec_name>...<op_regex>";
}

sub _syntax_op_scalar { '__RISE_' . uc &op_scalar }
# sub _syntax_op_scalar { '__RISE_' . uc &op_scalar . '...<string>,' }

# sub _syntax_op_array {
# 	my $op_array			= '__RISE_' . uc &op_array;
# 	return $op_array;
# }

sub _syntax_op_sort_blockless { "sort {}" }

sub _syntax_op_array_block {
	my $op_array			= '__RISE_' . uc &op_array_block . '_BLOCK';
    return $op_array.' {';
    # return '<op_array_block>b {';
}

sub _syntax_op_array_hash { return '__RISE_' . uc &op_array_hash }
sub _syntax_op_for_each {
    my $op_for_each = &op_for_each;
    my $tk_for      = &tk_for;
    my $tk_foreach  = &tk_foreach;

    $op_for_each = 'for' if &op_for_each eq '__FOR__' || &op_for_each_cond eq '__FOR_COND__';
    $op_for_each = 'foreach' if &op_for_each eq '__FOREACH__' || &op_for_each_cond eq '__FOREACH_COND__';

    # $op_for_each =~ s/_//gsx;
    return $op_for_each;
}

# sub _syntax_op_ahref_expr {
#     return "__RISE_A2R <op_hash>...<paren_L>...__RISE_R2H ";
# }

# sub _syntax_op_array1 {
# 	my $sigils			= &sigils || '&';
# 	return "<op_array1>...<paren_L>...\@{${sigils}<self_name>}";
# }

# sub _syntax_op_array2  { "__RISE_A2R <op_array2>...<block_brace> __RISE_R2A" }
# sub _syntax_op_array21 { "__RISE_A2R <op_array2>...<string>, __RISE_R2A" }
# sub _syntax_op_array3  { "<op_array3>...<string>, __RISE_R2A" }

# sub _syntax_op_hash {
# 	# my $sigils			= &sigils || '&';
# 	# my $selfname		= &self_name;
# 	# $selfname 			= "\%{${sigils}<self_name>}" if &self_name !~ /__RISE/; # if $sigils eq '$';
#
# 	return "__RISE_A2R <op_hash>...<paren_L>...__RISE_R2H ";
# }

# sub _syntax_op_hash {
#     my $op_hash			= '__RISE_' . uc &op_hash;
# 	return $op_hash;
# }

# sub _syntax_op_reverse { '__RISE_2R <op_reverse>...<paren_L>...__RISE_R2 ' }

# sub _syntax_context {"\$_"}

sub _syntax_comma_quarter {
		my $name_ops		= &name_ops;
		my $name			= &name_dot_list;
		$name				= __name2name($name);
		return $name_ops . ' ' . $name;
}

sub  __name2name {
	my $name = shift;
	$name =~ s/\./\:\:/gsx;
	return $name;
}

# sub _syntax_op_dot {'->'}
# sub _syntax_op_dot {'->...<word>'}
# sub _syntax_op_dot {'->...'}
sub _syntax_op_dot {'...->...'}
# sub _syntax_op_dot {'->'}
sub _syntax_concat {'<sps1>.<sps2>'}

sub _syntax_optimize4 { ';' }
sub _syntax_optimize5 { ' ' }
sub _syntax_optimize6 { '' }
sub _syntax_optimize7 { '<sps1>' }
sub _syntax_optimize71 { '__RISE_R2A ' }
sub _syntax_optimize8 { '' }
sub _syntax_optimize9 {
	my $res;
	$res = '{' if $+{REG_PATTERN_LEFT};
	$res = '}' if $+{REG_PATTERN_RIGHT};
	return $res;
}

1;
