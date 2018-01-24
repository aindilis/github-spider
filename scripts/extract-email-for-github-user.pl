#!/usr/bin/perl -w

# https://www.eremedia.com/sourcecon/how-to-find-almost-any-github-users-email-address/

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use Regexp::Common qw[Email::Address];
use Email::Address;

$specification = q(
	-u <username>		Username to retrieve email for
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-u'}) {
  die "need username\n";
}


use WWW::Mechanize;

$mech = WWW::Mechanize->new();

my $username = $conf->{'-u'};
my $url = "https://api.github.com/users/$username/events/public";
$mech->get($url);

my $text = $mech->content($url);
foreach $line (split /\n/, $text) {
  $line =~ s/\s+/ /sg;
  print "<$line>\n" if $verbose;
  my (@found) = $line =~ /($RE{Email}{Address})/g;
  my (@addrs) = map $_->address,
    Email::Address->parse("@found");
  foreach my $addr (@addrs) {
    $emails->{$addr} = 1;
  }
}

my $res = [sort keys %$emails];
if (exists $conf->{'--emacs'}) {
  print "'".PerlDataStructureToStringEmacs
    (
     DataStructure => $res,
    );
} else {
  # if ($conf->{'-c'}) {
  #   print "# $item\n";
  # }
  if (exists $conf->{'-f'}) {
    print join("\n",@$res)."\n";
  } else {
    print Dumper($res);
  }
}

