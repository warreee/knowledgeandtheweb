#!/usr/bin/perl

use LWP::Simple;
use URI;
use JSON;
use Data::Dumper;
use List::Util qw(max);

$name = $ARGV[0];
$access_token = "CAACEdEose0cBALUtd3RWhT61HfTF2YRLkvMoUSNGpaGwSZAiAyCs887DauHCN5YMkC7EuOYjUu6E8Ssi5FAZBCevHD4CAH5okwGdGxiOPOCG2k63osgOZCZCHcivBeDhTLC18QrNyfaOdaLK2wLZCzZB4PhHrZATg4LNXQhgdMZAE7TknPb4pzhjKLgXmtwPa0NZCeBMvZAmwmxEiN7Q3efbwS";

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
