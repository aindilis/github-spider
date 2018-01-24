#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

my $gitrepodir = "/var/lib/myfrdcsa/capabilities/sentiment-analysis/git";

my $i = 0;
foreach my $line (split /\n/, `cat repos.txt`) {
  ++$i;
  print "Checking $i) <$line>\n";
  if ($line =~ /\/([^\/]+)\/([^\/]+)$/) {
    my $account = $1;
    my $reponame = $2;
    $reponame =~ s/\.git$//sg;
    print "\tHas $account : $reponame\n";
    if (! -d "$gitrepodir/$account") {
      my $command = 'mkdir '.shell_quote("$gitrepodir/$account");
      print $command."\n";
      system $command;
    }
    if (-d "$gitrepodir/$account/$reponame") { 
      print "Already got: $account : $reponame\n";
    } else {
      my $command = 'cd '.shell_quote("$gitrepodir/$account").' && git clone '.shell_quote($line);
      print $command."\n";
      system $command;
    } 
  } else {
    die "WTH! $line\n";
  }
}
