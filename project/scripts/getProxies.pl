#!/usr/bin/perl
# from https://phl4nk.wordpress.com/2015/04/11/perl-proxy-scraper/
# fixed by KaW G7

use strict;
use warnings;
use WWW::Mechanize;
use Try::Tiny;

my $source_file = shift . ".txt";

open (INPUT_FILE, "<$source_file")  || die "Can't open $source_file: $!\n";

my $crawler = WWW::Mechanize->new();

while(<INPUT_FILE>) {
  chomp;
  try {
    $crawler->get($_);
    # hunt for IP:PORT combination
    my @ips = $crawler->text() =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d{1,5})/g;
    foreach (@ips){
      print "$_\n";
    }
  } catch {
    warn "[!] Error: $_ \n";
  }
}
