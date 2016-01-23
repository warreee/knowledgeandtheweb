#!/usr/bin/perl

use Data::Dumper;

$dFile = "mergedDBpediaNobelNewUni_economist_or_scientist_Final_PARSED.csv";
$uFile = "rankings_final.csv";
$lFile = "likes.csv";
$sFile = "scholarrankings.csv";
$oFile = "finalData.csv";

%data;              # Main data file
%rankings;          # University rankings
%likes;             # Likes
%scholar;           # Scholar rankings

# Header
@header = (
  "Nobel",
  "Country",
  "Year",
  "Type",
  "UniversityScore",
  "Productivity",
  "Popularity"
);

# READ EVERYTHING

# Read DBPedia file.
open $dbp, '<', "../data/$dFile";
while(<$dbp>) {
  chomp;
  ($name, $year, $country, $university, $type, $nobel) = split ";", $_;
  if (defined $data{$name}) {
    # Already exists, add university.
    push $data{$name}{'university'}, $university;
  } else {
    # Create new entry.
    $data{$name} = {
      year => $year,
      country => $country,
      university => [$university],
      type => $type,
      nobel => $nobel
    };
  }
}

# Read university scores
open $rf, '<', "../data/$uFile";
while(<$rf>) {
  chomp;
  @u = split /;/, $_;
  $rankings{$u[0]} = $u[1];
}

# Read likes
open $lf, '<', "../data/$lFile";
while(<$lf>) {
  chomp;
  @l = split /;/, $_;
  $likes{$l[0]} = $l[1];
}

# Read scholar rankings
open $sf, '<', "../data/$sFile";
while(<$sf>) {
  chomp;
  @s = split /,/, $_;
  $scholar{$s[0]} = $s[1];
}

# MERGE EVERYTHING

foreach $name (keys %data) {
  # Insert likes and publications
  $data{$name}{'likes'} = $likes{$name};
  $data{$name}{'scholar'} = $scholar{$name};
  # University matching
  $score = 0;
  $c = 0;
  foreach $uni (@{$data{$name}{'university'}}) {
    if ($rankings{$uni} != 0) {
      $score += $rankings{$uni};
      $c++;
    }
  }
  if ($score > 0) {
    $score = $score / $c;
  }
  $data{$name}{'score'} = $score;
}


open $out, '>', "../data/$oFile";
$h = join(";", @header);
print $out "$h\n";
foreach $name (keys %data) {
  @properties = (
    $data{$name}{'nobel'},
    $data{$name}{'country'},
    $data{$name}{'year'},
    $data{$name}{'type'},
    $data{$name}{'score'},
    $data{$name}{'scholar'},
    $data{$name}{'likes'}
  );
  $p = join(';', @properties);
  print $out "$p\n";
}
close $out;

# # Match universities
# @notFound = ();
# $found = 0;
# foreach $k (keys %data) {
#   $universities = $data{$k}{'university'};
#   foreach $u (@$universities) {
#     if (not defined $universityScores{$u}) {
#       if (not grep /^$u$/, @notFound) {
#         push @notFound, $u;
#       }
#     } else {
#       $found++;
#       last;
#     }
#   }
# }
#
# print " -> Found $found scientists with ranked university.\n";
# print " -> Didn't find " . ($#notFound + 1) . " universities.\n";
# print " -> Performing fuzzy search.\n";
#
# foreach $u (@notFound) {
#   $match = `perl getUniversityRanking.pl \"$u\"`;
#   print "\t$u -> $match\n";
# }
# print "$notFound[0]\n";
# print `perl getUniversityRanking.pl $notFound[0]`;
