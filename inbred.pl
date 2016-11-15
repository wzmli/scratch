use strict;
use 5.10.0;

my $top=100;
my %square;
my @square;
my %assoc;
my %inbred;

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
			push @{$assoc{$i+$l}}, $j-$l;
			push @{$assoc{$i+$l}}, $k-$l;
		}
	}
}

while (my($spawn, $ar) = each(%assoc)){
	foreach my $i (@${ar}){
		foreach my $j (@${ar}){
			next if $i==$j;
			if (defined $assoc{$i}){
				foreach my $k (@{$assoc{$i}}){
					push @{$inbred{$j}}, $i if $k==$j;
					say "$j $i ($spawn)" if $k==$j;
				}
			}
		}
	}
}
