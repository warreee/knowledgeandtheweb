#!/usr/bin/perl

use LWP::UserAgent::ProxyHopper;
use Data::Dumper;
use List::Util qw(shuffle);

$MAX = 100;
$PROXY = 0;
$TIMING = 1;

sub checkIfLive {
  ($p) = @_;
  $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  $ua->proxy('http', "$p");
  $ua->agent("Mozilla/5.0");
  $h = $ua->get('http://scholar.google.be/scholar?q=author%3A%22Andrew+Gwynne%22');
  if ($h->content() =~ /1 resultaat/) {
    # print $h->content();
    return 1;
  } else {
    return 0;
  }
}

open $file, '<', "../data/scholarrankings.csv";
open $prox, '<', "proxies.txt";

print ".-------------------------------------.\n";
print "| G7's Google Scholar Rank Downloader |\n";
print "'-------------------------------------'\n";

# Read all names
%rankings;
$toFind = 0;
while (<$file>) {
  chomp;
  @s = split ',', $_;
  if ($#s == 0) {
    $rankings{$s[0]} = "";
    $toFind++;
  } else {
    $rankings{$s[0]} = $s[1];
  }
}

print " -> Still need to scrape $toFind results.\n";

if ($MAX < $toFind) {
  print " -> Finding next $MAX.\n";
  $toFind = $MAX;
}
$neededProxies = int($toFind / 10);

if ($PROXY == 1) {
  print " -> Searching live proxies, we need about $neededProxies.\n";

  @iproxies;
  while (<$prox>) {
    chomp;
    push @iproxies, "http://$_";
  }
  $pua = LWP::UserAgent::ProxyHopper->new(
    agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
    timeout => 10
  );
  $pua->proxify_load(
          # extra_proxies   => \@iproxies,
          schemes         =>  'http'
  );
  $proxies = $pua->proxify_list;
  @proxies = shuffle @$proxies;

  @working;
  $c = 0;
  foreach (@proxies) {
    if (checkIfLive $_) {
      print "\t" . ($c + 1) . "/$neededProxies\t($_)\n";
      push @working, $_;
      $c++;
      if ($c== $neededProxies) {
        last;
      }
    }
  }

  print " -> Found $c working proxies.\n";
}

if ($TIMING) {
  print " -> Using randomized timing.\n";
}
print " -> Using cookies.\n";

foreach $k (keys %rankings) {

  if ($rankings{$k} != "") {
    next;
  }

  if ($PROXY == 1) {
    $proxy = $working[rand @working];
    $n = `perl getScholarRanking.pl \"$k\" $proxy`;
  } else {
    $n = `perl getScholarRanking.pl \"$k\"`;
  }
  # print "perl getScholarRanking.pl \"$k\" $proxy\n";
  if (defined $n) {
    $rankings{$k} = $n;
  }
  print "\t$k\t$n\n";

  $toFind--;
  if ($toFind == 0) {
    last;
  }

  if ($TIMING) {
    sleep (10 + int(rand(20)));
  }
}

close $file;

print " -> Done! Writing to file...\n";
open $file, '>', "../data/scholarrankings.csv";

foreach $k (sort keys %rankings) {
  print $file join(',', $k, $rankings{$k}) . "\n";
}

close $file;
