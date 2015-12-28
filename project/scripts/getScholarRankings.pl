#!/usr/bin/perl

open $file, '<', "../data/names.csv";
open $out, '>', "../data/scholarrankings.csv";
open $prox, '<', "proxies3.txt";

@proxies;
while (<$prox>) {
  chomp;
  push @proxies, $_;
}


$i = 0;
while (<$file>) {
  chomp;
  $proxy = $proxies[rand @proxies];
  $n = `perl getScholarRanking.pl \"$_\" http://$proxy`;
  print $out "$n\n";
  print "$i\t$_\t$n\n";
  $i++;
}

close $out;
close $file;
