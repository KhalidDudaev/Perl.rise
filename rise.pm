package rise;
use strict;
use warnings;
use utf8;
#use ExtUtils::Installed;
use Time::HiRes qw(time);

use Data::Dump 'dump';

our $VERSION = '0.001';

# $\ = "\n";

#use dialect::Parents;
use rise::file;
use rise::grammar;
use rise::syntax;
#use dialect::syntax_pmd;
#use dialect::syntax_dxml;
#use dialect::Keywords;

#use lib qw | ../bin/ |;

#use parent 'Exporter';
our @EXPORT = qw/conf run compile __obj__/;
#our @EXPORT_OK = { framework => qw/class run app jump/};


################################################## INIT ####################################################
our $conf						= __confs_load(__PACKAGE__.'/common');

#%$conf							= ( %{&__confs_load('common')}, %$conf );
my $grammar;
my $parser;
my $syntax;
my $file;
my $inst;
my $modules;

#__init();

#&tokens;
############################################################################################################

sub import {
	my $this					= caller;
	my $ARGS 					= $_[1] || {};

	# print dump $ARGS;

	#%$conf						= ( %$ARGS, %$conf );
	%$conf						= ( %$conf, %$ARGS );
	__init();

	run ($conf->{run})			if $conf->{run};
	compile($conf->{compile})	if $conf->{compile};

	no strict 'refs';
	foreach (@EXPORT) {
		*{$this."::$_"} = *{$_};
	}

	return 1;
}



sub new {
    my ($class, $ARGS)			= (ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$conf						= (%$conf, %$ARGS);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    #__init();
	return bless($conf, $class);                         					# обьявляем класс и его свойства
}

sub __init {

	# print dump $conf;
	#$parser						= new dialect::Parser ({ info => $conf->{info} });
	$file						= new rise::file;
	$grammar					= new rise::grammar $conf;
	$syntax						= new rise::syntax $conf;

	# print ">>>>>>>>>>>>>> - ".dump($grammar)."\n";

	$syntax->confirm;

	#$inst    					= new ExtUtils::Installed;
	#$parser						= $syntax->parser;
	#$modules 					= join ( " ", $inst->modules);


}

sub __confs_load {
    (my $this, @_) 				= __class_ref(@_);
    my $fname       			= shift;
    return require $fname . '.confs';
}

sub run {
	my ($this, $appname_source)				= __class_ref(@_);

	my $file_dest				= compile([$appname_source]);

	__message_box("run $appname_source ...");
	my $time_start_run = time;

	eval { package main; require $file_dest->{fname}; };
	die $@ if ($@);

	my $time_end_run = time;
	my $time_run = $time_end_run - $time_start_run;

	__message_box("running time $time_run seconds ...");

}

sub compile { #print "#### COMPILE ####\n";
	my ($this, $appname_source)				= __class_ref(@_);
	my $assembly = '';
	my $info;
	my @app_stack = @$appname_source;

	my $time_start_compile = time;

	#if (__truefile($appname_source)){
	# __message_box("compilation ". dump($appname_source)." ...");
	#	$assembly = __assembly( $appname_source );
	#	$info = $assembly->{info};
	#	__message ("$info\n") if $info ;
	#}
 	no strict 'refs';
	# if (&__syntax->{VAR}{app_stack}) {
		push @app_stack, @{&__syntax->{VAR}{app_stack}};
	# }

	foreach (@app_stack) {
		# print $_;
		if (__truefile($_)){

			__message_box("compilation $_ ...");
			#$info = __assembly($_)->{info};
			$assembly = __assembly($_);
			$info = $assembly->{info};
			__message ("$info\n") if $info;
		}
	}

	my $time_end_compile = time;
	my $time_compile = $time_end_compile - $time_start_compile;
	__message_box("compilation time $time_compile seconds ...");

	return $assembly;
}

sub __assembly { #print "#### ASSEMBLY ####\n";
	my ($this, $appname_source) 				= __class_ref(@_);

	my $code_dest;
	my $code_source;
	my $info;
	my($path_current)			= $0 =~ m/^(.*?)\w+(?:\.\w+)*$/sx;
	my $path_source				= $this->{source}{fpath}	|| $path_current;
	my $path_dest					= $this->{dest}{fpath}		|| $path_current;
	my $fext							= $this->{source}{fext};

	my $fname_source			= $path_source	. $appname_source . $this->{source}{fext};
	my $fname_dest				= $path_dest		. $appname_source . $this->{dest}{fext};

	if (!$fname_dest){
		$fname_dest				= $fname_source;
		$fname_dest				=~ s/(\w+)$fext/$1/sx;
		$fname_dest				= $fname_dest . $this->{dest}{fext};
	}

	# print $fname_source;
	$code_source				= __file('read', $fname_source);

	if ($code_source) {
		&__syntax->{RULE}		= $grammar->compile_RBNF(&__syntax->{RULE});
		($code_dest, $info)		= __parse($code_source, &__syntax);
		$code_dest .= "\n1;";
		__file('write', $fname_dest, $code_dest);
	}
	#print "$info";
	return {code => $code_dest, fname => $fname_dest, info => $info};
}

#sub __obj__		{ $parser }
sub __parse		{ $grammar->parse(@_) }
sub __syntax	{ $syntax->syntax(@_) }
sub __file		{ $file->file(@_) }

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
#########################################################################

exit if $conf->{end};
1;
