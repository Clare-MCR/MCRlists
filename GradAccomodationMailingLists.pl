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

my %cfg;
my $app;

my $count =0;
{
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
}



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
