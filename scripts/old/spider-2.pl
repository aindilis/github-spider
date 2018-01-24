#!/usr/bin/perl -w

use Net::GitHub::V1::Search;

my $search = Net::GitHub::V1::Search->new();
my $result = $search->search('sentiment analysis');
foreach my $repos ( @{ $result->{repositories} } ) {
  print "$repos->{description}\n";
}
