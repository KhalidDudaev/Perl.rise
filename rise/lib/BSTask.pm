package rise::lib::BSTask;
use strict;
use warnings;
use feature 'say';
use lib qw|
  c:/_DATA_EXT/_data/works/Development/_PERL/_lib/
  c:/_DATA_EXT/_data/works/Development/_PERL/_apps/_acs/
|;

use rise;
use rise::BSTask::FileMonitor;

my $r       = new rise ({
  debug  => 1,
  info  => 0,
});


my $acs = new rise::BSTask::FileMonitor;

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
  my $flist       = $args->{source};
  my $dest        = $args->{dest};
  my $aref        = $args->{action} || \&task_action;
  $acs->MakeTask($tname, $flist, $aref);
}

sub start {
  $acs->start;
}

sub task_action {
  my $fname = shift;
  $fname =~ s/\.(?:puma|class)$//sx;
  $r->compile([$fname]);
}

sub tall {
  $acs->tasks;
}


1;
