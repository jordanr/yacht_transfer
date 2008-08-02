#!/usr/bin/perl -w

@data = <STDIN>;
chomp(@data);
$output = shift(@data);
foreach $line (@data) {
    if($line =~ /~/) {
	$output.= "\n";
    }
    $output.= $line;
}
print "\n" . $output;
exit;
