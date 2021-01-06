DORCNet Protocol Specification - Work In Progress

# Message format

* Each message starts with an 8 bit protocol version number.
* The rest of the message is tuples of record lengths and variable length records.
* The record length is specified as an 8 bit number.
* Each record always starts with an 8 bit record type.

# Record types

## 0 Reserved

This record type is reserved for future use.

## 1 Neighbor

Information the node provides about itself so the rest of the network will know about it.

* 1 byte flags: 0 has IPv4 address, 1 has IPv6 address, 2 will digipeat, 3 will do virtual circuits
* 4 bytes for IPv4 address if present
* 16 bytes for IPv6 address if present
* UTF-8 human readable arbitrary node description string, max 100 bytes, not NULL terminated
