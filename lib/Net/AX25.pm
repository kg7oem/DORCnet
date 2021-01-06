package Net::AX25;

use strict;
use warnings;
use XSLoader;

use Socket;

use base 'Exporter';

our @EXPORT_OK = qw(
    AF_AX25 ETH_P_AX25 PF_PACKET SOL_AX25
    SOCK_DGRAM SOCK_RAW SOCK_PACKET SOCK_SEQPACKET
    bind connect socket
    from_addr to_addr int_name
    is_i_frame is_ui_frame is_u_frame is_s_frame
    pid_field info_field
);

BEGIN {
    XSLoader::load();
}

use constant AF_AX25 => _AF_AX25();
use constant ETH_P_AX25 => _ETH_P_AX25();
use constant PF_PACKET => _PF_PACKET();
use constant SOCK_PACKET => _SOCK_PACKET();
use constant SOL_AX25 => _SOL_AX25();

sub bind {
    my ($sock, $address) = @_;

    if (ref($sock)) {
        $sock = fileno($sock);
    }

    return _bind($sock, $address);
}

sub connect {
    my ($sock, $address) = @_;

    if (ref($sock)) {
        $sock = fileno($sock);
    }

    return _connect($sock, $address);
}

sub from_addr {
    return _from_addr($_[0], length($_[0]));
}

sub info_field {
    return _info_field($_[0], length($_[0]));
}

sub int_name {
    return _int_name($_[0], length($_[0]));
}

sub is_i_frame {
    my ($packet) = @_;

    return _is_i_frame($_[0], length($_[0]));
}

sub is_s_frame {
    my ($packet) = @_;

    return _is_s_frame($_[0], length($_[0]));
}

sub is_ui_frame {
    my ($packet) = @_;

    return _is_ui_frame($_[0], length($_[0]));
}

sub is_u_frame {
    my ($packet) = @_;

    return _is_u_frame($_[0], length($_[0]));
}

sub pid_field {
    return _pid_field($_[0], length($_[0]));
}

sub send {
    my ($sock, $buf, $flags, $to) = @_;

    if (ref($sock)) {
        $sock = fileno($sock);
    }
    return _send($sock, $buf, length($buf), $flags, $to);
}

sub socket {
    my ($type, $protocol) = @_;

    $type = SOCK_SEQPACKET unless defined $type;
    $protocol = 0 unless defined $protocol;

    socket(my $sock, AF_AX25, $type, $protocol) or return undef;
    return $sock;
}

sub to_addr {
    return _to_addr($_[0], length($_[0]));
}

1;

__END__

=pod

=head1 SYNOPSIS

    socket(my $sock, AF_AX25, SOCK_SEQPACKET, 0) or die "socket(): $!";
    Net::AX25::bind($sock, "MYCALL-1") and die "bind(): $!";
    Net::AX25::connect($sock, "UCALL-1") and die "connect(): $!";

    socket(my $sock, PF_PACKET, SOCK_PACKET, ETH_P_AX25) or die "socket(): $!";
