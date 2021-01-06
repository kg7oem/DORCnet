package DORCNet::Message;

use strict;
use warnings;
use v5.10;

use base qw(Exporter);

our @EXPORT_OK = qw(
    parse_message
);

sub parse_message {
    my ($raw) = @_;
    my $pos = 0;
    my @return;

    # protocol version number
    push(@return, unpack(C => substr($raw, $pos, 1)));
    $pos += 1;

    while(1) {
        last unless length($raw) >= $pos + 1;
        my $length = unpack(C => substr($raw, $pos, 1));
        $pos += 1;

        say "Record length: ", $length;

        last unless length($raw) >= $pos + $length;
        my $record = substr($raw, $pos, $length);
        push(@return, $record);
        $pos += $length;
    }

    return @return;
}

sub compose_message {
    my ($version, @contents) = @_;
    my $buf;

    die "version must be <= 255" unless $version <= 255;
    $buf .= pack('C', $version);

    foreach my $record (@contents) {
        $buf .= pack('C', length($record));
        $buf .= $record;
    }

    return $buf;
}

1;
