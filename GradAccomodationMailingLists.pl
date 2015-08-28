#!/usr/bin/env perl

#  GradAccomodationMailingLists.pl
#  GradAccomodationMailingLists
#
#  Created by Richard Gunning on 3/2/15.
#  Copyright (c) 2015 Richard Gunning. All rights reserved.

use Modern::Perl;
use Text::CSV_XS;
use Data::Dumper;
#use LWP::Protocol::https;
use LWP::Simple;
use Encode qw/encode decode/;
use Switch;

#my $csv_text = get 'https://cweb4.clare.cam.ac.uk/rooms/hens-owng6732sdsalsdjhbewq/gradinfo.csv' or die "Couldn't get csv";
#my $text = encode("UTF-16", $csv_text);
`curl https://cweb1.clare.cam.ac.uk/rooms/hens-owng6732sdsalsdjhbewq/gradinfo.csv -o gradinfo.csv`;

my $csv = Text::CSV_XS->new;
my %hashref;
my %oldref;
my $email;
my $name;
my $address;
my @locations =['St_Regis','Chesterton','CCT','Netherfield_House','Queen_Ediths','Thirkill_Court'];

my $count =0;
open (my $fh,'<:encoding(UTF-16)','gradinfo.csv') or die "can't open ";
while (my $row = $csv->getline($fh)) {
	$count ++;
	next if $count==1;
	$name = substr(@$row[1],0,1).". ".@$row[2];
    $email = @$row[9];
	$address=@$row[4].@$row[6];
    switch ($address) {
        case /St Regis/ {$address="St_Regis"}
        case /Chesterton Road/ {$address="Chesterton"}
        case /Newnham Road/ {$address="CCT"}
        case /Netherfield House/ {$address="Netherfield_House"}
        case /Queen Ediths House/ {$address="Queen_Ediths"}
        case /Thirkill Court/ {$address="Thirkill_Court"}
        else {$address='Private'}
    }
    next if $address eq 'Private';
    $hashref{$address}{$name}=$email;
}
close $fh;

# Create new file
foreach my $info ( sort keys %hashref){
    open (my $fh, '>', $info.".csv");
    foreach my $name (keys %{ $hashref{$info} }){
        print $fh "$hashref{$info}{$name}\n";
    }
    close $fh;
}


`wget --keep-session-cookies --save-cookies cookies.txt --post-data 'userid=rjg70&pwd=Be534d8d2e!&submit' https://raven.cam.ac.uk/auth/authenticate2.html`;


`curl 'https://lists.cam.ac.uk/mailman/admin/clare-mcr-chesterton-road/members/add' -H 'Cookie: Ucam-WebAuth-Session-S=3!200!!20150522T122310Z!20150522T122310Z!7200!1432297390-21696-234!rjg70!current!pwd!!!1!dvZ-uZlir6nBRyXTdov5asvEmR0_' -H 'Origin: https://lists.cam.ac.uk' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en;q=0.8,en-US;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.152 Safari/537.36' -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundary5TVc7DyCAEcEmvAo' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: https://lists.cam.ac.uk/mailman/admin/clare-mcr-chesterton-road/members/add' -H 'Connection: keep-alive' --data-binary $'------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="subscribe_or_invite"\r\n\r\n0\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="send_welcome_msg_to_this_batch"\r\n\r\n0\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="send_notifications_to_list_owner"\r\n\r\n0\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="subscribees"\r\n\r\n\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="subscribees_upload"; filename="Chesterton.csv"\r\nContent-Type: text/csv\r\n\r\n\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="invitation"\r\n\r\n\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo\r\nContent-Disposition: form-data; name="setmemberopts_btn"\r\n\r\nSubmit Your Changes\r\n------WebKitFormBoundary5TVc7DyCAEcEmvAo--\r\n' --compressed`;
# compare with old file
#foreach my $info ( sort keys %hashref){
    #    open (my $fh, '>', "old_".$info.".csv");
    #    my $oldref{$info}
    #    close $fh;
    #}


#foreach my $info ( sort keys %hashref){
#    open (my $fh, '>', $info.".csv");
#    foreach my $name (keys %{ $hashref{$info} }){
#        print $fh "$hashref{$info}{$name}\n";
#    }
#    close $fh;
#}

        #while (my $out1 = each %hashref) {
    #	print "$out1: $hashref{$out1}: $emailref{$out1}\n";
    #}

# my %hash;
# get_list();
# #print Dumper(%hash);
#
#
#
# sub get_list {
# 	#my $csv_text = get 'http://cweb4.clare.cam.ac.uk/rooms/hens-owng6732sdsalsdjhbewq/gradinfo.csv' or die "Couldn't get csv";
# 	`wget http://cweb4.clare.cam.ac.uk/rooms/hens-owng6732sdsalsdjhbewq/gradinfo.csv`;
# 	print $tmp;
# 	my $csv = Text::CSV_XS->new;
# 	open (my $fh, '<', $tmp) or die "can't read string";
# 	my @rows;
# 	while (my $row = $csv->getline($fh)) {
# 		print join('-', @$row), "\n";
# 		#$hash{$fields->[2]}=$fields->[6];
# 	}
# 	close $fh;
#
# }


=head1 NAME

GradAccomodationMailingLists.pl

=head1 SYNOPSIS

GradAccomodationMailingLists.pl [Options]

Update Grad email lists

=head1 OPTIONS

-i,-infile     input file
-o,-outfile    output file
-h,-help

=cut
