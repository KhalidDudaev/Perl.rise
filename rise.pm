package rise;
use strict;
use warnings;
use utf8;

use DateTime;
#use ExtUtils::Installed;
use Time::HiRes qw(time);
# use Clone 'clone';
use Data::Dump 'dump';

our $VERSION = '0.001';

# $\ = "\n";

#use dialect::Parents;
use rise::lib::fs::file;
use rise::lib::fs::path;
use rise::grammar;
use rise::syntax;
# use rise::lib::txt;
#use dialect::syntax_pmd;
#use dialect::syntax_dxml;
#use dialect::Keywords;

#use lib qw | ../bin/ |;

#use parent 'Exporter';
our @EXPORT = qw/conf run compile compile_list __obj__/;
#our @EXPORT_OK = { framework => qw/class run app jump/};


################################################## INIT ####################################################
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
	%$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
	# print ">>> " . dump($conf) ."\n";
	# __init();
	return bless($conf, $class);                         					# обьявляем класс и его свойства
}

sub import {
	my $this					= caller;
	my $ARGS 					= $_[1] || {};

	# print dump $ARGS;

	#%$conf						= ( %$ARGS, %$conf );
	%$conf						= ( %$conf, %$ARGS );
	__init();

	run ($conf->{run})			if $conf->{run};
	compile_list($conf->{compile})	if $conf->{compile};

	no strict 'refs';
	foreach (@EXPORT) {
		*{$this."::$_"} = *{$_};
	}

	return 1;
}



sub __init {

	# $rise::grammar::info_rule	= {};
	# print dump $conf;
	#$parser						= new dialect::Parser ({ info => $conf->{info} });
    $conf->{VERSION}                    = $ver_set if $conf->{VERSION} eq 'auto';

    $file						= new rise::lib::fs::file::;
    $path						= new rise::lib::fs::path::;
	$grammar					= new rise::grammar:: $conf;
	$syntax						= new rise::syntax:: $conf;

	# print ">>>>>>>>>>>>>> - ".dump($grammar)."\n";

	$syntax->confirm;

	#$inst    					= new ExtUtils::Installed;
	#$parser						= $syntax->parser;
	#$modules 					= join ( " ", $inst->modules);
}

# sub set_conf {
#     my($this, $newconf) 	    = __class_ref(@_);
#     %$conf						= ( %$conf, %$newconf );
#     __init();
# }

sub __confs_load {
    (my $this, @_) 				= __class_ref(@_);
    my $fname       			= shift;
    return require $fname . '.confs';
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
	my ($this, $appname_source)				= __class_ref(@_);

	my $file_dest				= compile_list([$appname_source]);

	__message_box("run $appname_source ...");
	my $time_start_run = time;

	eval { package main; require $file_dest->{fname}; };
	die $@ if ($@);

	my $time_end_run = time;
	my $time_run = $time_end_run - $time_start_run;

	__message_box("running time $time_run seconds ...");

}

sub compile_list { #print "#### COMPILE ####\n";
	my ($this, $appname_source)				= __class_ref(@_);
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
		push @app_stack, @{&__syntax->{VAR}{app_stack}};

	foreach (@app_stack) {
		# print $_;
        # print '>>>>>>>>>' . $_ . "<<<<\n";
		if (__truefile($_)){
            $fpath                  = $path->path($_);
            $basename               = $path->basename($_);
            $fext                   = $path->ext($_) || $this->{source}{fext};
			$fname_source			= $fpath . $basename . '.' . $fext;
			$fname_dest				= $fpath . $basename . '.' . $this->{dest}{fext};
			$assembly = compile($fname_source, $fname_dest);
			$info = $assembly->{info};
		}
	}

	my $time_end_compile = time;
	my $time_compile = $time_end_compile - $time_start_compile;
	__message_box("compilation time $time_compile seconds ...");

	return $assembly;
}

sub compile { #print "#### COMPILE ####\n";
	my ($this, $fname_source, $fname_dest) 				= __class_ref(@_);

	my $title					= $fname_source;
	my $code_dest;
	my $code_source;
	my $info                    = '';

    # print '>>>>>>>>> ' . $fname_source . "\n";
	$code_source				= __file('read', $fname_source);
    # $code_source				= $file->read($fname_source);



	if ($code_source) {
		# $grammar->clear;
        $grammar->{FNAME}       = $fname_source;
		&__syntax->{RULE}		= $grammar->compile_RBNF(&__syntax->{RULE});
		($code_dest, $info)		= $grammar->parse($code_source, &__syntax);
		$code_dest .= "\n1;";
		__file('write', $fname_dest, $code_dest) if $fname_dest;
	}

	$info =~ s/\n$//gsx;
	__msg_box ($info,'compilation ' . $title ) if $this->{info} == 2;
	say 'compilation ' . $title . '...OK' if $this->{info};

	return {code => $code_dest, fname => $fname_dest, info => $info};
}

#sub __obj__		{ $parser }
sub __parse		{ $grammar->parse(@_) }
sub __syntax	{ $syntax->syntax(@_) }
sub __file		{ $file->file(@_) }
sub clear		{ $grammar->clear }

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
	my ($this, $mname) 				= __class_ref(@_);
	$mname =~ s/\//::/gsx;
	$mname =~ s/\.\w+//gsx;

	#return 0 if $modules =~ m/$mname/gsx;
	return 1;
}

sub __class_ref {
	my $this					= shift if (ref $_[0] eq __PACKAGE__);
	$this						||= $conf;
	return $this, @_;
}

# DESTROY {
# 	$rise::grammar::info_rule	= {};
# }
#########################################################################

exit if $conf->{end};

1;
