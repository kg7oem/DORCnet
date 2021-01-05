package DORCNet;

use strict;
use warnings;

use base 'Exporter';

our @VERSION = '0.0.1';
our @EXPORT_OK = qw(DORCIP_NUM DORCIP_AX25_ADDR);

# DORCNet values
use constant DORCIP_NUM => 253; # RFC3692 for now
use constant DORCIP_AX25_ADDR => 'DORCIP';

# netrom values used for testing
# use constant DORCIP_NUM => 0xcf;
# use constant DORCIP_AX25_ADDR => 'NODES';

1;
