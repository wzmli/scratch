use strict;
use 5.10.0;

my $top=100;
my %square;
my @square;

for (my $i=1; $i<=$top; $i++){
	my $ii = $i*$i;
	push @square, $ii;
	$square{$ii} = 0;
}

foreach my $i (@square){
	foreach my $j (@square){
		next unless $j<$i;
		foreach my $k (@square){
			next unless $k<$j;
			my $l = $j + $k - $i;
			next unless defined $square{$l};
			say "$i $j $k $l";
		}
	}
}
