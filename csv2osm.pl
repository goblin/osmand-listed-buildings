#! /usr/bin/perl

use strict;
use warnings;

use Text::CSV;

my $csv = Text::CSV->new({sep_char => ';'});

$csv->column_names($csv->getline(*ARGV));

my $cnt = 1;

print <<EOH ;
<?xml version='1.0' encoding='UTF-8'?>
<osm version='0.6' upload='false' generator='csv2osm.pl by goblin'>
EOH
while(my $l = $csv->getline_hr(*ARGV)) {
	my $name = $l->{Name};
	$name =~ s/&/&amp;/g;
	$name =~ s/'/&quot;/g;
	my ($lon, $lat) = ($l->{Longitude}, $l->{Latitude});
	$lon =~ s/,/./;
	$lat =~ s/,/./;
	print "<node id='-$cnt' action='modify' visible='true' ".
		"lat='$lat' lon='$lon' >".
		"<tag k='user_defined' v='wlm' />".
		"<tag k='name' v='($l->{Grade}) $name' />".
		"</node>\n";
	$cnt++;
}

print "</osm>\n";
