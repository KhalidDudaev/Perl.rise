package rise::lib::fileTask;
use strict;
use warnings;
use feature 'say';
use lib qw|
  c:/_DATA_EXT/_data/works/Development/_PERL/_lib/
  c:/_DATA_EXT/_data/works/Development/_PERL/_apps/_acs/
|;

use rise;
use rise::lib::fileMonitor;

my $r       = new rise ({
  debug  => 1,
  info  => 0,
});


my $acs = new rise::lib::fileMonitor;

my @export_list = qw/
  task
  start
  tall
/;

sub import { no strict 'refs';
	my $self	= caller(0);
	*{$self . "::$_"} = \&$_ for @export_list;
}

sub task {
  # say "#############################";
  my $tname       = shift;
  my $args        = shift;
  my $aref        = shift || \&task_action;
  # my $flist       = $args->[0];
  # my $dest        = $args->[1];
  # my $aref        = $args->[2] || \&task_action;
  $acs->MakeTask($tname, $args, $aref);
}

sub start {
  $acs->start;
}

sub task_action {
  my $fname = shift;
  $fname =~ s/\.(?:puma|class)$//sx;
  $r->compile($fname->[0],$fname->[1]);
}

sub tall {
  $acs->tasks;
}


1;
