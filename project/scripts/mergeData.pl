#!/usr/bin/perl

use Data::Dumper;

# Read DBPedia file.
open $dbp, '<', '../data/DBPedia.csv';
%data;
while(<$dbp>) {
  chomp;
  ($name, $year, $country, $university) = split ";", $_;
  if (defined $data{$name}) {
    # Already exists, add university.
    push $data{$name}{'university'}, $university;
  } else {
    # Create new entry.
    $data{$name} = {
      year => $year,
      country => $country,
      university => [$university]
    };
  }
}

# Read university scores
$rankingFile = "../data/rankings.csv";
if (not -e $rankingFile) {
  `perl getRankings.pl rankings`;
}
open $f, '<', $rankingFile;
%universityScores;
while(<$f>) {
  chomp;
  @u = split /;/, $_;
  $universityScores{$u[0]} = $u[1];
}

@notFound = ();
$found = 0;
foreach $k (keys %data) {
  $universities = $data{$k}{'university'};
  foreach $u (@$universities) {
    if (not defined $universityScores{$u}) {
      if (not grep /^$u$/, @notFound) {
        push @notFound, $u;
      }
    } else {
      $found++;
      last;
    }
  }
}

print " -> Found $found scientists with ranked university.\n";
print " -> Didn't find " . ($#notFound + 1) . " universities.\n";
print " -> Performing fuzzy search.\n";
# 
# foreach $u (@notFound) {
#   $match = `perl getUniversityRanking.pl \"$u\"`;
#   print "\t$u -> $match\n";
# }
# print "$notFound[0]\n";
# print `perl getUniversityRanking.pl $notFound[0]`;
