package rise::core::ops::extends;
use strict;
use vars qw($VERSION);

$VERSION = '0.001';

my $ERROR_MESSAGES		= '';

sub import {
	no strict;
    my $class		= shift;
    my $child		= caller(0);
	my @parents		= @_;
	my $path;
    my $parent_short;
    my $child_short;

    $child = 'main::'.$child if $child !~ m/^main\:\:.*?$/sx;
    ($child_short) = $child =~ m/^main\:\:(.*?)$/sx;

    my $child_self = bless {}, $child;

    my $err         = "ERROR EXTENDS: Recursive inheritance detected in class '$child_short'";

    # print "### child -> $child_self \n";

	foreach my $parent (@parents) {
        $parent = 'main::'.$parent if $parent !~ m/^main\:\:.*?$/sx;
        ($parent_short) = $parent =~ m/^main\:\:(.*?)$/sx;
        my $parent_self = bless {}, $parent;
        # print $parent . "\n";
		$path		= $parent_short;
		$path		=~ s/\:\:/\//g;
		# warn "Class '$child' tried to inherit from itself\n" if $child eq $parent;

        die $err if $child_short eq $parent_short;
		# require $path.".pm" if !grep($parent->isa($parent), ($child, @parents));
		# require $path.".pm" if !$parent->isa($parent);
        require $path.".pm";

        # { no strict 'refs'; *{$parent.'::__CLASS_SELF__'} = $self; }
        # $parent_self->new if exists &{$parent_short.'::__CLASS_CODE__'};
        $parent_self->__CLASS_CODE__ if exists &{$parent.'::__CLASS_CODE__'};
        # &{$parent.'::__CLASS_CODE__'}($child_self); # if exists &{$parent.'::__CLASS_CODE__'};

        # &{$parent.'::__CLASS_CODE__'}($self);

		#interface_join($parent, $child) if (exists &{$parent.'::obj_type'} && ($parent->obj_type eq 'ABSTRACT' || $parent->obj_type eq 'INTERFACE'));

		#print ">>>>>>>>>> $parent <<<<<<<<<<\n";

		#$parent->interface_join($child) if exists &{$parent.'::interface_join'};

	}

	#$class->interface_confirm if exists &{$class.'::interface_confirm'};

    { no strict 'refs'; push @{"$child\:\:ISA"}, @parents; };
}

#sub interface_join {
#	no strict 'refs';
#	no warnings;
#
#	my $interface 		= shift;
#	my $class			= shift;
#
#	%{$class.'::IMPORT_INTERFACELIST'} = (%{$class.'::IMPORT_INTERFACELIST'}, %{$interface.'::IMPORT_INTERFACELIST'});
#
#	#print dump (\%{$class.'::IMPORT_INTERFACELIST'}), "\n";
#	#print "### - " . dump (\%{$interface.'::IMPORT_INTERFACELIST'}) . "\n";
#}

1;
