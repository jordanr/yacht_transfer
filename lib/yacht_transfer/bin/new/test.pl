#!/usr/bin/perl -w
#

open(USER_INFO, "< jordanship");
%user_info = ();
while(<USER_INFO>) {
    my @line = split(":",$_);
    chomp(@line);
    $user_info{$line[0]} = $line[1];
}


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

