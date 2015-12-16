  #!/usr/bin/perl

use LWP::UserAgent;
use URI;

($name) = @ARGV;
if (not defined $name) {
  die "No name given\n";
}

# Build URI
$url = URI->new('http://scholar.google.be/scholar');
$url->query_form(
  "hl" => "nl",
  "q"  => "author:$name"
);

# Initialize user agent
$ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36");

# Get content and parse number of results
$html = $ua->get($url);
$html->content() =~ /Ongeveer\s(.+?)\sresultaten/;

print $1;
