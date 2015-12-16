#!/usr/bin/perl

open $file, '<', "../data/names.csv";
open $out, '>', "../data/scholarrankings.csv";

$i = 0;
while (<$file>) {
  chomp;
  $n = `perl getScholarRanking.pl "$_"`;
  print $out "$n\n";
  print "$i\t$_\t$n\n";
  $i++;
}

close $out;
close $file;
