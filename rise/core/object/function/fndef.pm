package rise::core::object::function::fndef;
use strict;
use vars qw($VERSION);
$VERSION = '0.001';

sub import {
    my $class		= shift;
    my $child		= caller(0);
	my ($func_obj)		= @_;
	my ($func_name)		= $func_obj =~ m/::\w+$/;

	$func_name ||= $func_obj;

	{ no strict; *{$child."::".$func_name} = \&{$func_obj."::code"}; }
}
1;
