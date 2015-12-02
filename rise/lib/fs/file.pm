package rise::lib::fs::file;

use strict;
use warnings;

# use Cwd 'abs_path';
use FileHandle;

my $cenv   					= {};
my $fh 						= new FileHandle;
my $command 				=	{
	'read'					=> '<',
	'write'					=> '>',
	'append'				=> '>>'
};



#file('asdasd')->write($data);
#file('asdasd')->read;
#file('asdasd')->append($data);

sub new {
    my ($param, $class, $self)	= ($cenv, ref $_[0] || $_[0], $_[1] || {});    	# получаем имя класса, если передана ссылка то извлекаем имя класса,  получаем параметры, если параметров нет то присваиваем пустой анонимный хеш
	%$self						= (%$param, %$self);							# применяем умолчания, если имеются входные данные то сохраняем их в умолчаниях
    $self                   	= bless($self, $class);                         # обьявляем класс и его свойства
    return $self;
}

sub file {
	my $self					= shift;
    my ($cmd, $fname, $data)	= @_;
	my($path_current)			= $0 =~ m/^(.*?)\w+(?:\.\w+)*$/sx;

	$fname = $path_current . $fname if $fname !~ m/^(?:\w+\:|[\W]+)/gsx;

	# print "$path_current\n";

	$data = join('',<$data>) if ref $data eq 'Fh';

    $fh->open($command->{$cmd}.$fname) || die "cannot open $fname";
	# $fh->open($command->{$cmd}.$fname) || die _error ($fname)
    $fh->binmode();

	return _action()->{$cmd}->($data);
}

sub _error {
	my $fname = shift;
	my $file = $fname;
	$file =~ s/\//::/gsx;
	$file =~ s/\.\w+//gsx;
	no strict 'refs';
	#print "################ $file ################\n";
	#return 1 if %{$file.'::'};
	return '' if !%{$file.'::'};
}

sub read {
	my $self			= shift;
	my $file			= shift;
	$self->file('read', $file)
}

sub write {
	my $self			= shift;
	my $file			= shift;
	my $data			= shift;
	$self->file('write', $file, $data)
}

sub append {
	my $self			= shift;
	my $file			= shift;
	my $data			= shift;
	$self->file('append', $file, $data)
}

sub _action {{
	'read'		=> sub { my $data = join('', $fh->getlines());	$fh->close; return $data; },
	'write'		=> sub { my $data = $fh->write(shift);			$fh->close; return $data; },
	'append'	=> sub { my $data = $fh->write(shift);			$fh->close; return $data; }
}}

1;
