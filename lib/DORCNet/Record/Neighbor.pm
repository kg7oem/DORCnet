package DORCNet::Record::Neighbor;

use Moo;
use bytes;
use v5.10;

use Net::IPAddress qw(ip2num num2ip);
use IPv6::Address;

use DORCNet::Record;

use constant IPV4_FLAG => (1<<0);
use constant IPV6_FLAG => (1<<1);
use constant DIGIPEAT_FLAG => (1<<2);
use constant VC_FLAG => (1<<3);

has _raw => (
    is => 'ro',
    predicate => 1,
);

has flags => (
    is => 'ro',
    builder => 1,
    lazy => 1,
);

has ipv4 => (
    is => 'ro',
    builder => 1,
    lazy => 1,
);

has ipv6 => (
    is => 'ro',
    builder => 1,
    lazy => 1,
);

has description => (
    is => 'ro',
    builder => 1,
    lazy => 1,
);

sub _build_flags {
    my ($self) = @_;
    die "no data to parse" unless $self->_has_raw;
    return unpack('C', $self->_raw);
}

sub _build_description {
    my ($self) = @_;

    die "no data to parse" unless $self->_has_raw;

    my $offset = 1;
    my $flags = $self->flags;

    $offset += 4 if $flags & IPV4_FLAG;
    $offset += 16 if $flags & IPV6_FLAG;

    return substr($self->_raw, $offset);
}

sub _build_ipv4 {
    my ($self) = @_;
    die "no data to parse" unless $self->_has_raw;
    return undef unless $self->flags & IPV4_FLAG;
    my $buf = substr($self->_raw, 1, 4);
    return num2ip(unpack('N', $buf));
}

sub _build_ipv6 {
    my ($self) = @_;
    die "no data to parse" unless $self->_has_raw;
    return undef unless $self->flags & IPV6_FLAG;
    my $offset = 1;

    $offset += 4 if $self->flags & IPV4_FLAG;
    my $buf = substr($self->_raw, $offset, 16);
    my $ipv6 = IPv6::Address->raw_new($buf, 0);
    return $ipv6->addr_string;
}

sub compose {
    my ($self) = @_;
    my $buf;

    die "no flags" unless defined $self->flags;

    $buf .= pack(C => $self->record_number);
    $buf .= pack(C => $self->flags);

    if ($self->flags & IPV4_FLAG) {
        die "no IPv4 address" unless defined $self->ipv4;
        $buf .= ip2num($self->ipv4);
    }

    if ($self->flags & IPV6_FLAG) {
        die "no IPv6 address" unless defined $self->ipv6;
    }

    if (defined $self->description) {
        $buf .= $self->description;
    }

    return $buf;
}

sub record_number {
    return NEIGHBOR_RECORD_NUM;
}

1;
