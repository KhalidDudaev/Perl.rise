package rise::grammar;

use strict;
use warnings;
use 5.008;
use utf8;

# use Clone 'clone';
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
compile_RBNF
rule_array
rule_list
rule_last_var
gettok
/;

our %EXPORT_TAGS 	= ( simple => [@EXPORT_OK] );

my $PACK_ENV 						= {};
my $GRAMMAR							= {};

# $GRAMMAR->{ORDER}       = [''];

my $all_k = '';
my $all_v = '';
my $or = '';
my $word_b = '';
my ($k, $v);
my $last_rule_name					= '';

# our $info_rule						= {};
# my $info_all						= '';
# my @{$self->{rule_order}};
our $parser_count					= 0;

our $syntax_class;

my ($child, $file, $line, $func);

#sub new {
#    my ($param, $class, $self)	= ($PACK_ENV, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
#	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
#    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
#
#
#
#	return $self;
#}

sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$PACK_ENV						= (%$PACK_ENV, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    #__init();


	my $self = bless($PACK_ENV, $class);

	#print ">>>>>>>>>> ".dump($self)."\n";
	# $info_rule	= {};
	return $self;                         					# обьявляем класс и его свойства
}

# sub import { $info_rule	= {}; };

sub grammar :lvalue	{ $GRAMMAR }
sub order :lvalue	{ grammar->{ORDER} }
sub action_array	{ keys(%{grammar->{ACTION}}) }
sub action_list	{ __arr2list( &action_array ) }
sub rule_array	{ keys(%{grammar->{RULE}}) }
sub rule_list	{ __arr2list( &rule_array ) }
sub token_array	{ keys(%{grammar->{TOKEN}}) }
sub token_list	{ __arr2list( &token_array ) }
sub keyword_array	{ values(%{grammar->{KEYWORD}}) }
sub keyword_list	{ __arr2list( &keyword_array ) }
sub ra			{ grammar->{RULE_LAST_VAR}{RA}[$_] }

sub var :lvalue {
	(my $self, @_) 			= __class_ref(@_);
	my ($name) 				= @_;

	return grammar->{VAR}{$name};
}

sub keyword {
	(my $self, @_) 			= __class_ref(@_);
	my ($key, $word) 		= @_;
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
	(my $self, @_) 			= __class_ref(@_);
	my ($token, $lexem) 	= @_;
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

sub off_token {
	(my $self, @_) 			= __class_ref(@_);
	my ($token, $lexem) 	= @_;
	my $res;

	if ($lexem) {
		$res				= __token($self, $token, $lexem);
	} elsif (exists grammar->{TOKEN}{$token}) {
		$res = grammar->{TOKEN}{$token};
	} else {
		__error('"this token is missing at line $line from $file\n"');
	}
	return $res;
}

sub rule {
	(my $self, @_) 			= __class_ref(@_);
	my ($action, $rule) 	= @_;
	#my $rule_list			= rule_list();
	my $res;

	#$action = '_'.$action;


	if ($rule) {
		$rule 				= __precompile_rule($self, $rule) if $rule !~ m/^\(\?\^\w*\:/;

		$rule 				= __compile_RBNF($action, $rule, &rule_list, &keyword_list);

		$res				= __rule($self, $action, $rule);

		#grammar->{RULE}	= compile_RBNF(grammar->{RULE});


	} elsif (exists grammar->{RULE}{$action}) {
		$res = grammar->{RULE}{$action};
	} else {
		__error('"this rule is missing at line $line from $file\n"');
	}
	return $res;
}

sub action {
	(my $self, @_) 			= __class_ref(@_);
	my ($action, $code) 	= @_;
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
	#my $tself = shift;
	my $self;
	my $source;
	my $rule_name_selected = [];
	my $confs;

	# my $fself;

	($self, $source, grammar, $rule_name_selected, $confs,  @_)	= __class_ref(@_);

	# print ">>>>>>>>>>>>>>>>>>> ".dump($rule_name_selected)." - ".dump($confs)."\n";
	# print ">>> ".dump($confs)."\n";
	# print ">>> $self\n";

	# print "---> ".dump($info_rule)."\n";

	#$self = __PACKAGE__;

	#my $source				= $_[0];
	#grammar				= $_[1] if $_[1];

	my $rule				= '';
	my $rule_name			= '';
	my $rule_list			= rule_list();
	my $rmode				= '';
	my $regex_mod			= '';
	#my $info				= '';
	# my $passed 				= 0;
	my @order;
	# my $info_all			= '';

	# $info_rule				= {} if $parser_count > 2;
	$parser_count++;




	@order					= @{&order} if &order;
	@order					= @$rule_name_selected if $rule_name_selected;

	#my @order				= ($rule_name_selected) || @{&order};
	#my @order				= ($rule_name_selected)||('_');

	#grammar->{TOKEN}		= compile_RBNF(grammar->{TOKEN});
	#grammar->{RULE}		= compile_RBNF(grammar->{RULE}, grammar->{TOKEN});
	#grammar->{RULE}		= compile_RBNF(grammar->{RULE});

	#eval {
		map {
			$rule_name 		= $_;
			#push @{$self->{rule_order}}, $rule_name;

			my $regex_g		= '';
			my $last_sourse = '';
			my $res_sourse	= '';
			# $info_all				= '';

			#grammar->{RULE}	= compile_RBNF(grammar->{RULE});

			$rule 			= grammar->{RULE}{$rule_name} || '';

			#$rule 			= __compile_RBNF($rule, $rule_list, $rule_name);


			($regex_g)		= $rule =~ s/^(G\:)//gsx;
			# $rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>[^\\b]\W+/;
			$rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>(?<!\\b)\W+/;
			# $rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>[^\\b]/;
			# $rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>/;
            # $rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>\w/;
			# $rule			= '\b'.$rule if $rule !~ m/^(?:\(\?)/;
			# $rule			= '\b'.$rule if $rule !~ m/^\(\?\<\w+\>(?!\\b)/;
			# $rule			= '\b'.$rule;
			# $rule			= qr/$rule/o;
            # print $rule . "\n";

            $source =~ s/$rule/__parse($self, $rule_name, $source, $confs, \$last_sourse)/gmsxe if $source ne $last_sourse;
            # $source =~ s/$rule/__parse($self, $rule_name, $source, $confs, \$last_sourse, \$passed)/sxe;
			# while ($source =~ s/$rule/__parse($self, $rule_name, $source, $confs, \$last_sourse, \$passed)/gmsxe && $source ne $last_sourse){};

      #$source = __parse_helper($rule_name, $rule, $source, \$last_sourse, \$passed);


			#my $cnt			= 23 - length $rule_name;
			#my $indent		= 4 - length $passed;
			#
			#$info_all .= " " x $cnt . $rule_name . " --- [" . " " x $indent . $passed . " ] : PASSED\n" if $passed;
			#

			#{@{$self->{rule_order}}}->{$rule_name} += $passed;

			push (@{$self->{rule_order}}, $rule_name) unless exists $self->{info_rule}{$rule_name};
			# push (@{$self->{rule_order}}, $rule_name) if $info_all eq '';

			$self->{info_rule}{$rule_name}	+= $self->{passed};
			$self->{passed}					= 0;



			# print "$rule_name \n" if $self->{passed} eq undef;

		} @order;
	#};

	#die __error('"the action \"'.$rule_name.'\" not correct $file at line $line from $file\n"') if $@;


	$self->{info_all} = '';
	# $info_rule				= {} if !$confs;

	map {
		# if ( $self->{info_rule}{$rule_name} ){
			my $rule_name = $_;
			my $cnt			= 23 - length $rule_name;
			my $indent		= 4 - length ($self->{info_rule}{$rule_name}||'');
			# $self->{info_all} .= " " x $cnt . $rule_name . " --- [" . " " x $indent . $self->{info_rule}{$rule_name} . " ] : PASSED\n";
			$self->{info_all} .= " " x $cnt . $rule_name . " --- [" . " " x $indent . $self->{info_rule}{$rule_name} . " ] : PASSED\n" if $self->{info_rule}{$rule_name};
		# }
	} @{$self->{rule_order}}; #keys %$info_rule;


	# $info_rule = {};


	$parser_count--;

	if (!$parser_count){
		$self->{info_rule}		= {};
		$self->{rule_order}		= [];
	}
	# print ">>> $parser_count\n";

	return ($source, $self->{info_all}) if wantarray;
	return $source;
}

sub __parse_helper {
	my ($rule_name, $rule, $source, $last_sourse, $passed) = @_;

	if ($source ne $$last_sourse && $source =~ s/$rule/__parse($rule_name, $source, $last_sourse, $passed)/gmsxe) {
		#$source =~ s/$rule/__parse($rule_name, $source, $last_sourse, $passed)/gmsxe;
		$source = __parse_helper($rule_name, $rule, $source, $last_sourse, $passed);
	}
	return $source;
}

sub __parse {
	my ($self, $rule_name, $source, $confs, $last_sourse) = @_;
	my $res			= '';
	# $info_all 		= '';
	# print "-----> ".dump($info_rule)."\n";
	# $info_rule		= {} if !$confs;

	#print ">>>>>>>>>>>>>>>>>>> $rule_name - ".dump($confs)."\n" if $rule_name;

	$self->{passed}++;

	die __error('"the action \"'.$rule_name.'\" not exists\n"') if !exists grammar->{ACTION}{$rule_name};
	#eval {
		$res			= (exists grammar->{ACTION}{$rule_name} ? __action($self, $rule_name, $confs) : __rule(__PACKAGE__, $rule_name));
	#};
	#die __error('"the action \"'.$rule_name.'\" not correct\n"') if $@;
	$$last_sourse	= $source;

	#$res ||= "### RISE COMPILE TEST ###"

	return $res;
}

sub compile_RBNF {
	(my $self, @_) 						= __class_ref(@_);

	my ($rule_hash, $token_hash)		= @_;
	my $rule							= '';
	my $rule_comp						= {};
	#my @rule_arr						= keys %$rule_hash;
	#my $rule_list						= __arr2list( @rule_arr );

	#my @rule_arr						= rule_array();
	my $rule_list						= rule_list();
	my $keyword_list					= keyword_list();
	#grammar->{KW_LIST}					= __arr2list(values %{grammar->{KEYWORD}});

	#$rule_list							.= '|' . __arr2list( keys %$token_hash ) if $token_hash;

	map {
		$rule 							= ${$rule_hash}{$_};
		$rule 							= __compile_RBNF($_, $rule, $rule_list, $keyword_list); # if $token_hash;
		$rule_comp->{$_} 				= $rule;
	} &rule_array;

	return $rule_comp;
}

sub gettok {
	(my $self, @_) 			= __class_ref(@_);
	my $token 				= shift;
	my $value				= $+{$token};
	return $value;
}

sub rule_last_var :lvalue {
	(my $self, @_) 			= __class_ref(@_);
	my $token 				= shift;
	grammar->{RULE_LAST_VAR}{$token};
}

######################################################################################################################

sub __arr2list { return '\b' . join ('\b|\b', @_) . '\b' }

#sub _rule_or_token {
#	my ($self, $name) 			= @_;
#	return grammar->{RULE}{$name} if exists grammar->{RULE}{$name};
#	return grammar->{TOKEN}{$name} if exists grammar->{TOKEN}{$name};
#}

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
	my $self		= shift;
	my $action 		= shift;
	my $confs		= shift;

	my $res;
	my $sps;
	my $rule_list	= rule_list();

	#print ">>>>>>>>>>>>>>>>>>> $action - ".dump($confs)."\n" if $action;

	__save_rule_last_var();

	#eval {
		$res = grammar->{ACTION}{$action}($self, $action, $confs); # or die __error('"the action \"'.$action.'\" not correct\n"');
		$res or die __error('"the action \"'.$action.'\" not correct\n"') if $res ne '';
	#};
	#die __error('"the action \"'.$action.'\" not correct\n $@ \n"') if $@;


	$res =~ s/\.\.\./$sps++; grammar->{RULE_LAST_VAR}{SPS}[$sps] || ''/gsxe;
	$res =~ s/\<kw\_(\w+)\>/grammar->{KEYWORD}{$1}/gsxe;
	$res =~ s/\<tk\_(\w+)\>/grammar->{RULE}{$1}/gsxe;
	$res =~ s/\<($rule_list)\>/grammar->{RULE_LAST_VAR}{$1} || ''/gsxe;
	$res =~ s/\<sps(\d+)\>/grammar->{RULE_LAST_VAR}{SPS}[$1] || ''/gsxe;
	$res =~ s/\<spsall\>/grammar->{RULE_LAST_VAR}{SPSALL} || ''/gsxe;

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

	grammar->{RULE_LAST_VAR}		= {};
	grammar->{RULE_LAST_VAR}{RA}	= [];
	grammar->{RULE_LAST_VAR}{SPS}	= [];

	map {
		grammar->{RULE_LAST_VAR}{$_} = $+{$_} if defined $+{$_};
	}&rule_array;

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

	#$rule		=~ s/\(($token_list)\)/(?<$1>$1)/gsx;

	#if ($rule =~ /\(($token_list)(?::(\d+))?\)/){
	#
	#}

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

	#$rule		=~ s/
	#		\(($token_list)(?::(\d+))?\)
	#	/
	#		'(?<'.$1.($2 ? '_'.$2 : '').'>'.$1.')'
	#/gsxe;

	#{no strict; no warnings;
	#	*{$self.'::'.$token}		= sub { grammar->{RULE_LAST_VAR}{$token} || '' };
	#	*{$self.'::tk_'.$token}		= sub { grammar->{RULE}{$token} };
	#}


	#$rule		=~ s/\(($token_list)(?::(\d+))?\)/(?<$1($2||)>$1)/gsx;
	#$rule		=~ s/\(($token_list)(?::(\d+))?\)/'(?<'.$1.($2||'').'>'.$1.')'/gsxe;

	$rule		=~ s/\s+/$snum++; '(?<sps'.$snum.'>\s*)'/gsxe;
	#$rule		=~ s/\s+/\\s+/gsx;

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

#sub __class_ref {
#	my $this					= shift if (ref $_[0] eq __PACKAGE__);
#	$this						||= $PACK_ENV;
#	%$this						= (%$this, %$PACK_ENV);
#	return $this, @_;
#}

sub __class_ref {
	my $self;

	if (ref $_[0] eq __PACKAGE__){
		$self = shift;
	} else {
		$self = caller(1);
	}

	# print " SELF >>> $self \n";

	return $self, @_;
}

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
