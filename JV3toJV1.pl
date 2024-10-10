#!/usr/bin/perl -w
#
use Data::Dumper ;

# print Dumper \@ARGV;

$file = $ARGV[0] ;
printf("File $file\n") ;
open(JV3, '<', $file) or die "no such file $1\n" ;
$size = -s $file; 
if ($size < 8704) {
	die("File is too small to be a JV3 file\n") ;
}
$size -= 8704 ;
$N=0 ;
$trk=0 ;
$sect=0 ;
$flag=0 ;
$cin=' ' ;
$err=0 ;
@SECT=();
my $buffer = "  " ;

sub empty_b
{
	  $buffer="\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5" ;
	  $buffer = $buffer.$buffer ;
	  $buffer = $buffer.$buffer ;
	  $buffer = $buffer.$buffer ;
	  $buffer = $buffer.$buffer ;
	  $buffer = $buffer.$buffer ;
}

for ($i=0; $i<2901; ++$i) {
	read(JV3, $cin, 1) or die("Format error in JV3 at byte $i\n") ; $trk=ord($cin) ;
	last if ($trk==0xFF) ;
	read(JV3, $cin, 1) or die("Format error in JV3 at byte $i\n") ; $sect=ord($cin) ;
	read(JV3, $cin, 1) or die("Format error in JV3 at byte $i\n") ; $flag=ord($cin) ;
	$realsect = $trk*10+$sect ;
	if (defined($SECT[$realsect]))
	{
	  printf("ERROR : physical sector %d multiple definition = %d\n", $realsect ,$SECT[$realsect]) ;
	  $err++ ;
	} else {
	  $SECT[$realsect] = $N ;
	}	
	printf("secteur %d, trk=%d, sect=%d, flag=%02X        \r", $N, $trk, $sect, $flag) ;
	++$N ;
}
printf("\nTotal errors = %d\n", $err) ;
if ($size < $N*256) {
   printf("JV3 file size should be %d (%d + 8704)\n", $N*256+8704, $N*256) ;
   die("Aborting") ;
}
open(FOUT, '>', $file.".JV1") ;
for ($i=0; $i<$N; ++$i) {
	if (!defined $SECT[$i]) {
	  &empty_b() ;
	  printf("warning sector $i not defined\n") ;
	} else {
		$sect = $SECT[$i] * 256 + 8704 ;
		seek(JV3, $sect, 0) ;
		die("read sector failed at $sect") if (read(JV3, $buffer, 256)!= 256)  ;
	}
	print FOUT  $buffer ;
}
while (($i % 10) != 0)
{
  &empty_b() ;
  print FOUT  $buffer ;
  ++$i ;
  printf("warning padding disk at sector $i\n") ;
}
close FOUT ;
close JV3 ; 
printf("Finished\n") ;
