package Attic::Hub::None;

use strict;
use warnings;

use base 'Plack::Component';

use File::Spec;

sub modification_time {
	my $self = shift;
	my $modification_time = 0;
	foreach my $file (values %{$self->{hub}->{files}}) {
		
	}
	return $modification_time;
}

sub call {
	my $self = shift;
	my ($env) = @_;
	return [404, ['Content-type', 'text/plain'], ["Nothing!"]];
}

1;
