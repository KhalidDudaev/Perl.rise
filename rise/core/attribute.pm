package rise::core::attribute;
 
use 5.006;
use strict;
use warnings;
 
our $VERSION = '0.03';
 
use Attribute::Handlers;

#use Sub::Name;

use parent 'rise::object::error';

use Data::Dump 'dump';

my $last_smbl;
my $last_name;

sub UNIVERSAL::PRIVATE_VAR : ATTR(CODE) { #no strict 'refs';
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
	
	#$symbol				= $data->[0] if $symbol eq 'ANON';
	
    my $name			= *{$symbol}{NAME};
	#my ($class_name, $var_name)	= $package =~ /(?:(.*?)::)?(\w+)$/;
	my $class			= $package;
	($class)			= $package =~ /^(.*?)(?:::local)?$/;
	my $r				= qr/^$package.*/o;
	
	print "\n------------VAR---------------
	pkg:\t$class
	smbl:\t$symbol
	name:\t$name
	ref:\t$referent
	attr:\t$attr
	data:\t".($data->[0]||'')."
	phase:\t$phase
------------------------------\n";	
	no strict 'refs';
    no warnings;
    *{$symbol} = sub ():lvalue {
	#*{$package.'::'.$name} = sub ():lvalue {
		
		
		#my ($caller, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require) = caller(0);
		#print "### PRIVATE_VAR ###
		#pkg: $caller
		#sub: $subroutine
		#arg: $hasargs
		#wnt: $wantarray
		#evl: $evaltext
		#rqr: $is_require
		#sbl: $symbol
		#nme: $name
		################\n";
		
        #unless (caller eq $package)
#		unless (caller eq $package || caller =~ m/$r/o)
#		{
#            require Carp;
#            Carp::croak "FN() is a private method of $package!";
#        }
		
		#__PACKAGE__->__error('PRIVATE_VAR', $package, $name, caller) unless (caller eq $package || caller =~ m/$r/o);
		__PACKAGE__->__error('PRIVATE', $package, $name, caller) unless (caller eq $package || caller =~ m/$r/o);
		
        goto &$referent;
    };
}

sub UNIVERSAL::PROTECTED_VAR : ATTR(CODE) {
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
    my $name = *{$symbol}{NAME};
	
	print ">>> pkg: $package
	smbl:\t$symbol
	name:\t$name
	ref:\t$referent
	attr:\t$attr
	data:\t".($data||'')."
	phase:\t$phase \n";
	
	no strict 'refs';
    no warnings;
    *{$symbol} = sub {
        unless (caller->isa($package)) {
            require Carp;
            Carp::croak "$name() is a protected method of $package!";
        }
        goto &$referent;
    };
}
 
sub UNIVERSAL::PUBLIC_VAR : ATTR(CODE) {
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
    # just a mark, do nothing
}

sub UNIVERSAL::PRIVATE_CODE : ATTR(CODE) {
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
	my $name					= *{$symbol}{NAME};
	my ($class_name, $var_name)	= $package =~ /(?:(.*?)::)?(\w+)$/;
	my $r						= qr/^$class_name\b/o;
#	print "\n------------------------------
#	pkg:\t$package
#	smbl:\t$symbol
#	name:\t$name
#	ref:\t$referent
#	attr:\t$attr
#	data:\t".(dump($data)||'')."
#	phase:\t$phase
#------------------------------\n";
	
	
	no strict 'refs';
    no warnings;
    *{$package} = sub ():lvalue {
	#*{$package} = sub ():lvalue {	
		#my ($caller, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require) = caller(0);
		#
		#print "### PRIVATE_VAR ###
		#pkg: $caller
		#sub: $subroutine
		#arg: $hasargs
		#wnt: $wantarray
		#evl: $evaltext
		#rqr: $is_require
		################\n";
		

		unless (caller eq $class_name || caller =~ m/$r/o)
		{
            #require Carp;
            #Carp::croak "$var_name() is a private method of $class_name!";
			__PACKAGE__->__error('PRIVATE', $class_name, $var_name, caller)
        }
		
		#__PACKAGE__->__error('PRIVATE', $class_name, $var_name, caller) unless (caller eq $class_name || caller =~ m/$r/o);
		
        goto &$referent;
    };
}

sub UNIVERSAL::PROTECTED_CODE : ATTR(CODE) { 
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
    my $name					= *{$symbol}{NAME};
	my ($class_name, $var_name)	= $package =~ /(?:(.*?)::)?(\w+)$/;
	
	no strict 'refs';
    no warnings;
    *{$package} = sub :lvalue {
        unless (caller->isa($class_name)) {
            #require Carp;
            #Carp::croak "$name() is a protected method of $package!";
			__PACKAGE__->__error('PROTECTED', $class_name, $var_name, caller)
        }
        goto &$referent;
    };
}
 
 
sub UNIVERSAL::PUBLIC_CODE : ATTR(CODE) {
    my($package, $symbol, $referent, $attr, $data, $phase) = @_;
    # just a mark, do nothing
}
 
1;
__END__