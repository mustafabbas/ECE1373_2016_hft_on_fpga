#ifndef FAST_DECODER_H
#define FAST_DECODER_H

#include "fast_protocol.h"

#define STRING_SIZE			10

#define pow(x,y)  exp(y*log(x))

class Fast_Decoder
{

public:

    static void decode_fast_message(uint64 & first_packet,
                                    uint64 & second_packet,
                                    order & decoded_message);

private:

    // Field Decoders
    static void decode_decimal_to_fix16(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                        unsigned & message_offset,
                                        fix16 & decoded_fix16);

    static void decode_uint_to_uint32(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                      unsigned & message_offset,
                                      uint32 & decoded_uint32);

    static void decode_uint_to_uint8(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                     unsigned & message_offset,
                                     uint8 & decoded_uint8);

    static void decode_uint_to_uint2(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                     unsigned message_offset,
                                     uint3 & decoded_uint2);

};

#endif
