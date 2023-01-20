#!c:\perl\bin\perl

#####
# (C) Marc Labelle 2008
#
#
#
#
#

use strict;
use PDL;
use Switch;
use Data::Dumper;
use GD;
$|=1;
my $saveUnknownsByGridCoords=0;
my %refKimgs=(
			'+' =>	['./maps/kupleft.png','./maps/kupright.png'],
			'.' =>	['./maps/uperiod.png'],
			' ' =>	['./maps/kspace.png','./maps/ukspace.png','./maps/kspace2.png','./maps/kspace3.png','./maps/uspace.png'],
			'/' =>	['./maps/kslash.png','./maps/kslash2.png'],
			'-' =>	['./maps/kdash.png','./maps/udash.png'],
			'=' =>	['./maps/kdbar.png','./maps/udbar.png','./maps/kdbar2.png'],
			'|' =>	['./maps/kvbar.png'],
			'[' =>	['./maps/k[.png','./maps/u[.png'],
			']' =>	['./maps/k].png','./maps/u].png'],
			'(' =>	['./maps/uk(.png','./maps/u(.png'],
			')' =>	['./maps/uk).png','./maps/u).png'],
			'0' =>	['./maps/u0.png'],
			'2' =>	['./maps/u2.png'],
			'3' =>	['./maps/u3.png'],
			'4' =>	['./maps/u4.png'],
			'6' =>	['./maps/u6.png'],
			'8' =>	['./maps/u8.png'],
			a =>	['./maps/lka.png','./maps/lua.png'],
			b =>	['./maps/lub.png'],
			c =>	['./maps/lkc.png'],
			d =>	['./maps/lkd.png','./maps/lud.png'],
			e =>	['./maps/lke.png','./maps/lue.png'],
			g =>	['./maps/lug.png'],
			h =>	['./maps/lkh.png','./maps/luh.png','./maps/luh2.png'],
			i =>	['./maps/lki.png','./maps/lui.png','./maps/lui2.png','./maps/lui3.png','./maps/lui4.png'],
			l =>	['./maps/lkl.png','./maps/lul.png','./maps/lul2.png'],
			m =>	['./maps/lkm.png','./maps/lum.png'],
			n =>	['./maps/lkn.png','./maps/lkn2.png','./maps/lun.png'],
			o =>	['./maps/lko.png','./maps/lko2.png','./maps/luo.png'],
			p =>	['./maps/lkp.png','./maps/lup.png'],
			r =>	['./maps/lkr.png','./maps/lkr2.png','./maps/lur.png'],
			s =>	['./maps/lks.png','./maps/lus.png'],
			t =>	['./maps/lkt.png','./maps/lkt2.png','./maps/lut.png'],
			u =>	['./maps/lku.png','./maps/luu.png'],
			v =>	['./maps/lkv.png','./maps/luv.png'],
			w =>	['./maps/lkw.png'],
			'x' =>	['./maps/lux.png'],
			y =>	['./maps/lky.png','./maps/luy.png'],
			A =>	['./maps/cua.png','./maps/uua.png','./maps/uuka.png'],
			B =>	['./maps/uub.png'],
			C =>	['./maps/ukc.png','./maps/ukc2.png','./maps/uuc.png','./maps/uuc2.png'],
			D =>	['./maps/ukd.png'],
			E =>	['./maps/uke.png','./maps/uue.png','./maps/uuke.png'],
			F =>	['./maps/ukf.png','./maps/uukf.png'],
			G =>	['./maps/uukg.png'],
			H =>	['./maps/uhh.png'],
			I =>	['./maps/uki.png','./maps/uui.png','./maps/uki2.png','./maps/uuki.png','./maps/uuki2.png'],
			L =>	['./maps/ukl.png','./maps/uukl.png'],
			M =>	['./maps/uum.png','./maps/uukm.png'],
			N =>	['./maps/uukn.png','./maps/uun.png'],
			O =>	['./maps/uko.png','./maps/uuko.png','./maps/uuo.png'],
			P =>	['./maps/ckp.png','./maps/ukp2.png'],
			R =>	['./maps/ukr.png','./maps/cur.png','./maps/uukr.png'],
			S =>	['./maps/uks.png','./maps/uus.png'],
			T =>	['./maps/ukt.png','./maps/ukt1.png','./maps/ukt2.png','./maps/uukt.png','./maps/uut.png'],
			U =>	['./maps/uku.png','./maps/uku2.png','./maps/uuku.png'],
			);
#print Dumper \%refKimgs;
my @keys=sort(keys(%refKimgs));
my $filename='test.png';
my $mapFile='./maps/lks.png';
my $testImage = GD::Image->new($filename);
if ($testImage == undef) {die('failed to open image');}
print "Loading Keys: ->". join('',@keys) ."<-\nConverting to vector and Normalizing:";
foreach my $key (keys(%refKimgs)) {
	for (my $arrayIndex=0;$arrayIndex<scalar(@{$refKimgs{$key}}) ;$arrayIndex++) {
		my $mapImage = GD::Image->new(${$refKimgs{$key}}[$arrayIndex]);
#		my $grey=findBoundingBox($mapImage);
#					my $fn= ${$refKimgs{$key}}[$arrayIndex];
#					$fn =~s/maps/debug_dumps/;
#					open(FH,">$fn");
#					binmode(FH);
#					print FH $grey->png;
#					close(FH);
		if ($mapImage == undef) {die($!. ${$refKimgs{$key}}[$arrayIndex] .' failed to open map image');}
		my $mapVector=loadVectorFromImage($mapImage);
		#print $mapVector . "\n\n\n";
		${$refKimgs{$key}}[$arrayIndex]=norm $mapVector;
		print '.';
	}
}
print "Done.\n";
#print Dumper \%refKimgs;
print "starting: \n\n\n";
unless (open(OUTPUTTEXT,">out.txt")) {die($!);}
my @bounds = $testImage->getBounds();
my $cellWidth=($bounds[0]/80);
my $cellHeight=($bounds[1]/25);
for (my $Vcell=0;$Vcell<26 ;$Vcell++) {
	for (my $Hcell=0;$Hcell<81 ;$Hcell++) {
		my $testImageCell = new GD::Image($cellWidth,$cellHeight);
		$testImageCell->copy($testImage,0,0,($cellWidth*$Hcell),($cellHeight*$Vcell),$cellWidth,$cellHeight);
		my $testCellVector=loadVectorFromImage($testImageCell);
		$testCellVector=norm $testCellVector;
		my $coord='h'. sprintf("%02d",$Vcell) .'v'. sprintf("%02d",$Hcell) . '';
		my $foundMatchToKey=0;
		my $maxCosineValue='';
		my $maxCosineNumber=0;
		foreach my $key (sort(keys(%refKimgs))) {
			foreach my $sample (@{$refKimgs{$key}}) {
				my $cosine=cosineNmap($sample,$testCellVector);
				if ($cosine > .98) {print "$key";print OUTPUTTEXT $key;$foundMatchToKey=1;last;}
				elsif ($cosine>$maxCosineNumber) {$maxCosineNumber=$cosine;$maxCosineValue=$key;}
			}
			if ($foundMatchToKey) {last;}
		}
		if ($maxCosineNumber > .91 && !($foundMatchToKey)) {$foundMatchToKey=1;print "$maxCosineValue";print OUTPUTTEXT $maxCosineValue;}
		unless ($foundMatchToKey) {
			print OUTPUTTEXT " ";
			print '?';
			if ($saveUnknownsByGridCoords) {
				unless ($maxCosineValue eq '') {
					my $fn= './debug_dumps/' . $coord . '.'.$maxCosineNumber.'('.$maxCosineValue.')'.'.png';
					open(FH,">$fn");
					binmode(FH);
					print FH $testImageCell->png;
					close(FH);
				}
			}
		}
		if (1) {
					my $fn= './debug_dumps/' . $coord . '.'.$maxCosineNumber.'('.$maxCosineValue.')'.'.png';
					open(FH,">$fn");
					binmode(FH);
					print FH $testImageCell->png;
					close(FH);
		}

		#my $cosine=cosineNmap($NmapVector,$testCellVector);
		#if ($cosine > 0.9) {print $coord . $cosine ."\n";}
		#if ($cosine > 1) {	#can't happen, conveinent way of mapping this if out.
		#	my $fn=$cosine . '.png';
		#	open(FH,">$fn");
		#	binmode(FH);
		#	print FH $testImageCell->png;
		#	close(FH);
		#}
	}
	print OUTPUTTEXT "\n";	
	print "\n";	
}

close(OUTPUTTEXT);

sub findBoundingBox{
	my $image=$_[0];
	my @bounds = $image->getBounds();	#width / height
	#find top
	my $i = 0;
	my $t = $image->colorsTotal();
	#print "total colors: $t\n";
	my @thresh=(140,140,200);
	my $average;
	while($i < $t) {
		my( @c ) = $image->rgb( $i );
		if ($c[0]>$thresh[0])	{$c[0]=255;}
		if ($c[1]>$thresh[1])	{$c[1]=255;}
		if ($c[2]>$thresh[2])	{$c[2]=255;}
		if ($c[0]<=$thresh[0])	{$c[0]=0;}
		if ($c[1]<=$thresh[1])	{$c[1]=0;}
		if ($c[2]<=$thresh[2])	{$c[2]=0;}
		my $g = ( $c[0] + $c[1] + $c[2] ) / 3; # Color::Calc::grey
#		if (!$c[0] && !$c[1]) {$g=$c[2];}
#		elsif ($c[0] + $c[1] + $c[2] >= (255*3/2)) {$g=255;}
#		elsif ($c[0] + $c[1] + $c[2] <  (255*3/2)) {$g=0;}
		$average=($g+$average)/2;
		$image->colorDeallocate($i);
		$image->colorAllocate( $g, $g, $g );
		$i++;
	}
	$i = 0;
	$t = $image->colorsTotal();
	while($i < $t) {
		my $g=$average;
		my( @c ) = $image->rgb( $i );
		if (( $c[0] + $c[1] + $c[2] ) / 3 < $average) {$g=0;}
		else											{$g=255;}
		$image->colorDeallocate($i);
		$image->colorAllocate( $g, $g, $g );
		$i++;
	}
	return($image);
}

sub cosineNmap {
        my ($n1, $n2 ) = @_;
       # my $n1 = norm $vec1;
       # my $n2 = norm $vec2;
        my $cos = inner( $n1, $n2 );    # inner product
        return $cos->sclr();  # converts PDL object to Perl scalar
}
sub cosine {
        my ($vec1, $vec2 ) = @_;
        my $n1 = norm $vec1;
        my $n2 = norm $vec2;
        my $cos = inner( $n1, $n2 );    # inner product
        return $cos->sclr();  # converts PDL object to Perl scalar
}

sub loadVectorFromImage{
	my $image=$_[0];
	my %RGBpxARY;
	my $PixelCounter=0;
	my @bounds = $image->getBounds();
	for (my $W=0;$W<=$bounds[0] ;$W++) {
		for (my $H=0;$H<=$bounds[1] ;$H++) {
			my $index = $image->getPixel($W,$H);
			my @RGB = $image->rgb($index);
			$RGBpxARY{$PixelCounter}=(($RGB[0]+$RGB[1]+$RGB[2])/3);
			$PixelCounter++;
		}
	}
	my $vectorCounter=(($PixelCounter)*1);
	my $vec = zeroes $PixelCounter;
	$vectorCounter=0;
	for (my $i=0 ;$i < $PixelCounter;$i++) {
		index($vec, $vectorCounter) .= $RGBpxARY{$i};
		$vectorCounter++;
	}
	return($vec);
}sub loadVectorFromImage_old{
	my $image=$_[0];
	my %RGBpxARY;
	my $PixelCounter=0;
	my @bounds = $image->getBounds();
	for (my $W=0;$W<=$bounds[0] ;$W++) {
		for (my $H=0;$H<=$bounds[1] ;$H++) {
			my $index = $image->getPixel($W,$H);
			my @RGB = $image->rgb($index);
			$RGBpxARY{$PixelCounter}=\@RGB;
			$PixelCounter++;
		}
	}
	my $vectorCounter=(($PixelCounter)*3);
	my $vec = zeroes $vectorCounter;
	$vectorCounter=0;
	for (my $i=0 ;$i < $PixelCounter;$i++) {
		index($vec, $vectorCounter) .= ${$RGBpxARY{$i}}[0];
		$vectorCounter++;
		index($vec, $vectorCounter) .= ${$RGBpxARY{$i}}[1];
		$vectorCounter++;
		index($vec, $vectorCounter) .= ${$RGBpxARY{$i}}[2];
		$vectorCounter++;
		
	}
	return($vec);
}