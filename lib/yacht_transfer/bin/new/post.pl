#!/usr/bin/perl -w
  
# This script posts the form data on the given website.
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;
# global variable
my $ua = LWP::UserAgent->new; # web crawler
push @{ $ua->requests_redirectable }, 'POST';
my $cookie_jar = HTTP::Cookies->new(
                                 file => "cookies.txt",
                                 autosave => 1,
				 ignore_discard=> 1);
$ua->cookie_jar($cookie_jar);

# these three are required args
$SITE = $ARGV[0]; 
$SITE=~tr/a-z/A-Z/;
$USER = $ARGV[1];
$PASSWRD = $ARGV[2];
# holds the data to post
my @data = <STDIN>; # else pipe data from translate
chomp(@data);
my(%data_hash) = &hash(\@data);

my @titles = grep(/^TITLE/,@data);
#my(%title_hash) = &hash(\@titles);
my @bodies = grep(/^BODY/,@data);
#my(%body_hash) = &hash(\@bodies);
# id is optional and is for adding to an existing listing
$ID = $ARGV[3]; 

post();
exit;

sub set_data {
	my $cur_form = shift;
	my %weirdo_hash = %{(shift)};
	foreach $arg (@_) {
		%hash =%{$arg};
		$cur_form = fill_out_form($cur_form, \%hash);
	}
	$cur_form = set_weirdos($cur_form, \%weirdo_hash);
	return $cur_form;
}

sub submit_page {
	my $cur_form = shift;
	my $submit_keyword = shift;
	my $req = undef;
	if($submit_keyword) {
		$req = $cur_form->click($submit_keyword);
	}
	else {
		$req = $cur_form->click;
	}
	my $response = $ua->request($req);
	if(!$response->is_success) {
		die $response->status_line;
	}	
	return $response;
}

sub set_weirdos {
	my $cur_form = shift;
	my %weirdo_hash = %{(shift)};
	foreach $key (keys %weirdo_hash) {
		$input = $cur_form->find_input($key);
		if(!$input) { next;}
		@pos = $input->possible_values;
		$idx = $weirdo_hash{$key};
		$input->value($pos[$idx]);
	}
	return $cur_form;
}	

sub print_hash {
	%hash = %{(shift)};
	$output = "";
	foreach $key (keys %hash) {
		$output .= $key . ":" . $hash{$key} . "\n";
	}
	die $output;
}
sub post {
    	print STDERR "Posting to $SITE.";
	%default_hash = &get_defaults("$SITE" ."_DEFAULTS");
        %weirdo_hash = &get_defaults("$SITE" . "_WEIRDOS");

	my @titles = grep(/^TITLE/,@data);
        my @bodies = grep(/^BODY/,@data);

	my $page= undef;
	my $form = undef;
	$file = $SITE . "_PAGES";
	if($ID) { $file.= "_CONT"; }
        open(PAGES, "< $file");
	while(<PAGES>) {
		parse_and_execute($_);
	}
      	close (PAGES);
        print STDERR ".done\n";
}


sub parse_and_execute {
	$line = shift;
	@codewords = split("~",$line);
	chomp(@codewords);
	# commmand must be one of the below or this function dies
	for ($codewords[0]) {
      		/credentials/ && do{		
	      		$ua->credentials($codewords[1],$codewords[2],$USER,$PASSWRD);
			next;
		};
        	/login/ && do{
			$codewords[1] =~ s/\$USER/$USER/;
			$codewords[1] =~ s/\$PASSWRD/$PASSWRD/;
                       	$page = $ua->get($codewords[1]);
			next;
		};
		/buc/ && do {
			$page= $ua->get($codewords[1]);
			die $page->content;
			$form = get_form($page, $codewords[2]);
			$form->value($codewords[3], $PASSWRD);
			$form->value($codewords[2], $USER);
			$page=submit_page($form,$codewords[4]);
			next;
		};
		/forage/ && do {
			if($done) { next; }
			$codewords[1] =~ s/\$ID/$ID/;
			$codewords[1] =~ s/\$USER/$USER/;
			$page = $ua->get($codewords[1]);
			$form = get_form($page, $codewords[2]);
			next;
		};
		/content/ && do {
			die $page->content;
		};
		/dump/ && do {
			die $form->dump;
		};
		/page/ && do {
			if($done) { next;}
			$codewords[1] =~ s/\$ID/$ID/;
			$page = $ua->get($codewords[1]);
			next;
		};
		/form/ && do {
			if($done) {next;}
			$form = get_form($page, $codewords[1]);
			next;
		};		
    		/basic/ && do{
			$form = set_data( $form, \%weirdo_hash, \%default_hash, \%data_hash);
			next;
		};
		/error/ && do {
			#error correction
			my $content = $page->content;
                        if($codewords[1] and $content =~ /$codewords[1]/) {
                        	%error_hash = &get_errors($content, "$SITE" .  "_ERRORS");
				$form = get_form($page, $codewords[2]);
				$form = set_data($form, \%weirdo_hash, \%default_hash, \%data_hash, \%error_hash);
				$page = submit_page($form, $codewords[3]);
                       	}
			next;
		};
		/id/ && do{
	                $form = get_form($page, $codewords[1]);
                        $input = $form->find_input($codewords[1]);
	       	        $ID = $input->value;
			next;
		};
		/details/ && do{
			# finished if below is true
			if($done) { next;}
			$form = set_text($form, $codewords[1], $codewords[2]);
			next;
		};
		/submit/ && do {
			$page = submit_page($form, $codewords[1]);
			next;
		};
		/.*/ && do{die "Corrupt file $file";};
	}
}	

sub get_form {
    my $response = shift;
    if(!$response->is_success) { die $response->status_line;}
    my $input_to_find = shift;
    my @forms = HTML::Form->parse($response);
    if(!$input_to_find) { return $forms[0]; }
    foreach $form (@forms) {
	if($form->find_input($input_to_find)) {
	    return $form;
	}
    }
    die "Form Not Found Error: Looking for input " . $input_to_find;
}

sub set_text {
	my $cur_form = shift;
	my $title_keyword = shift;
	my $body_keyword = shift;
	if(!$title_keyword or !$body_keyword) {
		return $cur_form;
	}
	my @inputs = $cur_form->inputs;
	foreach $input (@inputs) {
		if(!@bodies) { $done=1; last;}
		$field = $input->name;
		if(!$field) { next;}
		$field =~ s/\d.*//;
		if ($field eq $title_keyword) {
			my $title = shift(@titles);
			$input->value(substr($title,index($title,"~")+1));
		}
		if ($field eq $body_keyword ){
			my $body = shift(@bodies);
			$input->value(substr($body,index($body,"~")+1));
		}
	}
	return $cur_form;
}

sub fill_out_form{
	my $form = shift;
	my %inputs_to_fill = %{(shift)};
	foreach $field (keys %inputs_to_fill) {
		$input = $form->find_input($field);
		if($input && !$input->readonly) {
			print STDERR ".";
			$value = $inputs_to_fill{$field};
			$input->value($value);
		}
	}
	return $form;
}

sub get_defaults {
	my $default_file = shift;
	open (DEFAULTS, "< $default_file");
	my @defaults = <DEFAULTS>;
	close(DEFAULTS);
	chomp(@defaults);
	return &hash(\@defaults);
}

sub get_errors {
	my $error_content = shift;
	my $error_file = shift;

	my %error_hash = ();
	open(ERRORS, "< $error_file") or die "Error file not found";
	while (<ERRORS>) {
		my @error_line = split ("~",$_);
		chomp(@error_line);
		if(scalar(@error_line) == 0) { next;}		
		my $error = shift(@error_line);
		if($error_content =~ /$error/) {
			my $bad_field = shift(@error_line);
			my $default_value = shift(@error_line);
			$error_hash{$bad_field} = $default_value;
		}
	}
	close(ERRORS);
	return %error_hash;
}

sub hash {
	@to_hash = @{(shift)};
	%hash = ();
	foreach $line (@to_hash) {
		my @temp = split("~",$line);
		if(scalar(@temp) == 0 ) { next;}
		$hash{$temp[0]} = $temp[1];
	}
	return (%hash);
}
