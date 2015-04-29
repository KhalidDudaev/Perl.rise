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
our $conf						= __confs_load('common');

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

	%$conf						= ( %$ARGS, %$conf );
	__init();
	
	run ($ARGS->{run})			if $ARGS->{run};
	compile($ARGS->{compile})	if $ARGS->{compile};
	
	no strict 'refs';
	foreach (@EXPORT) {
		*{$this."::$_"} = *{$_};
	}
	
	return 1;
}

sub new {
    my ($param, $class, $this)	= ($conf, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$this						= (%$param, %$this);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $this                   	= bless($this, $class);                         # обьявляем класс и его свойства
	#__init();
	return $this;
}

sub __init {

	#$parser						= new dialect::Parser ({ info => $conf->{info} });
	$file						= new rise::file;
	$grammar					= new rise::grammar;
	$syntax						= new rise::syntax;
	
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
	
	__message("run $appname_dialect ...");
	my $time_start_run = time;	

	eval { package main; require $file_perl->{fname}; };
	die $@ if ($@);

	my $time_end_run = time;
	my $time_run = $time_end_run - $time_start_run;
	
	__message("running time $time_run seconds ...");
	
}

sub compile {
	my ($this, $appname_dialect)				= __class_ref(@_);
	my $assembly = '';
	my $info;

	my $time_start_compile = time;

	if (__truefile($appname_dialect)){
		__message("compilation $appname_dialect ...");
		$assembly = __assembly( $appname_dialect );
		$info = $assembly->{info};
		print "$info\n" if $info;
	}
	
	
	#print "#################################\n";
	
	foreach (@{&__syntax->{VAR}{app_stack}}) {
		if (__truefile($_)){
			
			__message("compilation $_ ...");
			$info = __assembly($_)->{info};
			print "$info\n" if $info;
		}
	}
	
	my $time_end_compile = time;
	my $time_compile = $time_end_compile - $time_start_compile;
	__message("compilation time $time_compile seconds ...");

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
		($code_perl, $info)		= __parse($code_dialect, &__syntax);
		$code_perl .= "\n1;";
		__file('write', $fname_perl, $code_perl);
	}
	#print "$info";
	return {code => $code_perl, fname => $fname_perl, info => $info};
}

#sub __obj__		{ $parser }
sub __parse		{ $grammar->parse(@_) }
sub __syntax	{ $syntax->syntax }
sub __file		{ eval{$file->file(@_)} }

sub __message {
	my $message = shift;
	#if ($conf->{info}) {
		print "\n\n*******************************************************************************\n";
		print "                         $message\n";
		print "*******************************************************************************\n";
	#}
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
