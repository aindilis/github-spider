#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

my $gitrepodir = "/var/lib/myfrdcsa/capabilities/sentiment-analysis/conferences/git";

my $i = 0;
foreach my $line (split /\n/, `cat /var/lib/myfrdcsa/codebases/minor/github-spider/data-git/repos-conferences-2.txt`) {
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
    print "NO! $line\n";
  }
}
