package rise;
use strict;
use warnings;
use utf8;
#use ExtUtils::Installed;
use Time::HiRes qw(time);

use Data::Dump 'dump';

our $VERSION = '0.001';

#$\ = "\n";

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

	#$parser						= new dialect::Parser ({ info => $conf->{info} });
	$file						= new rise::file;
	$grammar					= new rise::grammar $conf;
	$syntax						= new rise::syntax $conf;
	
	#print ">>>>>>>>>>>>>> - ".dump($grammar)."\n";
	
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
	my ($this, $appname_dialect)				= __class_ref(@_);

	my $file_perl				= compile($appname_dialect);
	
	__message_box("run $appname_dialect ...");
	my $time_start_run = time;	

	eval { package main; require $file_perl->{fname}; };
	die $@ if ($@);

	my $time_end_run = time;
	my $time_run = $time_end_run - $time_start_run;
	
	__message_box("running time $time_run seconds ...");
	
}

sub compile {
	my ($this, $appname_dialect)				= __class_ref(@_);
	my $assembly = '';
	my $info;

	my $time_start_compile = time;

	#if (__truefile($appname_dialect)){
	#	__message_box("compilation $appname_dialect ...");
	#	$assembly = __assembly( $appname_dialect );
	#	$info = $assembly->{info};
	#	__message ("$info\n") if $info ;
	#}
	
	push @{&__syntax->{VAR}{app_stack}}, @$appname_dialect;
	
	foreach (@{&__syntax->{VAR}{app_stack}}) {
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

sub __assembly {
	my ($this, $appname_dialect) 				= __class_ref(@_);
	
	my $code_perl;
	my $code_dialect;
	my $info;
	
	my $fname_dialect			= $this->{sourse}{fpath} . $appname_dialect . $this->{sourse}{fext};
	my $fname_perl				= $this->{perl}{fpath} . $appname_dialect . $this->{perl}{fext};
	
	if (!$fname_perl){
		$fname_perl				= $fname_dialect;
		$fname_perl				=~ s/(\w+)\$conf->{sourse}{fext}/$1/sx;
		$fname_perl				= $fname_perl . $this->{perl}{fext};
	}
	
	$code_dialect				= __file('read', $fname_dialect);
	
	if ($code_dialect) {
		&__syntax->{RULE}		= $grammar->compile_RBNF(&__syntax->{RULE});
		($code_perl, $info)		= __parse($code_dialect, &__syntax);
		$code_perl .= "\n1;";
		__file('write', $fname_perl, $code_perl);
	}
	#print "$info";
	return {code => $code_perl, fname => $fname_perl, info => $info};
}

#sub __obj__		{ $parser }
sub __parse		{ $grammar->parse(@_) }
sub __syntax	{ $syntax->syntax(@_) }
sub __file		{ eval{$file->file(@_)} }

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
