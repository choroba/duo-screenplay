#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use File::Temp      qw{ tempdir };
use Term::ANSIColor qw{ color };


my %template = (
                repo  => tempdir(),
                ERROR => '|| echo ERROR',
               );

my %dirs = ( A => tempdir(),
             B => tempdir(),
           );

sub cleanup {
    system "rm -rf '$_'" for $template{repo}, values %dirs;
};

local $SIG{__DIE__} = sub { cleanup() };

my %color = ( A => 'green',
              B => 'cyan',
            );

my $count;
while (<>) {
    next unless /\S/;
    print(color('red'), "\n$1", color('reset')), next if /^\s*(#.*)/;

    s/%([[:alnum:]]+)/$template{$1}/g;

    my $who = s/^\s+// ? 'B': 'A';
    my $hidden = s/^@\s+//;
    unless ($hidden) {
        $count++;
        say "\n", color("bold $color{$who}"), "[$count] $_",
                  color('reset'), color($color{$who});
    }

    die "Error: $?\n" if system 'cd ' . $dirs{$who} . ';' . $_;

    sleep 1 unless $hidden;
}

say color('reset');
cleanup();

=head1 DESCRIPTION

Simulate two users working in a shell simultaneously.

=head1 AUTHOR

(c) E. Choroba 2014

=cut
