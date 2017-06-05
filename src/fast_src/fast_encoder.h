#ifndef FAST_ENCODER_H
#define FAST_ENCODER_H

#include "fast_protocol.h"

// max precision needed for encoding mantissa for a fixed<16,8> decimal
#define MANTISSA_SIZE				35
#define MANTISSA_NUM_ENCODING_BYTES	MANTISSA_SIZE/7
typedef ap_int<MANTISSA_SIZE> mantissa_t;

class Fast_Encoder
{

public:

    static void encode_fast_message(order & decoded_message,
                                    uint64 & first_packet,
                                    uint64 & second_packet);

private:

    // Field Encoders
    static void encode_decimal_from_fix16(fix16 & decoded_fix16,
                                          unsigned exponent_offset,
                                          unsigned & mantissa_offset,
                                          uint8 encoded_message[MESSAGE_BUFF_SIZE]);

    static void encode_signed_int(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                  unsigned & mantissa_offset,
                                  mantissa_t mantissa);

    static void encode_uint_from_uint32(uint32 & decoded_uint32,
                                        unsigned & message_offset,
                                        uint8 encoded_message[MESSAGE_BUFF_SIZE]);

    static void encode_uint_from_uint8(uint8 & decoded_uint8,
                                       unsigned & message_offset,
                                       uint8 encoded_message[MESSAGE_BUFF_SIZE]);

    static void encode_uint_from_uint2(uint3 & decoded_uint2,
                                       unsigned & message_offset,
                                       uint8 encoded_message[MESSAGE_BUFF_SIZE]);

};

#endif
