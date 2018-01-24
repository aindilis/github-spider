#!/usr/bin/perl -w

use WWW::Mechanize;

my $searchstring = "sentiment analysis";
$searchstring =~ s/^\s*//sg;
$searchstring =~ s/\s*$//sg;
my $search = join('+',(split /\s+/, $searchstring));

my $url = "https://github.com/search?p=5&q=$search&type=Repositories&utf8=%E2%9C%93";

print $url;

