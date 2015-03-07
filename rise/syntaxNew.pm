package rise::syntaxNew;

use strict;
use warnings;
use utf8;

use rise::grammar qw/:simple/;

our $VERSION = '0.000';

my $cenv					= {};

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

#my $codevars = grammar->{PARSER}{CODE_VARS} || '';

keyword private				=> 'private';
keyword protected			=> 'protected';
keyword public				=> 'public';
keyword namespace			=> 'namespace';
keyword class				=> 'class';
keyword abstract			=> 'abstract';
keyword interface			=> 'interface';
keyword import				=> 'using';
keyword inherits			=> 'extends';
keyword implements			=> 'implements';
keyword inject				=> 'inject';
keyword function			=> 'function';
keyword method				=> 'method';
keyword fmethod				=> 'fmethod';
keyword variable			=> 'var';
keyword constant			=> 'const';

token 	namespace			=> keyword 'namespace';
token 	class				=> keyword 'class';
token 	abstract			=> keyword 'abstract';
token 	interface			=> keyword 'interface';
token 	import				=> keyword 'import';
token 	inherits			=> keyword 'inherits';
token 	implements			=> keyword 'implements';
token 	inject				=> keyword 'inject';
token 	function			=> keyword 'function';
token 	method				=> keyword 'method';
token 	fmethod				=> keyword 'fmethod';
token 	variable			=> keyword 'variable';
token 	constant			=> keyword 'constant';
token 	private				=> keyword 'private';
token 	protected			=> keyword 'protected';
token 	public				=> keyword 'public';

token 	comment				=> q/(?<![\$\@\%])\#content\n/;
token 	content				=> q/string?/;
token 	before				=> q/^string/;
token 	after				=> q/string$/;
token 	word				=> q/letter+/;
token 	number				=> q/digit+/;
token	letter				=> q/\w/;
token	digit				=> q/\d/;
token 	string				=> q/.*/;
token	endop				=> q/\;/;

token 	name				=> q/word(?:\:\:word)*/; #qr/\w+(?:\:\:\w+)*/; #
token 	name_list			=> q/name(?:\s*,\s*name)*/;
token 	name_list_br		=> q/\(\s*name_list\s*\)/;
token 	namestrong			=> q/[^ digit \W ][ letter : ]+[^ \W]/;
token 	code_name			=> q/name/;

token 	type_class			=> q/namespace|class|abstract|interface/;
token 	type_code			=> q/function|method|fmethod/;
token 	type_all			=> q/type_class|type_code/;
	
token 	class_attr			=> q/content/;
token 	namespace_attr		=> q/class_attr/;
token 	code_attr			=> q/\:\s*content/;
token 	code_args			=> q/\(content\)/;
	
token 	list				=> q/word(?:\s*,\s*word)*/;
token 	list_name			=> q/name\s*[,()\[\]{}]/;
token 	inherit_list		=> q/inherits/;
token 	implement_list		=> q/implements/;

token 	accmod				=> q/private|protected|public/;	
token 	name_ops			=> q/type_class|type_code|variable|import|inherits|implements|new/;

token	CONDITION			=> q/content/;
token	THEN				=> q/content/;
token	ELSE				=> q/content/;

token excl_content				=> q/POD_or_DATA|comment|\'content?\'|\"content?[^\\"]?\"/;
token EOP 						=> q/\n\n|\Z/;
token CUT 						=> q/\n=cut.*EOP/;
token POD_or_DATA 				=> qr/
	^=(?:head[1-4]|item) .*? CUT
  | ^=pod .*? CUT
  | ^=for .*? CUT
  | ^=begin .*? CUT
  | ^__(DATA|END)__\r?\n.*
/smx;

#rule	rule_function_t			=> q/(not:<accmod>) (pre_not:<type_code>) [<code_name>] [<code_args>] [<code_attr>] \{[<content>]\} [<endop>]/;
rule	exl_content			=> q/<excl_content>/;
rule	function			=> q/[<accmod>] <type_code> [<code_name>] [<code_args>] [<code_attr>] \{[<content>]\} [<endop>]/;
rule	variable_list		=> q/[<accmod>] <variable> \( <name_list> \) [<endop>]/;
rule	variable			=> q/[<accmod>] <variable> <name> [<endop>]/;
rule	constant			=> q/[<accmod>] <constant> <name> = <content> <endop>/;
##########################################################################
rule	parser_list_iter	=> q/LI: \( <name_list> \) \{ <content> \}/;
rule	parser_if			=> q/IF: \( [<CONDITION>] \) \{ <THEN> \}[ ELSE: \{ <ELSE> \} ]/;
rule	parser_variable		=> q/_var_/;
rule	parser_var_boost	=> q/<string>/;
##########################################################################

action exl_content			=> \&parse_exl_content;
action function				=> \&parse_function;
action variable_list		=> \&parse_variable_list;
action variable				=> \&parse_variable;
action constant				=> \&parse_constant;

action parser_variable		=> \&parse_parser_variable;
action parser_list_iter		=> \&parse_parser_list_iter;
action parser_if			=> \&parse_parser_if;

action parser_var_boost		=> \&parse_parser_var_boost;

sub syntax { &grammar };

sub parse_exl_content {
	'EXLUDING'
}

sub parse_function {
	

	my $code_def;
	
	my $non_anon_codename		= &code_name;
	
	$code_def = 'BEGIN { *<code_name> = \&main::<code_name>::code }';
	$code_def = '\&main::<code_name>::code' if !&code_name;
	
	rule_last_var('code_name')	= '__anon__' if !&code_name;
	
	if (&code_args !~ m/\((\w+.*?)\)/sx) {
		rule_last_var('code_attr') = &code_args . &code_attr;
		rule_last_var('code_args') = '';
	}

	return "$code_def<endop>{ package main::<code_name>; sub this {'main'} sub code <code_attr> { IF: ( '<code_args>' ) { <tk_private> <tk_variable> <code_args> = \@_; }<content>}}";
}

sub parse_variable_list {
	return q/LI: ( <name_list> ) { <accmod> _var_ _LI_; } IF: ( !'<endop>' ) {(<name_list>)<endop>}/;
}

sub parse_variable {
	
	my $code_vars	= '';
	my $or			= '';
	
	$code_vars		= grammar->{PARSER}{CODE_VARS} || '';
	
	$or				= '|' if $code_vars;
	grammar->{PARSER}{CODE_VARS} .= $or . &name if &name !~ /$code_vars/;

	return q/my $<name>; { no warnings; sub <name> ():lvalue { $<name> } } IF: ( !'<endop>' ) {<name><endop>}/;
}

sub parse_constant {
	return q/my $<name>; sub <name> () { <content> }/;
}
###########################################################################
sub parse_parser_var_boost {
	my $content		= &string;
	my $regexp		= grammar->{PARSER}{CODE_VARS};
	$content 		=~ s/(?<!var\s)(?<!sub\s)(?<!\-\>)(?<!\$)\b($regexp)\b/\$$1/gsx if $regexp;
	return $content;
}

sub parse_parser_variable {'<tk_variable>'}

sub parse_parser_list_iter {
	my $list 		= &name_list;
	my $name		= &tk_name;

	my ($before, $after) = &content =~ m/(.*)_LI_(.*)/;
	$list =~ s/($name)\,?/$before.$1.$after/gsxe;

	return $list;
}

sub parse_parser_if {
	my $res = '';
	
	if (eval &CONDITION) {
		$res = &THEN;
	} else {
		$res = &ELSE; #$else || ''; #
	}
	return $res;
}

1;