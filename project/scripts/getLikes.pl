#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;
use List::Util qw(max);

$name = $ARGV[0];
$access_token = "CAACEdEose0cBAD4PthZAsdoo7iwRYUErLyBXjNh8oxwT2RWWzfyZB13DpkPCju7kCw6ZCNbX3ZBqj404jZCSkOShmgOeL8pYYw7lQiS8l0gNQLm62QZCKZAicDp77jDhTvr6HYvgyQiktsftt2XXd4SDwJeZBbHrC2nxyoSXu0AQqNmYWHV9BhZCYnz7O0ckRBdd9LcLBM14pP2ZChLcZBpUn2f";

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