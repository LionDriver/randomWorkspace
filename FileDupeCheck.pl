#!/usr/bin/perl -w

#*****************FileDupeCheck.pl***************
# A VERY SIMPLE script to check for duplicate files with or without the same file name.
# Copywrite Steve Osteen 2009
#
# Setup:
# Install needed modules (Run following commands in an admin cmd promopt or terminal) 
# cpan App:cpanminus
# cpan Digest::MD5 
#
# Usage: perl FileDupeCheck.pl dir or place this in the directory and just run it as FileDupeCheck.pl
# It will create a text file with a list of all duplicates

use strict;
use File::Find;
use Digest::MD5;

my %files;
my $useless = 0;
my $num = 1;
find(\&check_file, $ARGV[0] || ".");

open (RES, '>ScanResults.txt' ) or die "Unable to write to output file\n";
print RES "Results for duplicate files found in folder:";
print RES ($ARGV[0] || ".");
print RES "\n\n";
print "FileDupeCheck\nScanning..\n";

#Note: much of this routine was from known popular md5 dupe check routines on perlmonks

local $" = " <<<<>>>> ";
foreach my $size (sort {$b <=> $a} keys %files) {

next unless @{$files{$size}} > 1;
  my %md5;
  foreach my $file (@{$files{$size}}) { 
    open(FILE, $file) or next;
    binmode(FILE);
    push @{$md5{Digest::MD5->new->addfile(*FILE)->hexdigest}},$file;  
  }
  foreach my $hash (keys %md5) {
    next unless @{$md5{$hash}} > 1;
    print RES "$num";
    print "Found Duplicate\n";
    print RES ": @{$md5{$hash}}"; 
    print RES "\tSize: $size\n";
    $num++;
    $useless += $size * (@{$md5{$hash}} - 1);
  }
}

1 while $useless =~ s/^([-+]?\d+)(\d{3})/$1,$2/;
print "$useless bytes wasted in duplicated files\n";
print RES "\n\n$useless bytes wasted in duplicated files\n";
print "You can find a list of duplicate file details in ScanResults.txt\n";
close (RES);

sub check_file {
  -f && push @{$files{(stat(_))[7]}}, $File::Find::name;
}