Digital Oddballs Radio Club Experimental Radio Network

This is an experiment with improving the useability of AX.25 and TCP/IP on top
of AX.25 especially for the case of mesh networking with 1200 baud Ham Radio packet
stations.

# Observations

* ARP is extremely painful for packet radio networks.
* The default Linux TCP/IP RTT values are nearly entirely unworkable for 1200 baud packet radio links.
* MTUs vary greatly in the real world and very low performance packet fragmentation is far too common.
* RIP does not provide all the information that would be useful for the packet network such as RTT and MTU values.
* TCP/IP deployment has not become prevelant enough it can be relied on for communication in an adhoc/free for all packet network.

# Principles

* Use any node that can digipeat for routing TCP/IP packets in the abscence of layer 3 routes.
* Minimize query/response broadcast traffic especially ARP.
* Support but do not require IPv4 and IPv6.
* Keep the protocol light and tight so the overhead is low.
