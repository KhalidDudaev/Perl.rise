#!perl.exe -w
#!/usr/bin/env perl
use strict;
use warnings;

use Data::Dump 'dump';
use feature 'say';

use lib qw|
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/
    c:/_DATA_EXT/_data/works/Development/_PERL/_lib/librise/
    c:/_DATA_EXT/_data/works/development/_puma/export/
|;

use rise { debug    => 0, info    => 1 };

my $r               = new rise;

my $plist           = qr/^(?:debug|d|info|i)$/;
my %peqv            = (
    'd' => 'debug',
    'i' => 'info'
);
my ($source, $build) = argconf(@ARGV);

$r->compile($source, $build);

sub argconf {
    my @args = @_;
    my $cp;
    my $cmd;
    my $prm;
    my $basename;
    my $source;
    my $build;

    while (@args) {
        $cp = shift @args;
        ($source)   = $cp =~ m/^(.*?(?:[^\d\W]\w+\.)+puma$)/sx if !$source;
        ($build)    = $cp =~ m/^(.*?(?:[^\d\W]\w+\.)+pm)$/sx if !$build;

        if (($cmd, $prm) = $cp =~ m/^\-(.)(.+)/sx) {
            # $cp = undef;
            die "unknown argumnt '$cmd'" if $cmd !~ m/$plist/sx;
            die "unknown parameter '$prm'" if $prm !~ m/\d+/sx;
            $cmd =~ s/(\w+)/$peqv{$1}/sx;
            $r->{$cmd} = $prm;
        }
    }

    ($basename) = $source =~ m/(.*?)\.puma$/sx;
    $build      = $basename . '.pm' if !$build;

    die "missing source name" if !$source;

    return ($source, $build);
}

1;
