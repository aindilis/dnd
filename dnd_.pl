#!/usr/bin/perl -w

use Geo::Distance::Google;

my $geo = Geo::Distance::Google->new;

my $distance = $geo->distance(
			      # sears tower... wacker tower whatever
			      origins      => '233 S. Wacker Drive Chicago, Illinois 60606',
			      destinations => '1600 Amphitheatre Parkway, Mountain View, CA'
			     );

printf "The distance between: %s and %s is %s\n",
  $distance->[0]->{origin_address},
  $distance->[0]->{destinations}->[0]->{address},
  $distance->[0]->{destinations}->[0]->{distance}->{text};
