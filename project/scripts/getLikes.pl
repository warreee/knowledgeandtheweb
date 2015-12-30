#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;

sub getLikes {
  ($id) = @_;
  $l_url = URI->new("https://graph.facebook.com/$id");
  $l_url->query_form(
    "access_token" => "CAACEdEose0cBAF7NlLzlnEMbGhw4bs4ejY1nSDRARxslWvpiuj62bNZCOpa55orMDOdAvVXGsGGO5A1kTuAzC8Rcgf4iiaCLagcCpLlgrShJQRvvASPhV8O8TnP01VLVjNIFQPfLpes8NWYQOCZB93XhZBHdPyrxLvIZBeMZAI9BbCrvOIln3YZAYiSopYzcXNTpfwZB3yXZBgZDZD",,
    "fields" => "likes"
  );
  $res = decode_json get($l_url);
  return $res->{'likes'};
}

# Build URI
$url = URI->new('https://graph.facebook.com/search');
$url->query_form(
  "access_token" => "CAACEdEose0cBAF7NlLzlnEMbGhw4bs4ejY1nSDRARxslWvpiuj62bNZCOpa55orMDOdAvVXGsGGO5A1kTuAzC8Rcgf4iiaCLagcCpLlgrShJQRvvASPhV8O8TnP01VLVjNIFQPfLpes8NWYQOCZB93XhZBHdPyrxLvIZBeMZAI9BbCrvOIln3YZAYiSopYzcXNTpfwZB3yXZBgZDZD",
  "q"  => "Bart de Wever",
  "type" => "page"
);

# Get search results
$html = get($url);
$json = decode_json $html;
@data = @{$json->{'data'}};

foreach $page (@data) {
  print "$page->{'name'}";
  print getLikes $page->{'id'};
  print "\n";
}
