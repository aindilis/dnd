#!/usr/bin/perl -w

use PerlLib::HTMLConverter;

my $hc = PerlLib::HTMLConverter->new;

my $datadir = "data/d20srd/www.d20srd.org";
foreach my $file (split /\n/, `find $datadir`) {
  if ($file =~ /\.htm$/ and -f $file) {
    print $file."\n";
    my $c = `cat "$file"`;
    print $hc->ConvertToTxt
      (Contents => $c);
    my $it = <STDIN>;
  }
}
