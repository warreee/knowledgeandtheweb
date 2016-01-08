#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;
use List::Util qw(max);

$name = $ARGV[0];
$access_token = "CAACEdEose0cBAJORSI7YcZBMjZB2roMjTVjDp6ixIDqqHXZBRsRmZCKZB1wenYvzi10Ibz0E9ZB5kSyNXSjDwKJHRFk7JHI4QKzpq4g4aZAvuHXAohgXWeggE32lFERraKjxV787iMSk2HdZCWlPtWR5aJZBvRZChbrKnCnjytF0NkbZCYlGvhfkgxWANKWJTkb3Qs5MDZBxC6jkjQZDZD";

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