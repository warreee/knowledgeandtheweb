#!/usr/bin/perl

use Text::PhraseDistance qw(pdistance);
use Text::Levenshtein qw(distance);

($university) = @ARGV;
if (not defined $university) {
	die "No university given\n";
}

# Read the ranking file
$rankingFile = "../data/rankings.csv";
if (not -e $rankingFile) {
  `perl getRankings.pl rankings`;
}
open $f, '<', $rankingFile;

# Parse university scores
%universityScores;
while(<$f>) {
	chomp;
  @u = split /;/, $_;
  $universityScores{$u[0]} = $u[1];
}

$set = "abcdefghijklmnopqrstuvwxyz";
$set .= uc $set;

%universityDistances;
foreach $u (keys %universityScores) {
  $universityDistances{$u} = pdistance($university, $u, $set, \&distance);
}

@sorted = sort { $universityDistances{$a} <=> $universityDistances{$b} }
				  keys %universityDistances;
print "$sorted[0] ($universityDistances{$sorted[0]})";
