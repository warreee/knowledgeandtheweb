  #!/usr/bin/perl

use LWP::UserAgent;
use URI;

($name, $proxy) = @ARGV;
if (not defined $name) {
  die "No name given\n";
}

# print "$proxy\t";

# Build URI
$url = URI->new('http://scholar.google.be/scholar');
$url->query_form(
  "hl" => "nl",
  "q"  => "author:$name"
);

# Initialize user agent
$ua = LWP::UserAgent->new;
$ua->timeout(10);
if (defined $proxy) {
  $ua->proxy('http', $proxy);
}
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36");


# Get content and parse number of results
$html = $ua->get($url);
print $html->content();
$html->content() =~ /Ongeveer\s(.+?)\sresultaten/;

# print $1;
