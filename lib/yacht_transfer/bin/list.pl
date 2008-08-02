#!/usr/bin/perl -w

# this script creates the list of yachts/ids
use LWP::UserAgent;
use HTTP::Cookies;
my $ua = LWP::UserAgent->new; # web crawler
push @{ $ua->requests_redirectable }, 'POST';
my $cookie_jar = HTTP::Cookies->new(
                               	file => "cookies.txt",
	                        autosave => 1,);
$ua->cookie_jar($cookie_jar);

$SITE = $ARGV[0];
$SITE =~ tr/a-z/A-Z/;
$site = $SITE;
$site =~ tr/A-Z/a-z/;

$BASE = $ARGV[1];
for($site) {
	/yw/ && do {
		print_yw();
		exit;
	};	
	/yc/ && do {
		print_yc();
		exit;
	};
	/buc/ && do {
		print_buc();
		exit;
	};
	/.*/ && do {
		usage();
	};
}
sub usage {
    die "usage: ./list.pl [ <yw>, <yc>, or <buc>] [url_base_name]";
}

#sub start {
#	$input_file = $SITE . "HOME";
#	open(HOME, "< $input_file");
#	my $base = <HOME>;
#	my $start = <HOME>;
#	my $content = get_content ( $base, $start);
#}

sub print_yw {
	$URL = "http://$BASE.com/core/listing/cache/pl_search_results.jsp?ywo=$BASE&hosturl=$BASE&ps=50&type=&luom=126&page=broker&slim=broker&lineonly";
 	$response = $ua->get($URL);
	if(!$response->is_success) { die $response->status_line;}
	
	# follow link etc with HTML::LinkExtor ?
	#
	print $response->content;
}
sub print_cache {
	open(CACHE, "< yc_cache");
	while (<CACHE>) {
		print;
	}
	close(CACHE); exit;
}
sub print_yc {
	$X = 1;
	$URL = "http://www.$BASE.com/main.asp?-vessel_list.asp-&mode=1&PN=$X";
	$page = $ua->get($URL);
	$content = $page->content;	
	$content=~ s/\240//g;
	# test if we are allright on the get
	if($content =~ /Recordscount:([0-9]+)</) {
		  $records = $1;
	}
	else {
		die "Error: records count not found";
	}

	open(DUMP, "> yc_dump");
	print DUMP $content;
	close(DUMP);
	if(-e "yc_test_cache" && !(`diff yc_dump yc_test_cache`)) {
		`rm yc_dump`;
		print_cache();
	}
	`mv yc_dump yc_test_cache`;
	open(CACHE, "> yc_cache");
	print CACHE $content;
	
	# we have the first 10 yacht records downloaded
	$records-=10;
	$X++;
	$URL = "http://www.$BASE.com/main.asp?-vessel_list.asp-&mode=1&PN=$X";
	while ($records gt 0){
		$page = $ua->get($URL);
		$content = $page->content;
		$content=~s/\240//g;
		print CACHE $content;
		$records-=10;
		$X++;
		$URL =  "http://www.$BASE.com/main.asp?-vessel_list.asp-&mode=1&PN=$X";
	}
	close(CACHE);
	print_cache();
}

sub print_buc {
	$X=1;
	$URL = "http://$BASE.com/";
	$page = $ua->get($URL);
	$URL .= "featured.htm";
	$page = $ua->get($URL);
	$URL = "http://$BASE.com/webtools/featured.htm";
	$URL = "http://$BASE.com/bucwebtoolauth.htm?auth_code=jordanyacht&tool_id=2";
#	$URL = "http://webtools.bucnet.com/toolbldr/viewfeatured.cfm?theaction=reqpage&reqpageno=$X";
	$page = $ua->get($URL);
	$content = $page->content;
	die $content;
	$content =~ s/\240//g;
	if($content =~ />([2-9])</) {
		$pages = $1;
	}
	else {
		die $content;
	}
	print $content;
	$X++;
	$URL = "http://webtools.bucnet.com/toolbldr/viewfeatured.cfm?theaction=reqpage&reqpageno=$X";
	while ($X lt $pages) {
		$page = $ua->get($URL);
		$content = $page->content;
		$content =~ s/\240//g;
		print $content;
		$X++;
		$URL = "http://www.$BASE.com/main.asp?-vessel_list.asp-&mode=1&PN=$X";
	}
}

#sub get_content {
#	my $base = shift;
#	my $start = shift;
#	my $page = $ua->get($base . $start);
#	my $temp = $SITE ."LIST_TEMP";
#	open(TEMP, "> $temp");
#	print TEMP $page->content;
#	my $cache = $SITE . "CACHE";
#	my $has_changed = `diff $temp $cache`;
#	# set as up to date cache
#	if($has_changed) {
#		`cp $temp $cache`;
#	}
#	my $sed_file = $site . "2list.sed";
#	my $output = undef; 
#	while(1) {
#		my $content = $page->content;
#		my $data = `echo '$content' | sed -f $sed_file`;
#		my $output.= $data;
#		if($data =~ /NEXT~(.*)/ {
#			$page = $ua->get($base . $1);
#		}
#		else {
#			last;
#		}
#	}
#		
#	`rm $temp`;
#}	       
