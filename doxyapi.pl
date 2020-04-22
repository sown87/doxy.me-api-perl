use strict;
use warnings;
use 5.10.0;
use Mojo::UserAgent;
use Data::Dumper;

#Some variable declaration
my $urlsession = "https://api.doxy.me/api/sessions/exportClinic";
my $urllogin = "https://api.doxy.me/api/users/login";
my ($name, $pw);
my $ua = Mojo::UserAgent->new;
$ua = $ua->inactivity_timeout(30);

#Interactive Input for email address and password
print "Enter your login name: ";
$name = <STDIN>;
chomp $name;
print "Enter your password: ";
$pw = <STDIN>;
chomp $pw;
my $q = {
    "email" => $name,
    "password" => $pw,
};

#Get token for API credential
my $l = $ua->post( $urllogin => { 'Content-Type' => 'application/x-www-form-urlencoded' } => form => $q)->res->json;
my $token = $l->{'id'};
#say "Token is $token";

#Use token for API request for clinic info
my $ua2 = Mojo::UserAgent->new;
$ua2->on(start => sub {
    my ($ua, $tx) = @_;
    $tx->req->headers->authorization($token);
});
my $s = $ua2->get( $urlsession => { 'Content-Type' => 'application/json', "Accept" => "application/json, text/plain, */*" } )->res->json;

#Print out array of hashes
say Dumper($s);
