#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;
use List::Util qw(max);

$name = $ARGV[0];
$access_token = "CAACEdEose0cBAEnbk3ut3sJmu46UNSAtJbOyZCvqX89pOuL22pKGXkxgtsgYuB09XHpDJNp007cfc5EpZB2ChfVOmeNo7AUReA9t7sUVvl1WDlzDKhThZBIOeXoNjhiEIEVLD5TZCBi0F38MRMwCcTPhNGPy7Mw9tFqniRJZAxtqmRnufZCugT2J2gwILjAujlQZC2ZBqZB0yHgZDZD";

sub getLikes {
  ($id) = @_;
  $l_url = URI->new("https://graph.facebook.com/$id");

  $l_url->query_form(
    "access_token" => $access_token,,
    "fields" => "likes"
  );

  $res = decode_json get($l_url);
  return $res->{'likes'};
}

# Build URI
$url = URI->new('https://graph.facebook.com/search');
$url->query_form(
  "access_token" => $access_token,
  "q"  => $name,
  "type" => "page"
);

# Get search results
$html = get($url);
if (not defined $html) {
  print "Invalid access token.\n";
  exit;
}

$json = decode_json $html;
@data = @{$json->{'data'}};

@likes = ();
foreach $page (@data) {

  if ($page->{'name'} =~ /^$name$/) {
    $like = getLikes $page->{'id'};
    push @likes, $like;
  }
}
print max @likes;