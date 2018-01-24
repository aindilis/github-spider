#!/usr/bin/perl -w

my $dat = `cat /var/lib/myfrdcsa/codebases/minor/github-spider/data-git/result-kbc.dat`;
eval $dat;
eval $dat;
my $data = $VAR1;

print scalar @$data;
print "\n";
