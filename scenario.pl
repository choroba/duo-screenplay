#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use File::Temp qw{ tempdir };
use Term::ANSIColor qw{ color };

my $repo   = '';
my $branch = 'b' . time;
my $ERROR  = '|| echo ERROR';

my @lines = split /\n/, << "__SCENARIO__";

# Comment
@ date > a
                        @ date > b
cat a
                        cat b
__SCENARIO__


my %dirs = ( A => tempdir( DIR => '/tmp'),
             B => tempdir( DIR => '/tmp'),
           );
my %color = ( A => 'green',
              B => 'cyan',
            );

system("rm -rf '$_'"), mkdir for values %dirs;

my $count;
for (@lines) {
    next unless /\S/;
    say(color('red'), "$1", color('reset')), next if /^\s*(#.*)/;

    my $who = s/^\s+// ? 'B': 'A';
    my $hidden = s/^@\s+//;
    unless ($hidden) {
        $count++;
        say "\n", color("bold $color{$who}"), "[$count] $_",
                  color('reset'), color($color{$who});
    }

    die "Error: $!\n" if system 'cd ' . $dirs{$who} . ';' . $_;

    sleep 1 unless $hidden;
}

say color('reset');

system "rm -rf '$_'" for values %dirs;

=head1 DESCRIPTION

=head1 AUTHOR


=cut
