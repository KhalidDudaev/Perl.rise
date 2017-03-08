package rise::core::ops::extends2;
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

    $child_short = $child; $child_short =~ s/^main\:\://sx;

    my $child_self = bless {}, $child;
    my $err         = "ERROR EXTENDS: Recursive inheritance detected in class '$child_short'";

	foreach my $parent (@parents) {
        $parent_short = $parent; $parent_short =~ s/^main\:\://sx;
		$path		= $parent_short;
		$path		=~ s/\:\:/\//g;
        die $err if $child_short eq $parent_short;
		require $path.".pm" if !grep($parent->isa($parent), ($child, @parents));
	}

    { no strict 'refs'; push @{"$child\:\:ISA"}, @parents; };
}

1;
