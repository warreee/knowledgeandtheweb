#!/usr/bin/perl

use LWP::Simple qw(get);

($out) = @ARGV;
if (not defined $out) {
	$out = "../data/rankings.csv";
} else {
	$out = "../data/$out.csv";
}

$html = get "http://www.shanghairanking.com/ARWU2015.html";

# Parse table
$th = 'name="UniversityRanking">';
$tf = '<\/table>';
$html =~ /$th(.+)$tf/s;
$table = $1;

# Parse rows
@rows = $table =~  /class="bgf[5d]">(.*?)<tr/g;

open $f, '>', $out;
foreach $r (@rows) {

	# Parse cells
	@cells = $r =~ /<td.*?>(.*?)<\/td>/g;

	# Get university name
	$cells[1] =~ /<a.*?>(.*?)<\/a>/;
	$name = $1;
	$name =~ s/\s*\(.+\)//g;

	# Get award score
	$cells[6] =~ /<div>(.*?)\s<\/div>/;
	$score = $1;

	# Write to file
	print $f "$name;$score\n";

}
close $f;
