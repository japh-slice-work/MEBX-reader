#!c:\perl\bin\perl

use strict;
use PDL;
use Switch;
use Data::Dumper;
use GD;


my $filename='sample.png';
my $image = GD::Image->new($filename);
if ($image == undef) {die('failed to open image');}
my @bounds = $image->getBounds();
my $cellWidth=($bounds[0]/80);
my $cellHeight=($bounds[1]/25);
for (my $Hcell=0;$Hcell<81 ;$Hcell++) {
	for (my $Vcell=0;$Vcell<26 ;$Vcell++) {
		#foo
		my $outimage = new GD::Image($cellWidth,$cellHeight);
		$outimage->copy($image,0,0,($cellWidth*$Hcell),($cellHeight*$Vcell),$cellWidth,$cellHeight);
		my $filename='h'. sprintf("%02d",$Vcell) .'v'. sprintf("%02d",$Hcell) . '.png';
		unless (open(OUT,">$filename")) {warn($!);}
		binmode(OUT);
		print OUT $outimage->png;
		close(OUT);
	}
}

