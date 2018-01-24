#!/usr/bin/perl -w

use BOSS::Config;
use MyFRDCSA qw(ConcatDir);
use PerlLib::SwissArmyKnife;

use Net::GitHub::V3;

$specification = q(
	-u <user>	User for to search git repos
	-t <topic>	Topic for to search git repos
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $password = `cat /etc/myfrdcsa/config/cred/github.com`;
chomp $password;

my $gh = Net::GitHub::V3->new(login => 'aindilis', pass => $password);

my $name;
my $fh;

my $repos;
my $user;
my $searchresultuser;
my @userrepos;

my $search;
my $topic;
my $searchresulttopic;
my @topicrepos;

if (exists $conf->{'-u'}) {
  $user = $conf->{'-u'};
  $repos = $gh->repos;
  $searchresultuser = $repos->list_user($user);
}
if (exists $conf->{'-t'}) {
  $topic = $conf->{'-t'};
  $search = $gh->search;
  $searchresulttopic = $search->repositories
    ({
      q => $topic,
      sort  => 'stars',
      order => 'desc',
      per_page => 1000,
     })->{items};
}


if (defined $user) {
  $name = $user;
  $name =~ s/\s+/-/sg;

  $fh = IO::File->new();
  if ($fh->open('>'.ConcatDir($datadir,"result-$name.dat"))) {
    print $fh Dumper($searchresultuser);
    $fh->close;
  }

  foreach my $entry (@$searchresultuser) {
    push @userrepos, $entry->{clone_url};
  }

  $fh = IO::File->new();
  if ($fh->open('>'.ConcatDir($datadir,"repos-$name.txt"))) {
    print $fh Dumper(\@userrepos);
    $fh->close;
  }

  DownloadRepos
    (
     Repos => \@userrepos,
     Dir => $name,
    );
}

if (defined $topic) {
  $name = $topic;
  $name =~ s/\s+/-/sg;

  $fh = IO::File->new();
  if ($fh->open('>'.ConcatDir($datadir,"result-$name.dat"))) {
    print $fh Dumper($searchresulttopic);
    $fh->close;
  }

  foreach my $entry (@$searchresulttopic) {
    push @topicrepos, $entry->{clone_url};
  }

  $fh = IO::File->new();
  if ($fh->open('>'.ConcatDir($datadir,"repos-$name.txt"))) {
    print $fh Dumper(\@topicrepos);
    $fh->close;
  }

  DownloadRepos
    (
     Repos => \@topicrepos,
     Dir => $name,
    );
}

sub DownloadRepos {
  my (%args) = @_;
  my @repos = @{$args{Repos}};

  my $dir = $args{Dir};
  my $gitrepodir = ConcatDir("/var/lib/myfrdcsa/codebases/minor/github-spider/data/searches",$dir);
  my $c = 'mkdir -p '.shell_quote($gitrepodir);
  print "$c\n";
  system $c;

  my $i = 0;
  foreach my $line (@repos) {
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
	my $command = 'cd '.shell_quote("$gitrepodir/$account").' && git pull';
      } else {
	my $command = 'cd '.shell_quote("$gitrepodir/$account").' && git clone '.shell_quote($line);
	print $command."\n";
	system $command;
      } 
    } else {
      print "NO! $line\n";
    }
  }
}
