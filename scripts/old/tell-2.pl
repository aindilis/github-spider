#!/usr/bin/perl -w

my $dat = `cat result-2.dat`;
eval $dat;
eval $dat;
my $data = $VAR1;

print scalar @$data;
print "\n";
