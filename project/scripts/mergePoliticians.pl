#!/usr/bin/perl

use Data::Dumper;

open $toe, '<', "../data/TOEPoliticians_testData.csv";
%toe;
while(<$toe>) {
  chomp;
  ($name, $year, $county, $university, $speeches) = split ";", $_;
  if (defined $toe{$name}) {
    push $toe{$name}{'universities'}, $university;
  } else {
    $toe{$name} = {
      year => $year,
      universities => [$university],
      speeches => $speeches
    };
  }
}

# Read university scores
open $rf, '<', "../data/rankings_final.csv";
%rankings;
while(<$rf>) {
  chomp;
  @u = split /;/, $_;
  $rankings{$u[0]} = $u[1];
}

for $name (keys %toe) {
  # Get likes
  $likes = `perl getLikes.pl \"$name\"`;
  if ($likes =~ /\d*/) {
    $toe{$name}{'likes'} = $likes;
  }
  $score = 0;
  $c = 0;
  foreach $uni (@{$toe{$name}{'universities'}}) {
    if ($rankings{$uni} > 0) {
      $score += $rankings{$uni};
      $c++;
    }
  }
  if ($score > 0) {
    $score = $score / $c;
  }
  $toe{$name}{'score'} = $score;
  print "$name \t $likes\n";
}


open $out, '>', "../data/finalPoliticians.csv";
$h = join(";", ('Name', 'Year', 'UniversityScore', 'Productivity', 'Popularity'));
print $out "$h\n";
foreach $name (keys %toe) {
  @properties = (
    $name,
    $toe{$name}{'year'},
    $toe{$name}{'score'},
    $toe{$name}{'speeches'},
    $toe{$name}{'likes'}
  );
  $p = join(';', @properties);
  print $out "$p\n";
}
close $out;
