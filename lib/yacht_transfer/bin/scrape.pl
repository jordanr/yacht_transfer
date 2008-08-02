#!/usr/bin/perl -w

# This script prints all the html content related 
# to a yacht listing on the given website.  
use LWP::UserAgent;
my $ua = LWP::UserAgent->new; # web crawler

#usage
if(($#ARGV +1)!= 3){
	die "usage: ./scrape.pl <yw or yc> <id> <url basename>";
}

my $SITE = $ARGV[0]; # the listing site
my $ID = $ARGV[1]; # the yacht id
my $BASE = $ARGV[2]; # the brokerage's base name, ex. use jordanyachts for www.jordanyachts.com

# switch statement to scrape given website
for($SITE) {
	/yw/ && do{scrape_yw();exit;};
	/yc/ && do{scrape_yc();exit;};
	/.*/ && do{die "Unsupported website";};
}

# pre : The passed yacht id exists on yachtworld.
# post: Prints out the html content on the yacht.
sub scrape_yw {
	print STDERR "Scraping yachtworld";

	$YW_DISPLAY_AD_URL = "http://yachtworld.com/core/listing/boatDetails.jsp?boat_id=$ID&checked_boats=$ID";
	$YW_FULL_SPECS_URL = "http://yachtworld.com/core/listing/boatFullDetails.jsp?boat_id=$ID";

	print "*DISPLAY AD*\n";
	print_html($YW_DISPLAY_AD_URL);
	print "\n*FULL SPECS*\n";
	print_html($YW_FULL_SPECS_URL);
	
	print STDERR ".done\n";
}

# pre : The passed yacht id exists on yachtcouncil.
# post: Prints out the html content on the yacht.
sub scrape_yc {
	print STDERR "Scraping yachtcouncil";
	$YC_BASIC_DATA_URL = "http://$BASE.com/main.asp?-vessel_basic_info.asp-&vessels_id=$ID";
	$YC_DETAILS_URL = "http://$BASE.com/main.asp?-vessel_detail.asp-&vessel_id=$ID";

	print "*BASIC INFO*\n";
	print_html($YC_BASIC_DATA_URL);
	print "\n*DETAILS*\n";
	print_html($YC_DETAILS_URL);
	print STDERR ".done\n";
}


# pre : Takes one string, the url to get and print.
#	Dies if the website cannot be found.
# post: Prints the html content.
sub print_html {
	print STDERR ".";
	my $url = shift;
	my $response = $ua->get($url);
	if ($response->is_success) {
     		print $response->content;
 	}
 	else {
     		die $response->status_line;
 	}
}
