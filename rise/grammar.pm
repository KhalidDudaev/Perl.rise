package rise::grammar;

use strict;
use warnings;
use 5.008;
use utf8;

use Data::Dump 'dump';

our $VERSION = '0.100';

use parent 'Exporter';

our @EXPORT;

our @EXPORT_OK 		= qw/
var
keyword
token
rule
action
order
parse
grammar
rule_array
rule_list
rule_last_var
gettok
/;

our %EXPORT_TAGS 	= ( simple => [@EXPORT_OK] );

my $PACK_ENV 						= {};
my $GRAMMAR							= {};

my $all_k = '';
my $all_v = '';
my $or = '';
my $word_b = '';
my ($k, $v);
our $syntax_class;

my ($child, $file, $line, $func);

sub new {
    my ($param, $class, $self)	= ($PACK_ENV, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
	return $self;
}

sub var :lvalue {
	(my $self, @_) 			= _class_ref(@_);
	my ($name) 				= @_;
	
	return &grammar->{VAR}{$name};
}

sub keyword {
	(my $self, @_) 			= _class_ref(@_);
	my ($key, $word) 		= @_;
	my $res;
	if ($word) {
		&grammar->{KEYWORD}{$key} = $word;
		{no strict;
			*{$self.'::kw_'.$key}		= sub { &grammar->{KEYWORD}{$key} };
		}
		$res = $word;
	} elsif (exists &grammar->{KEYWORD}{$key}) {
		$res = &grammar->{KEYWORD}{$key};
	} else {
		_error('"this keyword is missing at $file line $line\n"');
	}
	
	return $res;
}

sub token {
	(my $self, @_) 			= _class_ref(@_);
	my ($token, $lexem) 	= @_;
	my $res;
	if ($lexem) {	
		$res = __token($self, $token, $lexem);
	} elsif (exists &grammar->{TOKEN}{$token}) {
		$res = &grammar->{TOKEN}{$token};
	} else {
		_error('"this token is missing at line $line from $file\n"');
	}
	return $res;
}

sub rule {
	(my $self, @_) 			= _class_ref(@_);
	my ($action, $rule) 	= @_;
	
	my $res;
	if ($rule) {
		$rule 				= __precompile_rule($rule) if $rule !~ m/^\(\?\^\w*\:/;
		$res = __rule($self, $action, $rule);
	} elsif (exists &grammar->{RULE}{$action}) {
		$res = &grammar->{RULE}{$action};
	} else {
		_error('"this rule is missing at line $line from $file\n"');
	}
	return $res;
}

sub action {
	(my $self, @_) 			= _class_ref(@_);
	my ($action, $code) 	= @_;
	my $res;
	
	_error('"undefined rule \"'.$action.'\" at $file line $line\n"') unless (exists &grammar->{RULE}{$action});

	if ($code) {
		&grammar->{ACTION}{$action} = $code;
		push @{&grammar->{ORDER}}, $action;
	}
	
	if (exists &grammar->{ACTION}{$action}) { 
		$res = __action($action);
	}
	else {
		_error('"action \"'.$action.'\" is missing at $file line $line\n"');
	}
	
	return $res;
}

sub parse {
	(my $self, @_) 			= _class_ref(@_);
	my $source				= $_[0];
	my $rule				= '';
	my $rule_name			= '';
	my $rmode				= '';
	&grammar				= $_[1] if $_[1];
	
	&grammar->{KW_LIST}		= __arr2list(values %{&grammar->{KEYWORD}});
	#my $kw_list				= &grammar->{KW_LIST};
	
	&grammar->{TOKEN}		= compile_RBNF(&grammar->{TOKEN});
	&grammar->{RULE}		= compile_RBNF(&grammar->{RULE}, &grammar->{TOKEN});
	
	eval {
		map {
			$rule_name 	= $_;
			$rule 		= &grammar->{RULE}{$rule_name} || '';
			
			#$rule		=~ s/^(?<!\_)($kw_list)$/\\b$1\\b/gsx;
			$rule		= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>[^\\b]\W+/;
			
			#print "###$rule\n\n";
			print "$rule_name - \n";
			1 while $source =~ s/$rule/exists &grammar->{ACTION}{$rule_name} ? __action($rule_name) : __rule(__PACKAGE__, $rule_name)/gsxe;
			#$source =~ s/$rule/exists &grammar->{ACTION}{$rule_name} ? __action($rule_name) : __rule(__PACKAGE__, $rule_name)/gsxe for 1..3;
		} &order;
	};
	die _error('"the action \"'.$rule_name.'\" not correct $file at line $line from $file\n'.$@.'"') if $@;
	
	return $source;
}

sub grammar :lvalue	{ $GRAMMAR }
sub order		{ @{&grammar->{ORDER}} }
sub rule_array	{ keys(%{&grammar->{RULE}}) }
sub rule_list	{ __arr2list( &rule_array ) }
sub token_array	{ keys(%{&grammar->{TOKEN}}) }
sub token_list	{ __arr2list( &token_array ) }
sub ra			{ &grammar->{RULE_LAST_VAR}{RA}[$_] }

sub compile_RBNF {
	(my $self, @_) 			= _class_ref(@_);
	
	my ($rule_hash, $token_hash)		= @_;
	
	my @rule_arr						= keys %$rule_hash;
	my $rule_list						= __arr2list( @rule_arr );
	#my $rule_list						= &rule_list;
	
	$rule_list							.= '|' . __arr2list( keys %$token_hash ) if $token_hash;

	my $rule							= '';
	my $rule_comp						= {};
	
	map {
		$rule 							= ${$rule_hash}{$_};
		#$rule 							= __compile_token($rule, $rule_list) if !$token_hash;
		
	#{no strict;
	#	*{$syntax_class.'::'.$rule}		= sub { &grammar->{RULE_LAST_VAR}{$rule} || '' };
	#	*{$syntax_class.'::tk_'.$rule}		= sub { &grammar->{TOKEN}{$rule} };
	#}
		
		$rule 							= __compile_RBNF($rule, $rule_list); # if $token_hash;
		$rule_comp->{$_} 				= $rule;
	} @rule_arr;

	return $rule_comp;
}

sub gettok {
	(my $self, @_) 			= _class_ref(@_);
	my $token 				= shift;
	my $value				= $+{$token};
	return $value;
}

sub rule_last_var :lvalue {
	(my $self, @_) 			= _class_ref(@_);
	my $token 				= shift;
	&grammar->{RULE_LAST_VAR}{$token};
}

######################################################################################################################

sub __arr2list { return '\b' . join ('\b|\b', @_) . '\b' }

sub _rule_or_token {
	my ($self, $name) 			= @_;
	return &grammar->{RULE}{$name} if exists &grammar->{RULE}{$name};
	return &grammar->{TOKEN}{$name} if exists &grammar->{TOKEN}{$name};
}

sub __rule {
	my ($self, $token, $rule) 		= @_;
	&grammar->{RULE}{$token} = $rule;
	return $rule;
}

sub __token {
	my ($self, $token, $rule) 		= @_;
	
	$syntax_class = $self;
	
	{no strict;
		*{$self.'::'.$token}		= sub { &grammar->{RULE_LAST_VAR}{$token} || '' };
		*{$self.'::tk_'.$token}		= sub { &grammar->{TOKEN}{$token} };
	}

	&grammar->{TOKEN}{$token} = $rule;
	return $rule;
}

sub __action {
	my $action 		= shift;

	#return undef unless &{&grammar->{ACTION}{$action}};
	
	my $res;
	my $rule_list	= token_list();
	
	my $sps;

	__save_rule_last_var();
	
	$res = &{&grammar->{ACTION}{$action}}; # or _error('"the action \"'.$action.'\" not correct $file at line $line from $file\n"');
	
	#$res =~ s/\.\.\./$sps++; &grammar->{RULE_LAST_VAR}{SPS}[$sps] || ''/gsxe;
	$res =~ s/\.\.\./$sps++; &grammar->{RULE_LAST_VAR}{SPS}[$sps] || ''/gsxe;
	
	$res =~ s/\<kw\_(\w+)\>/&grammar->{KEYWORD}{$1}/gsxe;
	$res =~ s/\<($rule_list)\>/&grammar->{RULE_LAST_VAR}{$1} || ''/gsxe;
	$res =~ s/\<sps(\d+)\>/&grammar->{RULE_LAST_VAR}{SPS}[$1] || ''/gsxe;
	$res =~ s/\<spsall\>/&grammar->{RULE_LAST_VAR}{SPSALL} || ''/gsxe;
	
	
	
	return $res;
}

sub __compile_RBNF {
	my ($rule, $rule_list)			= @_;
	
	my $kw_list						= &grammar->{KW_LIST};
	$rule =~ s/^(?<!\_)($kw_list)$/\\b$1\\b/gsx;
	
				
	$rule =~ s/(?<!\(\?\<)($rule_list)(?!\>)/__compile_RBNF(token($1), $rule_list)/gsxe if $rule ne ($1||'');
	
	#$rule =~ s/\(\?\<(\w+)\>((?:$kw_list)(?:\|(?:$kw_list))*)\)/\\b(?<$1>$2)\\b/gsx;
	#$rule =~ s/(\(\?\<(\w+)\>\w+.*?)/\\b$1/gsx;

	#$rule =~ s/\(\?\:(\w+(?:\|\w+)*)\)/\\b(?:$1)\\b/gsx;
	
	return $rule;
}

sub __save_rule_last_var {

	&grammar->{RULE_LAST_VAR}		= {};
	&grammar->{RULE_LAST_VAR}{RA}	= [];
	&grammar->{RULE_LAST_VAR}{SPS}	= [];
	
	
	
	
	
	map {
		&grammar->{RULE_LAST_VAR}{$_} = $+{$_} if $+{$_};	
	}&token_array;
	
	{no strict; no warnings;
		for my $i (1..15) {
			&grammar->{RULE_LAST_VAR}{SPS}[$i] = $+{'sps'.$i} || '';
			*{$syntax_class.'::sps'.$i}		= sub { &grammar->{RULE_LAST_VAR}{SPS}[$i] || '' };
			
			&grammar->{RULE_LAST_VAR}{SPSALL} .= $+{'sps'.$i} || '';
		}
		*{$syntax_class.'::spsall'}		= sub { &grammar->{RULE_LAST_VAR}{SPSALL} || '' };
	}
	
	&grammar->{RULE_LAST_VAR}{RA}	= [$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15];
	
	#map {
	#	&grammar->{RULE_LAST_VAR}{$_} = $+{$_} if $+{$_};
	#}&rule_array;
}

sub __precompile_rule {
	my ($rule) = @_;
	my $token_list	= token_list();
	my $snum		= 0;

	
	
	$rule		=~ s/(?<!\\)[\[{(]/(?:/g;		#$token		=~ s/\((.*?)\)/\(?:$1\)/g;
	$rule		=~ s/(?<!\\)\</(/g;		#$token		=~ s/\((.*?)\)/\(?:$1\)/g;
	$rule		=~ s/(?<!\\)\}/)*/g;		#$token		=~ s/(?<!\\)\{(.*?)(?<!\\)\}/\($1\)*/gsx;
	$rule		=~ s/(?<!\\)\]/)?/g;	#$token		=~ s/\[(.*?)\]/\($1\)?/g;
	$rule		=~ s/(?<!\\)\>/)/g;		#$token		=~ s/\<(.*?)\>/\($1\)/g;							 
	
	$rule		=~ s/\(\?\:N\:/(?!/g;
	$rule		=~ s/\(\?\:N<\:/(?<!/g;
	$rule		=~ s/\(\?\:M(\w*)\:/(?^$1:/g;
	
	$rule		=~ s/\(($token_list)\)/(?<$1>$1)/gsx;
	
	$rule		=~ s/\s+/$snum++; '(?<sps'.$snum.'>\s*)'/gsxe;
	
	#{no strict;
	#	*{$self.'::'.$token}		= sub { &grammar->{RULE_LAST_VAR}{$token} || '' };
	#	*{$self.'::tk_'.$token}		= sub { &grammar->{TOKEN}{$token} };
	#}
	
	return $rule;
}

sub _error {
	my $msg = shift;
	my ($child, $file, $line, $func) = (caller(1));
	my $err = eval $msg;
	$err .= "\n$@";
	die $err;
}

sub _class_ref {
	my $self;
	(ref $_[0] eq __PACKAGE__) ? $self = shift : $self = caller(1);
	return $self, @_;
}

#sub _class_ref {
#	my $self				= shift if (ref $_[0] eq __PACKAGE__);
#	$self					||= $PACK_ENV;
#	($child, $file, $line, $func) = (caller(1));
#	return $self, @_;
#}

1;