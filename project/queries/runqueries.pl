#!/usr/bin/perl

$result = `rsparql --query=allnobelwinners.rq --service=http://data.nobelprize.org/sparql --results=csv >> test.csv`;

print $result;
