#define AX25_INT_NAME_LEN 14

#define AX25_ADDR_SSID_MASK (1<<4) | (1<<3) | (1<<2) | (1<<1);
#define AX25_TO_ADDR_OFFSET 1
#define AX25_FROM_ADDR_OFFSET 8

#define AX25_CONTROL_FIELD_OFFSET 15
#define AX25_I_FRAME_MASK (1<<0)
#define AX25_I_FRAME_VALUE 0
#define AX25_S_FRAME_MASK (1<<1) | (1<<0)
#define AX25_S_FRAME_VALUE 1
#define AX25_U_FRAME_MASK (1<<1) | (1<<0)
#define AX25_U_FRAME_VALUE 3
#define AX25_UI_FRAME_MASK (1<<7) | (1<<6) | (1<<5) | (1<<3) | (1<<2) | (1<<1) | (1<<0)
#define AX25_UI_FRAME_VALUE 3

#define AX25_PID_FIELD_OFFSET 16