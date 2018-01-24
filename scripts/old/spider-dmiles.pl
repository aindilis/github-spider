#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

use Net::GitHub::V3;

my $password = `cat /etc/myfrdcsa/config/cred/github.com`;
chomp $password;

my $gh = Net::GitHub::V3->new(login => 'aindilis', pass => $password);
my $repos = $gh->repos;

print Dumper([$repos->list_user('logicmoo')]);


