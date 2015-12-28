  #!/usr/bin/perl

use LWP::UserAgent;
use HTTP::Cookies::Netscape;
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
  "q"  => "author:\"$name\""
);

# Initialize cookie jar
$cookiejar = HTTP::Cookies::Netscape->new(
  file => 'cookies.dat',
  # autosave => 1
);

# Initialize user agent and co
$ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->cookie_jar($cookiejar);
if (defined $proxy) {
  $ua->proxy('http', $proxy);
}
$ua->agent("Mozilla/5.0");

# Get content and parse number of results
$html = $ua->get($url);

if ($html->content() =~ /geen artikelen/) {
  print "0";
} elsif ($html->content() =~ /1 resultaat/) {
  print "1";
} else {
  $html->content() =~ /(\d+\.?\d*\.?\d*)\sresultaten/;
  if (not defined $1) {
    print "";
  #   # print $html->content();
  } else {
    print $1;
  }
}
