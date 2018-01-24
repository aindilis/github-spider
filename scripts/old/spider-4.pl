#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

use Net::GitHub::V3;

my $password = `cat /etc/myfrdcsa/config/cred/github.com`;
chomp $password;

my $gh = Net::GitHub::V3->new(login => 'aindilis', pass => $password);
my $search = $gh->search;

my %data = $search->repositories
  ({
    q => 'sentiment analysis',
    sort  => 'stars',
    order => 'desc',
    per_page => 1000,
   });
print Dumper(\$data{items});
