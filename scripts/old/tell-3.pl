#!/usr/bin/perl -w

my $dat = `cat result-3.dat`;
eval $dat;
eval $dat;
my $data = $VAR1;

print scalar @$data;
print "\n";
