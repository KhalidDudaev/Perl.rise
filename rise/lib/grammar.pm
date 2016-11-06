package rise::lib::grammar;

use strict;
use warnings;
use 5.008;
use utf8;

# use Clone 'clone';
######################## DEBUG ##########################
use feature 'say';
use Data::Dump 'dump';
#########################################################

our $VERSION = '0.100';

my $export 		= [qw/
	var
	keyword
	token
	rule
	action
	order
	parse
	grammar
	compile_RBNF
	rule_array
	rule_list
	rule_last_var
	gettok
/];

my $pself;
sub pself { $pself }

# my $PACK_ENV 						= {};
my $GRAMMAR							= {};

# $GRAMMAR->{ORDER}       = [''];

my $all_k = '';
my $all_v = '';
my $or = '';
my $word_b = '';
my ($k, $v);
my $last_rule_name					= '';

our $parser_count					= 0;

our $syntax_class;

my (
    $child,
    $file,
    $line,
    $func
);

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	# %$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    my $self                    = {};
    %$self						= (%$self, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
	return bless($self, $class);                         					# обьявляем класс и его свойства
}

sub import { no strict;
    my $self                           = shift;
	my $caller                         = caller;
	my $cmd                            = shift;

    $self = $self->new;
    $pself = $caller;

    # say 'grammar caller - '.$pself;

	no strict 'refs';
    if ($cmd && $cmd eq ':simple') {
    	foreach my $code (@$export) {
    		*{$caller."::".$code} = *{$code};
    		# *{$caller."::$code"} = sub { &{$code}($self, @_) };
    	}
    }

	return 1;
}

# sub self {
# 	my $self					= shift if (ref $_[0] eq __PACKAGE__);
# 	# $self						||= caller(1);
# 	$self						||= pself;
#     # say 'class_ref - '.$self;
# 	return $self, @_;
# }

sub self {
	my $self					= shift if (ref $_[0] eq __PACKAGE__);
	# $self						||= caller(1);
	$self						||= pself;
    # say 'class_ref - '.$self;
	return $self;
}

sub grammar :lvalue	{ $GRAMMAR }
sub action_array	{ keys(%{grammar->{ACTION}}) }
sub action_list     { __arr2list( action_array ) }
sub rule_array      { keys(%{grammar->{RULE}}) }
sub rule_list       { __arr2list( rule_array ) }
sub token_array     { keys(%{grammar->{TOKEN}}) }
sub token_list      { __arr2list( token_array ) }
sub keyword_array	{ values(%{grammar->{KEYWORD}}) }
sub keyword_list	{ __arr2list( keyword_array ) }
sub ra			    { grammar->{RULE_LAST_VAR}{RA}[$_] }

sub order	{
    my $self							= &self;
	my $data							= shift;
    grammar->{ORDER}                = $data if $data;
    grammar->{ORDER};
}

sub var :lvalue {
	# my $self 			= shift;
    my $self							= &self;
	my $name							= shift;
    {no strict; no warnings;
        *{$self.'::var_'.$name}		= sub ($):lvalue { grammar->{VAR}{$name} };
    }
	return grammar->{VAR}{$name};
}

# sub var {
# 	# my $self 			= shift;
#     my $self                    = &self;
# 	my ($name, $data)       = @_;
#     grammar->{VAR}{$name}   = $data if $data;
# 	return grammar->{VAR}{$name};
# }

sub keyword {
	# my $self                           = shift;
    my $self							= &self;
	my $key								= shift;
	my $word							= shift;
	# my ($key, $word)                   = @_;
	my $res;

	if ($word) {
	 grammar->{KEYWORD}{$key} = $word;
		{no strict;
			*{$self.'::kw_'.$key}		= sub { grammar->{KEYWORD}{$key} };
		}
		$res = $word;
	} elsif (exists grammar->{KEYWORD}{$key}) {
		$res = grammar->{KEYWORD}{$key};
	} else {
		__error('"this keyword is missing at line $line from $file\n"');
	}

	return $res;
}

sub token {
	# my $self                           = pself;
    my $self							= &self;
	my $token							= shift;
	my $lexem							= shift;
	# my ($token, $lexem) 	= @_;
	my $res;

	if ($lexem) {
		$res				= __rule($self, $token, $lexem);
	} elsif (exists grammar->{RULE}{$token}) {
		$res = grammar->{RULE}{$token};
	} else {
		__error('"this token is missing at line $line from $file\n"');
	}
	return $res;
}

sub rule {
	# my $self                           = pself;
    my $self							= &self;
    my $action							= shift;
    my $rule							= shift;
	# my ($action, $rule) 	= @_;
	#my $rule_list			= rule_list();
	my $res;

	if ($rule) {
		$rule 				= __precompile_rule($self, $rule) if $rule !~ m/^\(\?\^\w*\:/;
		$rule 				= __compile_RBNF($action, $rule, &rule_list,  keyword_list);
		$res				= __rule($self, $action, $rule);
	} elsif (exists grammar->{RULE}{$action}) {
		$res = grammar->{RULE}{$action};
	} else {
		__error('"this rule is missing at line $line from $file\n"');
	}
	return $res;
}

sub action {
	# my $self                           = pself;
    my $self							= &self;
	my $action							= shift;
	my $code							= shift;
	# my ($action, $code) 	= @_;
	my $res;

	__error('"undefined rule \"'.$action.'\" at $file line $line\n"') unless (exists grammar->{RULE}{$action});

	if ($code) {
	 grammar->{ACTION}{$action} = $code;
		push @{grammar->{ORDER}}, $action;
	}

	if (exists grammar->{ACTION}{$action} && !$code) {
		$res = __action($self, $action);
	}

	if (!exists(grammar->{ACTION}{$action})){
		__error('"action \"'.$action.'\" is missing at $file line $line\n"');
	}

	return $res;
}

sub parse {
	# my $self                           = shift;
	# my $source                         = shift;
	# grammar                            = shift;
	# my $rule_name_selected             = shift || [];
	# my $confs                          = shift;


	my $self;
	my $source;
	my $rule_name_selected = [];
	my $confs;

	# my $fself;

	($self, $source, grammar, $rule_name_selected, $confs,  @_)	= @_;

    # say 'parse source - '.$self;

	my $rule                           = '';
	my $rule_name                      = '';
	my $rule_list                      = rule_list();
	my $rmode                          = '';
	my $regex_mod                      = '';
	my @order;

    $self->{passed}			= 0;

	$parser_count++;

	@order					= @{&order} if order;
	@order					= @$rule_name_selected if $rule_name_selected;

	map {
		$rule_name 		= $_;
        my $regex_g		= '';
		my $last_sourse = '';
		my $res_sourse	= '';

		$rule 			= grammar->{RULE}{$rule_name} || '';
		($regex_g)		= $rule =~ s/^(G\:)//gsx;
		$rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>(?<!\\b)\W+/;
        $source         =~ s/$rule/__parse($self, $rule_name, $source, $confs, \$last_sourse)/gmsxe if $source ne $last_sourse;

		push (@{$self->{rule_order}}, $rule_name) unless exists $self->{info_rule}{$rule_name};

		$self->{info_rule}{$rule_name}	+= $self->{passed};
		$self->{passed}					= 0;


	} @order;

	$self->{info_all} = '';

	map {
		# if ( $self->{info_rule}{$rule_name} ){
			my $rule_name = $_;
			my $cnt			= 30 - length $rule_name;
			my $indent		= 4 - length ($self->{info_rule}{$rule_name}||'');
			# $self->{info_all} .= " " x $cnt . $rule_name . " --- [" . " " x $indent . $self->{info_rule}{$rule_name} . " ] : PASSED\n";

            # print "#### $cnt ####\n";

			$self->{info_all} .= " " x $cnt . $rule_name . " --- [" . " " x $indent . $self->{info_rule}{$rule_name} . " ] : PASSED\n" if $self->{info_rule}{$rule_name};
		# }
	} @{$self->{rule_order}}; #keys %$info_rule;

	$parser_count--;

	if (!$parser_count){
		$self->{info_rule}		= {};
		$self->{rule_order}		= [];
	}

	return ($source, $self->{info_all}) if wantarray;
	return $source;
}

# sub __parse_helper {
#
# 	my ($self, $rule_name, $rule, $source, $last_sourse, $passed) = @_;
#
# 	if ($source ne $$last_sourse && $source =~ s/$rule/__parse($rule_name, $source, $last_sourse, $passed)/gmsxe) {
# 		#$source =~ s/$rule/__parse($rule_name, $source, $last_sourse, $passed)/gmsxe;
# 		$source = __parse_helper($rule_name, $rule, $source, $last_sourse, $passed);
# 	}
# 	return $source;
# }

sub __parse {
	my ($self, $rule_name, $source, $confs, $last_sourse) = @_;
	my $res			= '';

	#print ">>>>>>>>>>>>>>>>>>> $rule_name - ".dump($confs)."\n" if $rule_name;

	$self->{passed}++;

	die __error('"the action \"'.$rule_name.'\" not exists\n"') if !exists grammar->{ACTION}{$rule_name};

	$res			= (exists grammar->{ACTION}{$rule_name} ? __action($self, $rule_name, $confs) : __rule(__PACKAGE__, $rule_name));

	$$last_sourse	= $source;

	return $res;
}

sub compile_RBNF {
	# my $self							= shift;
    my $self							= &self;

	my ($rule_hash, $token_hash)		= @_;
	my $rule							= '';
	my $rule_comp						= {};
	my $rule_list						= rule_list();
	my $keyword_list					= keyword_list();

	map {
		$rule 							= ${$rule_hash}{$_};
		$rule 							= __compile_RBNF($_, $rule, $rule_list, $keyword_list); # if $token_hash;
		$rule_comp->{$_} 				= $rule;
	}  rule_array;

	return $rule_comp;
}

sub gettok {
	# my $self							= shift;
    my $self							= &self;
	my $token							= shift;
	my $value							= $+{$token};
	return $value;
}

sub rule_last_var :lvalue {
	# my $self							= shift;
    my $self							= &self;
	my $token							= shift;
    grammar->{RULE_LAST_VAR}{$token};
}

######################################################################################################################

sub __arr2list { return '\b' . join ('\b|\b', @_) . '\b' }

sub __rule {
	my ($self, $token, $rule) 		= @_;

	$syntax_class = $self;

	{no strict; no warnings;
		*{$self.'::'.$token}		= sub {
            return grammar->{RULE_LAST_VAR}{$token} || '';
            # my $res     = '';
            # $res = grammar->{RULE_LAST_VAR}{$token} if grammar->{RULE_LAST_VAR}{$token};
            # $res = '0' if grammar->{RULE_LAST_VAR}{$token} == 0;
            # return $res;
        };

		*{$self.'::tk_'.$token}		= sub { grammar->{RULE}{$token} };
	}

 grammar->{RULE}{$token} = $rule;
	return $rule;
}

sub __action {
	my $self							= shift;
	my $action							= shift;
	my $confs							= shift;

	my $res;
	my $sps;
	my $rule_list	= rule_list();

	#print ">>>>>>>>>>>>>>>>>>> $action - ".dump($confs)."\n" if $action;
    $self->{NOPARSE} = 0;

	__save_rule_last_var();

	#eval {
		$res = grammar->{ACTION}{$action}($self, $action, $confs); # or die __error('"the action \"'.$action.'\" not correct\n"');
		$res or die __error('"the action \"'.$action.'\" not correct\n"') if $res ne '';
	#};
	#die __error('"the action \"'.$action.'\" not correct\n $@ \n"') if $@;

    if (!$self->{NOPARSE}) {
    	$res =~ s/\.\.\./$sps++; grammar->{RULE_LAST_VAR}{SPS}[$sps] || ''/gsxe;
    	$res =~ s/\<kw\_(\w+)\>/grammar->{KEYWORD}{$1}/gsxe;
    	$res =~ s/\<tk\_(\w+)\>/grammar->{RULE}{$1}/gsxe;
    	$res =~ s/\<($rule_list)\>/grammar->{RULE_LAST_VAR}{$1} || ''/gsxe;
    	$res =~ s/\<sps(\d+)\>/grammar->{RULE_LAST_VAR}{SPS}[$1] || ''/gsxe;
    	$res =~ s/\<spsall\>/grammar->{RULE_LAST_VAR}{SPSALL} || ''/gsxe;
    }
    $self->{NOPARSE} = 0;

	return $res;
}



sub __compile_RBNF {
	my ($rule_name, $rule, $rule_list, $keyword_list)			= @_;
	#my $kw_list						= grammar->{KW_LIST};
	#my $keyword_list						= keyword_list();

	$rule ||= '';

	$rule							=~ s/^(?<!\_)($keyword_list)$/\\b$1\\b/gsx;
	$rule							=~ s/(?<!\(\?\<)($rule_list)(?!\>)/__compile_RBNF($1, rule($1), $rule_list, $keyword_list)/gsxe if $rule ne ($1||'');

	return $rule;
}

sub __save_rule_last_var {
    # my $self                            = shift;

    grammar->{RULE_LAST_VAR}		= {};
    grammar->{RULE_LAST_VAR}{RA}	= [];
    grammar->{RULE_LAST_VAR}{SPS}	= [];

	map {
	 grammar->{RULE_LAST_VAR}{$_} = $+{$_} if defined $+{$_};
	} rule_array;

	{no strict; no warnings;
		for my $i (1..15) {
		 grammar->{RULE_LAST_VAR}{SPS}[$i] = $+{'sps'.$i} || '';
			*{$syntax_class.'::sps'.$i}		= sub { grammar->{RULE_LAST_VAR}{SPS}[$i] || '' };

		 grammar->{RULE_LAST_VAR}{SPSALL} .= $+{'sps'.$i} || '';
		}
		*{$syntax_class.'::spsall'}		= sub { grammar->{RULE_LAST_VAR}{SPSALL} || '' };
	}

    grammar->{RULE_LAST_VAR}{RA}	= [$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15];
}

sub __precompile_rule {
	my ($self, $rule) = @_;
	my $token_list	= rule_list();
	my $snum		= 0;

	$rule		=~ s/(?<!\\)[\[{(]/(?:/g;		#$token		=~ s/\((.*?)\)/\(?:$1\)/g;
	$rule		=~ s/(?<!\\)\</(/g;		#$token		=~ s/\((.*?)\)/\(?:$1\)/g;
	$rule		=~ s/(?<!\\)\}/)*/g;		#$token		=~ s/(?<!\\)\{(.*?)(?<!\\)\}/\($1\)*/gsx;
	$rule		=~ s/(?<!\\)\]/)?/g;	#$token		=~ s/\[(.*?)\]/\($1\)?/g;
	$rule		=~ s/(?<!\\)\>/)/g;		#$token		=~ s/\<(.*?)\>/\($1\)/g;

	$rule		=~ s/\(\?\:NOT\:/(?!/g;
	$rule		=~ s/\(\?\:\_NOT\:/(?<!/g;
	$rule		=~ s/\(\?\:M\s*(\w*)\:/(?^$1:/g;

	$rule		=~ s/\(\?\:OR\:(.*?)\)/[$1]/g;
	$rule		=~ s/\(\?\:NOR\:(.*?)\)/[^$1]/g;

	$rule		=~ s/
			\(($token_list)\)(?::(\d+))?
		/
		my $tk = $1;

		if ($2) {
			$tk .= '_'.$2;

			#token $tk => $1;

			{no strict; no warnings;
				*{$self.'::'.$tk}		= sub { grammar->{RULE_LAST_VAR}{$tk} || '' };
				#*{$self.'::tk_'.$1}	= sub { grammar->{RULE}{$1} };
			}

			print "############## >>>>> $tk\n"

		}

		my $res = '(?<'.$tk.'>'.$1.')';
		$res;
	/gsxe;

	$rule		=~ s/\s+/$snum++; '(?<sps'.$snum.'>\s*)'/gsxe;

	return $rule;
}

sub __error {
	my $msg = shift;
	my ($child, $file, $line, $func) = (caller(1));
	my $err = eval $msg;
	$err .= "\n$@";
	die $err;
}

sub clear {
	my $self = shift;
	$self->{info_rule} = {};
}

sub __class_ref {
	my $self					= shift if (ref $_[0] eq __PACKAGE__);
	# $self						||= caller(1);
	$self						||= pself;
    # say 'class_ref - '.$self;
	return $self, @_;
}

# sub __class_ref {
#     my $self;
#
#     if (ref $_[0] eq __PACKAGE__){
#         $self = shift;
#     } else {
#         $self = caller(1);
#     }
#
#     # print " SELF >>> $self \n";
#
#     return $self, @_;
# }

#sub __class_ref {
#	my $this					= shift if (ref $_[0] eq __PACKAGE__);
#	$this						||= $PACK_ENV;
#	%$this						= (%$this, %$PACK_ENV);
#	return $this, @_;
#}

#sub __class_ref {
#	my $self				= shift if (ref $_[0] eq __PACKAGE__);
#	$self					||= $PACK_ENV;
#	($child, $file, $line, $func) = (caller(1));
#	return $self, @_;
#}

# DESTROY {
# 	$info_rule = undef;
# }

1;
