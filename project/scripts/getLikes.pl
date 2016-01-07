#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;
use List::Util qw(max);

$name = $ARGV[0];
$access_token = "CAACEdEose0cBAFySG8LDO3mMQHYvsJGf7uqZB0fZCVdFIBUKXXXrNhAE3cZB4aOXW8HBkJEXGgZCLZAqu8W0u0SZA1Q4vWXbNyC7tEz4JhLgpMe0023PUevNBKGUKadpLcKt4ARE3FD0PiUyZAIeQ20nQhKWrKcnB4H7VMWZCAnZBiAlMO38Q9Uo4RhAmGVFlgMHKL8wp3LOkFQVQ5gs6ZBRVp";

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