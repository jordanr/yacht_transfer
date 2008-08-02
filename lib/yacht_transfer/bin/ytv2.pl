#!/usr/bin/perl -w

use CGI qw(:standard);

print header;

# get user information such as usernames
# passwords, and base urls for websites
$login_name = remote_user();
open(USER_INFO, "< $login_name");
%user_info = ();
while(<USER_INFO>) {
    my @line = split(":",$_);
    chomp(@line);
    $user_info{$line[0]} = $line[1];
}

if(param()) {
    $id;
    my $site;
    if(param('submit') eq "Transfer YW2YC") {
	$id = param('yw_id');
	$from = 'yw';
	$to = 'yc';
    }
    if(param('submit') eq "Transfer YC2YW") {
	$id = param('yc_id');
	$from = 'yc';
	$to = 'yw';
    }
    chomp($id);
    if(ok()) {
	$base = $user_info{$from . "_base"};
	$data = `./scrape.pl $from $id $base`;
	if(!$data) { fail();}
	$res = `./scrape.pl $from $id $base | ./transfer.sh $from $to | ./post.pl $to $user_info{$to . "_name"} $user_info{$to . "_pass"}`;
	if($res){ fail(); }
    print <<END;
<title>Thank you</title>
<h1>Thank you $login_name</h1>
<p>Go to <a href="http://www.yachtcouncil.org">yachtcouncil</a> or<p>
<p><a href="http://www.boatwizard.com">yachtworld</a> to review the new listing<p>
<p>or go back <a href="/~jordanr/index.html">home</a> to transfer another listing.<p>
<p>You have uploaded the following yacht information:</p>
<p>$data </p>
END
    exit; } }

@yw_list = `./list.pl yw $user_info{yw_base} | sed -f yw2list.sed`;

chomp(@yw_list);
@yw_ids = grep(/^ID~/, @yw_list);
@yw_mans = grep(/^MANUFACTURER~/, @yw_list);
@yw_lens = grep(/^LENGTH~/, @yw_list);


@yw_ids = clean_array(\@yw_ids);
@yw_mans = clean_array(\@yw_mans);
@yw_lens = clean_array(\@yw_lens);

unshift(@yw_ids, "");
unshift(@yw_lens, "Length");
unshift(@yw_mans, "Manufacturer");

%yw_labels = array_hash(\@yw_ids, \@yw_lens, \@yw_mans);

$yw_size = keys %yw_labels;
if($yw_size > 25) { $yw_size = 25;}

sub clean_array {
	my @this = @{(shift)};
	foreach $element (@this) {
		$element =~ s/.*~(.*)/$1/;
	}
	return @this;
}
sub array_hash {
	my %hash = ();
	my @one = @{(shift)};
	my @two = @{(shift)};
	my @three = @{(shift)};
	foreach $key ( @one) {
		my $value = shift(@two) . " " . shift(@three);
		$hash{$key} = $value;
	}
	return %hash;
}

@yc_list = `./list.pl yc $user_info{yc_base} | sed -f yc2list.sed`;
chomp(@yc_list);

@yc_ids = grep(/^ID~/, @yc_list);
@yc_mans = grep(/^MANUFACTURER~/, @yc_list);
@yc_lens = grep(/^LENGTH~/, @yc_list);


@yc_ids = clean_array(\@yc_ids);
@yc_mans = clean_array(\@yc_mans);
@yc_lens = clean_array(\@yc_lens);

unshift(@yc_ids, "");
unshift(@yc_lens, "Length");
unshift(@yc_mans, "Manufacturer");

%yc_labels = array_hash(\@yc_ids, \@yc_lens, \@yc_mans);
$yc_size = keys %yc_labels;
if($yc_size > 25) { $yc_size = 25;}

print start_form, "Welcome $login_name. Choose yachts from the lists below.", hr,
  table(Tr( th(Yachtworld),th(Yachtcoucil) ),
  Tr(td( scrolling_list(-name=>'yw_id', -values=>\@yw_ids, -size=>$yw_size,
			-multiple=>'true', -labels=>\%yw_labels)),
     td( scrolling_list(-name=>'yc_id', -values=>\@yc_ids, -size=>$yc_size,
			-multiple=>'true', -labels=>\%yc_labels))),
  Tr(td(submit(-name=>'submit', -value=>'Transfer YW2YC')),
     td(submit(-name=>'submit', -value=>'Transfer YC2YW')))), end_form;

sub fail {
   print "<title>Error</title>",
   '<p>Error: email jordanr@cs.washington.edu</p>';
   exit; }

sub ok() {
    $fine = 1;
    if(!$id) { print 'A yacht choice is required.', br; $fine = 0; }
    if(!$fine) { print 'Please choose one and resubmit.', hr; }
    return $fine; }
