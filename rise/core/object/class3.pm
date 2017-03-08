package rise::core::object::class3;
use strict;
use warnings;
use utf8;
use	rise::core::object::class::helper3;
# use	parent 'rise::core::object::class::ext';
use rise::core::ops::commands;
use feature 'say';
#use Data::Dump 'dump';

#use autobox::Core;

our $VERSION 	= '0.01';

my $ENV_CLASS		= {
	this_class		=> __PACKAGE__,
	caller_class	=> 'CALLER',
	caller_code		=> 'CODE',
	caller_data		=> 'DATA'
};

sub import { no strict "refs";

	# strict		->import;
	# warnings	->import;

	my $caller              = caller(0);
	my $self                = shift;
	my ($parent)			= $caller =~ /(?:(\w+(?:::\w+)*)::)?(\w+)$/;

    $parent                 ||= 'main';

    # print "### $caller - $parent - $self ###\n";

    ############################################## IMPORT MEMBERS ####################################
    foreach my $member (keys %{$parent . "::IMPORT::"}){
        *{$caller.'::'.$member}               = \&{$parent.'::IMPORT::'.$member};
        *{$caller.'::IMPORT::'.$member}       = \&{$parent.'::IMPORT::'.$member};
    }
    ##################################################################################################

    push (@{$caller.'::ISA'}, ($parent, 'rise::core::object::class::helper3'));
	# push @{$caller.'::ISA'}, $parent if $parent;
	# push @{$caller.'::ISA'}, 'rise::core::object::class::ext';
    { no warnings;
    	*{$caller."::super"}	= sub {${$caller.'::ISA'}[2]};
    	*{$caller."::self"}		= sub {$caller};
    }
	$caller->strict::import;
	$caller->warnings::import;
	$caller->utf8::import;
    # $caller->import;
	$caller->rise::core::ops::commands::init;
}

# sub DESTROY {
#     print "\n### DESTROY ###\n";
# }
#
# END {
#     print "\n### END ###\n";
# }

1;
