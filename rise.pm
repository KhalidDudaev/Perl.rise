package rise;
use strict;
use warnings;
use utf8;

######################## DEBUG ##########################
use feature 'say';
use Data::Dump 'dump';
#########################################################

use DateTime;
#use ExtUtils::Installed;
use Time::HiRes qw(time);
# use Clone 'clone';

our $VERSION = '0.001';

# $\ = "\n";

#use dialect::Parents;
use rise::lib::fs::file;
use rise::lib::fs::path;
# use rise::lib::grammar;
use rise::syntax;
# use rise::lib::txt;
#use dialect::syntax_pmd;
#use dialect::syntax_dxml;
#use dialect::Keywords;

#use lib qw | ../bin/ |;

#use parent 'Exporter';
our @EXPORT = qw/conf set_conf run compile compile_list/;
#our @EXPORT_OK = { framework => qw/class run app jump/};


################################################## INIT ####################################################
my $pself;
sub pself { $pself }
our $conf						= __confs_load(__PACKAGE__.'/common');

#%$conf							= ( %{&__confs_load('common')}, %$conf );
my $grammar;
my $parser;
my $syntax;
my $file;
my $path;
my $inst;
my $modules;

my $dt                              = DateTime->now();
# my $auth_set                        = 'unknown';
my $ver_set                         = $dt->year . '.' . sprintf("%02d", $dt->month) . sprintf("%02d", $dt->day) . $dt->hms('');

# $conf->{VERSION}                    = $ver_set if $conf->{VERSION} eq 'auto';

#__init();

#&tokens;
############################################################################################################

sub new {
	my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
    my $self                    = {};
    %$self						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
	# print ">>> " . dump($conf) ."\n";
    $self = bless($self, $class);
	# $self->__init();
	return $self;                         					# обьявляем класс и его свойства
}

# sub import {
# 	my $self					= caller;
# 	my $ARGS 					= $_[1] || {};
#
# 	# print dump $ARGS;
#
# 	#%$conf						= ( %$ARGS, %$conf );
# 	%$conf						= ( %$conf, %$ARGS );
# 	__init();
#
# 	run ($conf->{run})			if $conf->{run};
# 	compile_list($conf->{compile})	if $conf->{compile};
#
# 	no strict 'refs';
# 	foreach (@EXPORT) {
# 		*{$self."::$_"} = *{$_};
# 	}
#
# 	return 1;
# }

sub import {
    my $self                    = shift;
	my $caller					= caller;
	my $ARGS 					= $_[0] || {};

    $self = $self->new;
    $pself = $self;
    #%$conf						= ( %$ARGS, %$conf );
    %$self						= ( %$conf, %$ARGS );

    # say '---------------------------------';
	# say dump $self;
    # say '---------------------------------';

	$self->__init();

	$self->run ($self->{run})			if $self->{run};
	$self->compile_list ($self->{compile})	if $self->{compile};

	no strict 'refs';
    if ($self->{command} eq ':simple') {
    	foreach my $code (@EXPORT) {
    		# *{$caller."::$_"} = \&{$_};
    		*{$caller."::$code"} = sub { &{$code}($self, @_) };
    	}
    }

	return 1;
}



# sub __init {
#     my $self = shift;
#
# 	# $rise::grammar::info_rule	= {};
# 	# print dump $conf;
# 	#$parser						= new dialect::Parser ({ info => $conf->{info} });
#     $self->{VERSION}                    = $ver_set if $self->{VERSION} eq 'auto';
#
#     $self->{file}						= new rise::lib::fs::file::;
#     $path						= new rise::lib::fs::path::;
# 	$grammar					= new rise::lib::grammar:: $self;
# 	$syntax						= new rise::syntax:: $self;
#
# 	print ">>>>>>>>>>>>>> - ".$syntax."\n";
#
# 	$self->{SYNTAX}->confirm;
#
# 	#$inst    					= new ExtUtils::Installed;
# 	#$parser						= $self->{SYNTAX}->parser;
# 	#$modules 					= join ( " ", $inst->modules);
# }

sub __init {
    my $self                    = shift;

    $self->{VERSION}            = $ver_set if $self->{VERSION} eq 'auto';

    $self->{file}			    = new rise::lib::fs::file::;
    $path                       = new rise::lib::fs::path::;
	# $self->{GRAMMAR}            = new rise::lib::grammar:: $self;
	$self->{SYNTAX}				= new rise::syntax:: $self;

	# say ">>>>>>>>>>>>>> - ".$syntax;

	$self->{SYNTAX}->confirm;

}

# sub set_conf {
#     my($self, $newconf) 	    = @_;
#     %$conf						= ( %$conf, %$newconf );
#     __init();
# }

sub __confs_load {
    # (my $self, @_) 				= @_;
    my $fname       			= shift;
    return require $fname . '.confs';
}

sub set_conf {
    $conf = shift;
}

sub __line (;$){
	my $args		= shift;
	my $char		= $args->{char} || '#';
	my $title		= $args->{title} || '';
	my $length		= $args->{length} || 75;

	$title			= $char x 3 . '[ ' . $title . ' ]' if $title;
	return $title . $char x ($length - length($title));
}

sub say { local $\ = ""; print @_ , "\n"; };

sub __msg_box (;$$){
	my $text		= shift || 'NO TEXT';
	my $title		= shift || 'NO TITLE';

	# $title			= '### ' . $title . ' ';
	# $title			= $title . line('#', 80 - length($title));

	say __line { title => $title };
	say $text;
	say __line;
}

sub run {
	my ($self, $appname_source)				= @_;

	my $file_dest				= $self->compile_list([$appname_source]);

	__message_box("run $appname_source ...");
	my $time_start_run = time;

	eval { package main; require $file_dest->{fname}; };
	die $@ if ($@);

	my $time_end_run = time;
	my $time_run = $time_end_run - $time_start_run;

	__message_box("running time $time_run seconds ...");

}

sub compile_list { #print "#### COMPILE ####\n";
	my ($self, $appname_source)				= @_;
	my $assembly = '';
	my $info;
	my @app_stack = @$appname_source;
	my $fname_source;
	my $fname_dest;
    my $fpath;
    my $basename;
    my $fext;

	my $time_start_compile = time;

 	no strict 'refs';
		push @app_stack, @{$self->syntax->grammar->{VAR}{app_stack}};

	foreach (@app_stack) {
		# print $_;
        # print '>>>>>>>>>' . $_ . "<<<<\n";
		if ($self->__truefile($_)){
            $fpath                  = $path->path($_);
            $basename               = $path->basename($_);
            $fext                   = $path->ext($_) || $self->{source}{fext};
			$fname_source			= $fpath . $basename . '.' . $fext;
			$fname_dest				= $fpath . $basename . '.' . $self->{dest}{fext};
			$assembly = $self->compile($fname_source, $fname_dest);
			$info = $assembly->{info};
		}
	}

	my $time_end_compile = time;
	my $time_compile = $time_end_compile - $time_start_compile;
	__message_box("compilation time $time_compile seconds ...");

	return $assembly;
}

sub compile { #print "#### COMPILE ####\n";
	my ($self, $fname_source, $fname_dest) 				= @_;

	my $title					= $fname_source;
	my $code_dest;
	my $code_source;
	my $info                    = '';

    # print '>>>>>>>>> ' . $fname_source . "\n";
	$code_source				= $self->__file('read', $fname_source);
    # $code_source				= $self->{file}->read($fname_source);


    # say '---------------- COMPILE -----------------';
    # say dump $self->syntax->{ACTION}{_variable_list};
    # say '---------------------------------';

	if ($code_source) {
		# $self->grammar->clear;
        $self->syntax->grammar->{FNAME}             = $fname_source;
		# $self->syntax->{RULE}             = $self->grammar->compile_RBNF($self->syntax->{RULE});



		# ($code_dest, $info)		     = $self->grammar->parse( $code_source, $self->syntax->grammar );
		($code_dest, $info)		     = $self->syntax->compile( $code_source );

        # say '---------------------------------';
    	# say $code_dest;
        # say '---------------------------------';

		$code_dest .= "\n1;";
		$self->__file('write', $fname_dest, $code_dest) if $fname_dest;
	}

	$info =~ s/\n$//gsx;
	__msg_box ($info,'compilation ' . $title ) if $self->{info} == 2;
	say 'compilation ' . $title . '...OK' if $self->{info};

	return {code => $code_dest, fname => $fname_dest, info => $info};
}

#sub __obj__		{ $parser }
# sub grammar		{ shift->{GRAMMAR} }
sub syntax      { shift->{SYNTAX} }
# sub syntax      { shift->{SYNTAX}->compile }
sub __file		{ shift->{file}->file(@_) }
# sub clear		{ shift->grammar->clear }

sub __message { print @_ if $conf->{info} }

sub __message_box {
	my $message = shift;
	my $txt;
	$txt .= "\n\n";
	$txt .= "*******************************************************************************\n";
	$txt .= "                         $message\n";
	$txt .= "*******************************************************************************\n";
	__message $txt;
}

sub __truefile {
	my ($self, $mname) 				= @_;
	$mname =~ s/\//::/gsx;
	$mname =~ s/\.\w+//gsx;

	#return 0 if $modules =~ m/$mname/gsx;
	return 1;
}

sub __class_ref {
	my $self					= shift if (ref $_[0] eq __PACKAGE__);
	$self						||= pself;
	return $self, @_;
}

# DESTROY {
# 	$rise::grammar::info_rule	= {};
# }
#########################################################################

exit if $conf->{end};

1;
