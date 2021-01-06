#define PERL_NO_GET_CONTEXT // we'll define thread context if necessary (faster)
#include "EXTERN.h"         // globals/constant import locations
#include "perl.h"           // Perl symbols, structures and constants definition
#include "XSUB.h"           // xsubpp functions and macros

#include <net/ethernet.h>
#include <netax25/ax25.h>
#include <netax25/axlib.h>
#include <netax25/axconfig.h>
#include <sys/socket.h>
#include <pthread.h>

#include "AX25.h"

MODULE = Net::AX25  PACKAGE = Net::AX25
PROTOTYPES: ENABLE

int
_AF_AX25()
CODE:
    RETVAL = AF_AX25;
OUTPUT:
    RETVAL

int
_ETH_P_AX25()
CODE:
    RETVAL = htons(ETH_P_AX25);
OUTPUT:
    RETVAL

int
_PF_PACKET()
CODE:
    RETVAL = PF_PACKET;
OUTPUT:
    RETVAL

int
_SOL_AX25()
CODE:
    RETVAL = SOL_AX25;
OUTPUT:
    RETVAL

int _SOCK_PACKET()
CODE:
    RETVAL = SOCK_PACKET;
OUTPUT:
    RETVAL

int
_bind(int sockfd, const char * address)
CODE:
    static __thread struct full_sockaddr_ax25 sockaddr;

    memset(&sockaddr, 0, sizeof(struct full_sockaddr_ax25));
    sockaddr.fsa_ax25.sax25_family = AF_AX25;

    if (ax25_aton(address, &sockaddr) == -1) {
        errno = EINVAL;
        RETVAL = -1;
        goto DONE;
    }

    RETVAL = bind(sockfd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));

    DONE:
OUTPUT:
    RETVAL

int _connect(int sockfd, const char * address)
CODE:
    static __thread struct full_sockaddr_ax25 sockaddr;

    memset(&sockaddr, 0, sizeof(struct full_sockaddr_ax25));
    sockaddr.fsa_ax25.sax25_family = AF_AX25;

    if (ax25_aton(address, &sockaddr) == -1) {
        errno = EINVAL;
        RETVAL = -1;
        goto DONE;
    }

    RETVAL = connect(sockfd, (struct sockaddr *)&sockaddr, sizeof(sockaddr));

    DONE:
OUTPUT:
    RETVAL

const char *
_from_addr(const char * ax25_pkt, size_t len)
CODE:
    static __thread ax25_address addr;

    if (len < AX25_FROM_ADDR_OFFSET + sizeof(ax25_address)) {
        RETVAL = NULL;
        goto DONE;
    }

    memcpy(&addr, ax25_pkt + AX25_FROM_ADDR_OFFSET, sizeof(ax25_address));
    addr.ax25_call[6] &= AX25_ADDR_SSID_MASK;

    RETVAL = ax25_ntoa(&addr);

    DONE:
OUTPUT:
    RETVAL

const char *
_info_field(const char * packet, size_t len)
CODE:
    static __thread char buf[BUFSIZ];
    const char * start_p = packet + AX25_INFO_FIELD_OFFSET;
    size_t copy_bytes = len - AX25_FCS_FIELD_OFFSET;

    if (copy_bytes > BUFSIZ) {
        errno = ENOBUFS;
        RETVAL = NULL;
        goto DONE;
    }

    memset(buf, 0, BUFSIZ);
    memcpy(buf, start_p, copy_bytes);

    RETVAL = buf;

    DONE:
OUTPUT:
    RETVAL

const char *
_int_name(const char * address, size_t len)
CODE:
    static __thread char buf[AX25_INT_NAME_LEN + 1];

    if (len > AX25_INT_NAME_LEN) {
        len = AX25_INT_NAME_LEN;
    }

    memset(buf, 0, AX25_INT_NAME_LEN + 1);
    memcpy(buf, address, len);

    RETVAL = buf;
OUTPUT:
    RETVAL

int
_is_i_frame(const char * buf, size_t len)
CODE:
    char control = buf[AX25_CONTROL_FIELD_OFFSET];

    if (len < AX25_CONTROL_FIELD_OFFSET) {
        RETVAL = 0;
        goto DONE;
    }

    control &= AX25_I_FRAME_MASK;
    RETVAL = control == AX25_I_FRAME_VALUE;

    DONE:
OUTPUT:
    RETVAL

int
_is_s_frame(const char * buf, size_t len)
CODE:
    char control = buf[AX25_CONTROL_FIELD_OFFSET];

    if (len < AX25_CONTROL_FIELD_OFFSET) {
        RETVAL = 0;
        goto DONE;
    }

    control &= AX25_S_FRAME_MASK;
    RETVAL = control == AX25_S_FRAME_VALUE;

    DONE:
OUTPUT:
    RETVAL

int
_is_u_frame(const char * buf, size_t len)
CODE:
    char control = buf[AX25_CONTROL_FIELD_OFFSET];

    if (len < AX25_CONTROL_FIELD_OFFSET) {
        RETVAL = 0;
        goto DONE;
    }

    control &= AX25_U_FRAME_MASK;
    RETVAL = control == AX25_U_FRAME_VALUE;

    DONE:
OUTPUT:
    RETVAL

int
_is_ui_frame(const char * buf, size_t len)
CODE:
    char control = buf[AX25_CONTROL_FIELD_OFFSET];

    if (len < AX25_CONTROL_FIELD_OFFSET) {
        RETVAL = 0;
        goto DONE;
    }

    control &= AX25_UI_FRAME_MASK;
    RETVAL = control == AX25_UI_FRAME_VALUE;

    DONE:
OUTPUT:
    RETVAL

unsigned int
_pid_field(const char * buf, size_t len)
CODE:

    if (len < AX25_PID_FIELD_OFFSET) {
        RETVAL = 0;
        goto DONE;
    }

    RETVAL = (uint8_t)buf[AX25_PID_FIELD_OFFSET];

    DONE:
OUTPUT:
    RETVAL

const char *
_to_addr(const char * buf, size_t len)
CODE:
    static __thread ax25_address addr;

    if (len < AX25_TO_ADDR_OFFSET + sizeof(ax25_address)) {
        RETVAL = NULL;
        goto DONE;
    }

    memcpy(&addr, buf + AX25_TO_ADDR_OFFSET, sizeof(ax25_address));
    addr.ax25_call[6] &= AX25_ADDR_SSID_MASK;

    RETVAL = ax25_ntoa(&addr);

    DONE:
OUTPUT:
    RETVAL
