#!/usr/bin/perl -w

my $dat = `cat /var/lib/myfrdcsa/codebases/minor/github-spider/data-git/result-dmiles.dat`;
eval $dat;
eval $dat;
my $data = $VAR1;

foreach my $entry (@$data) {
  print $entry->{clone_url}."\n";
}
