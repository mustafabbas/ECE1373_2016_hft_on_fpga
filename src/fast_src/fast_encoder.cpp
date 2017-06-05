#include "fast_encoder.h"

#define STOP_BIT 	0x80
#define VALID_DATA	0x7F
#define SIGN_BIT	0x40

#define NUMBER_OF_VALID_BITS_IN_BYTE	7

#define pow(x,y)  exp(y*log(x))

#define PRICE_FIELD_EXP_NUM		0
#define PRICE_FIELD_MAN_NUM		1
#define SIZE_FIELD_NUM			2
#define ORDER_ID_FIELD_NUM		3
#define TYPE_FIELD_NUM			4

void Fast_Encoder::encode_fast_message(order & decoded_message,
                                       uint64 & first_packet,
                                       uint64 & second_packet)
{

    ap_uint<8> encoded_message[MESSAGE_BUFF_SIZE] = { 0. };
#pragma HLS ARRAY_PARTITION variable=encoded_message complete dim=1

    encoded_message[0] = 0xFC; // Presence map: all fields are present.
    encoded_message[1] = 0x81; // template id = 1
    encoded_message[2] = 0x80; // exponent is always 0
    encoded_message[3] = 0x81; //price is always 1

    unsigned message_offset = 4;
    if ((decoded_message.size & 0x80) == 0x80)
    {
        encoded_message[message_offset++] = 0x01;
    }

    encoded_message[message_offset++] = (0x80 | (decoded_message.size & 0x7F));

//    Fast_Encoder::encode_uint_from_uint8(decoded_message.size,
//                                         message_offset,
//                                         encoded_message);
    bool triggered = false; //triggered

    unsigned max_bytes_need_for_uint32 = 5;
    for (unsigned i = 0; i < max_bytes_need_for_uint32 - 1; i++)
    {
        uint8 curr_byte = (0x00
                | (decoded_message.orderID
                        >> NUMBER_OF_VALID_BITS_IN_BYTE
                                * (max_bytes_need_for_uint32 - 1 - i) & 0x7F));
        if (curr_byte != 0x00 || triggered == true)
        {
            encoded_message[message_offset++] = (0x00
                    | (decoded_message.orderID
                            >> NUMBER_OF_VALID_BITS_IN_BYTE
                                            * (max_bytes_need_for_uint32 - 1 - i)
                                    & 0x7F));
            triggered = true;
        }
    }

    encoded_message[message_offset++] = (0x80 | (decoded_message.orderID & 0x7F));
//    Fast_Encoder::encode_uint_from_uint32(decoded_message.orderID,
//                                          message_offset,
//                                          encoded_message);
    encoded_message[message_offset++] = (0x80 | decoded_message.type);
//    Fast_Encoder::encode_uint_from_uint2(decoded_message.type,
//                                         message_offset,
//                                         encoded_message);

    for (int i = NUM_BYTES_IN_PACKET - 1; i >= 0; i--)
    {
        first_packet = (first_packet << BYTE)
                | encoded_message[i];
        second_packet = (second_packet << BYTE)
                | encoded_message[i + NUM_BYTES_IN_PACKET];
    }

}

void Fast_Encoder::encode_decimal_from_fix16(fix16 & decoded_fix16,
                                             unsigned exponent_offset,
                                             unsigned & mantissa_offset,
                                             uint8 encoded_message[MESSAGE_BUFF_SIZE])
{
    // encode exponent
    encoded_message[exponent_offset] = 0xF8; // exponent is always -8

    // encode mantissa
    mantissa_t mantissa = (float) decoded_fix16 * pow(10, 8);
    encode_signed_int(encoded_message, mantissa_offset, mantissa);
}

void Fast_Encoder::encode_signed_int(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                     unsigned & mantissa_offset,
                                     mantissa_t mantissa)
{
    for (unsigned i = 0; i < MANTISSA_NUM_ENCODING_BYTES - 1; i++)
    {
        encoded_message[mantissa_offset++] = (0x00
                | (mantissa
                        >> NUMBER_OF_VALID_BITS_IN_BYTE
                                * (MANTISSA_NUM_ENCODING_BYTES - 1 - i) & 0x7F));
    }

    encoded_message[mantissa_offset++] = (0x80 | (mantissa & 0x7F));
}

void Fast_Encoder::encode_uint_from_uint32(uint32 & decoded_uint32,
                                           unsigned & message_offset,
                                           uint8 encoded_message[MESSAGE_BUFF_SIZE])
{
    bool triggered = false; //triggered

    unsigned max_bytes_need_for_uint32 = 5;
    for (unsigned i = 0; i < max_bytes_need_for_uint32 - 1; i++)
    {
        uint8 curr_byte = (0x00
                | (decoded_uint32
                        >> NUMBER_OF_VALID_BITS_IN_BYTE
                                * (max_bytes_need_for_uint32 - 1 - i) & 0x7F));
        if (curr_byte != 0x00 || triggered == true)
        {
            encoded_message[message_offset++] = (0x00
                    | (decoded_uint32
                            >> NUMBER_OF_VALID_BITS_IN_BYTE
                                            * (max_bytes_need_for_uint32 - 1 - i)
                                    & 0x7F));
            triggered = true;
        }
    }

    encoded_message[message_offset++] = (0x80 | (decoded_uint32 & 0x7F));

}

void Fast_Encoder::encode_uint_from_uint8(uint8 & decoded_uint8,
                                          unsigned & message_offset,
                                          uint8 encoded_message[MESSAGE_BUFF_SIZE])
{
    if ((decoded_uint8 & 0x80) == 0x80)
    {
        encoded_message[message_offset++] = 0x01;
    }

    encoded_message[message_offset++] = (0x80 | (decoded_uint8 & 0x7F));
}

void Fast_Encoder::encode_uint_from_uint2(uint3 & decoded_uint2,
                                          unsigned & message_offset,
                                          uint8 encoded_message[MESSAGE_BUFF_SIZE])
{
    encoded_message[message_offset++] = (0x80 | decoded_uint2);
}
