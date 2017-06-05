#include "fast_decoder.h"

#define STOP_BIT 	0x80
#define VALID_DATA	0x7F
#define SIGN_BIT	0x40

#define NUMBER_OF_VALID_BITS_IN_BYTE	7

void Fast_Decoder::decode_fast_message(uint64 & first_packet,
                                       uint64 & second_packet,
                                       order & decoded_message)
{

    uint8 encoded_message[MESSAGE_BUFF_SIZE] = { 0. };
#pragma HLS ARRAY_PARTITION variable=encoded_message complete dim=1

    for (unsigned i = 0; i < NUM_BYTES_IN_PACKET; i++)
    {
        encoded_message[i] = first_packet >> (BYTE * i);
        encoded_message[i + NUM_BYTES_IN_PACKET] = second_packet >> (BYTE * i);
    }

    fix16 price_buff = 0;
    uint8 size_buff = 0;
    uint32 orderID_buff = 0;
    uint3 order_type_buff = 0;

    unsigned message_offset = 2;

    /*
     * Decode Price Field
     */

    // Decode Exponent
    ap_int<7> decoded_exponent = (encoded_message[message_offset++] & 0x7F);

    // Decode Mantissa Field
    ap_uint<21> decoded_mantissa = 0;

    // Extract first byte from the message buffer if stop bit is not encountered
    if ((encoded_message[message_offset] & STOP_BIT) != STOP_BIT)
    {
        decoded_mantissa = (decoded_mantissa << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    if ((encoded_message[message_offset] & STOP_BIT) != STOP_BIT)
    {
        decoded_mantissa = (decoded_mantissa << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    decoded_mantissa = (decoded_mantissa << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

    float powers_of_ten[4] = { 1, 0.1, 0.01, 0.001};
    price_buff = decoded_mantissa * (powers_of_ten[(-1 * decoded_exponent)]);

    //std::cout << decoded_mantissa << "*10^" << decoded_exponent << std::endl;

    /*
     * Decode Size Field
     */

    // Extract first byte from the message buffer if stop bit is not encountered
    if ((encoded_message[message_offset] & STOP_BIT) != STOP_BIT)
    {
        size_buff = (size_buff << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    size_buff = (size_buff << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

    /*
     * Decode Order ID Field
     */

    // Extract bytes from the message buffer until stop bit is encountered
    for (unsigned i = 0; i < 4; i++)
    {
        if ((encoded_message[message_offset] & STOP_BIT) == STOP_BIT)
        {
            break;
        }
        orderID_buff = (orderID_buff << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    orderID_buff = (orderID_buff << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

    /*
     * Decode type Field
     */

    order_type_buff = (encoded_message[message_offset] & VALID_DATA);

    decoded_message.price = price_buff;
    decoded_message.size = size_buff;
    decoded_message.orderID = orderID_buff;
    decoded_message.type = order_type_buff;

}

/*
 * decimal numbers are represented by two signed integers, an exponent and mantissa.
 * The numerical value of a decimal data type is obtained by extracting the
 * encoded signed integer exponent followed by the signed integer mantissa values
 * from the encoded message and multiplying the mantissa by base 10 power of the exponent.
 * Above explanation from: http://www.jettekfix.com/fast_tutorial
 */
void Fast_Decoder::decode_decimal_to_fix16(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                           unsigned & message_offset,
                                           fix16 & decoded_fix16)
{
    float powers_of_ten[8] = { 0.1,
                               0.01,
                               0.001,
                               0.0001,
                               0.00001,
                               0.000001,
                               0.0000001,
                               0.00000001 };
    /*
     * Decode Exponent Field
     */
    int decoded_exponent = 0;

    // check if field is negative
    if ((encoded_message[message_offset] & SIGN_BIT) == SIGN_BIT)
    {
        decoded_exponent = -1;
    }

    // Extract bytes from the message buffer until stop bit is encountered
    for (unsigned i = 0; i < 2; i++)
    {
        if ((encoded_message[message_offset] & STOP_BIT) == STOP_BIT)
        {
            break;
        }
        decoded_exponent = (decoded_exponent << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    decoded_exponent = (decoded_exponent << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

    /*
     * Decode Mantissa Field
     */
    long int decoded_mantissa = 0;

    // check if field is negative
    if ((encoded_message[message_offset] & SIGN_BIT) == SIGN_BIT)
    {
        decoded_mantissa = -1;
    }

    // Extract bytes from the message buffer until stop bit is encountered
    for (unsigned i = 0; i < 6; i++)
    {
        if ((encoded_message[message_offset] & STOP_BIT) == STOP_BIT)
        {
            break;
        }
        decoded_mantissa = (decoded_mantissa << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    decoded_mantissa = (decoded_mantissa << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

    //cout << decoded_mantissa << "*10^" << decoded_exponent << endl;

    if (decoded_exponent < 0)
    {
        decoded_fix16 = decoded_mantissa
                * (powers_of_ten[(-1 * decoded_exponent) - 1]);
    }
    else
    {
        decoded_fix16 = decoded_mantissa;
    }

}

/*
 * Integers are represented as stop bit encoded entities.
 * The stop bit decoding process of integer fields is:
 * Determine the length by the stop bit algorithm.
 * Remove stop bit from each byte.
 * Combine 7-bit words (without stop bits) to determine actual integer.
 * Above explanation from: http://www.jettekfix.com/fast_tutorial
 */
void Fast_Decoder::decode_uint_to_uint8(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                        unsigned & message_offset,
                                        uint8 & decoded_uint8)
{
    // Extract bytes from the message buffer until stop bit is encountered
    for (unsigned i = 0; i < 2; i++)
    {
        if ((encoded_message[message_offset] & STOP_BIT) == STOP_BIT)
        {
            break;
        }
        decoded_uint8 = (decoded_uint8 << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    decoded_uint8 = (decoded_uint8 << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);
}

void Fast_Decoder::decode_uint_to_uint32(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                         unsigned & message_offset,
                                         uint32 & decoded_uint32)
{

    // Extract bytes from the message buffer until stop bit is encountered
    for (unsigned i = 0; i < 5; i++)
    {
        if ((encoded_message[message_offset] & STOP_BIT) == STOP_BIT)
        {
            break;
        }
        decoded_uint32 = (decoded_uint32 << NUMBER_OF_VALID_BITS_IN_BYTE)
                | (encoded_message[message_offset++]);
    }

    // Extract last byte of data
    decoded_uint32 = (decoded_uint32 << NUMBER_OF_VALID_BITS_IN_BYTE)
            | (encoded_message[message_offset++] & VALID_DATA);

}

void Fast_Decoder::decode_uint_to_uint2(uint8 encoded_message[MESSAGE_BUFF_SIZE],
                                        unsigned message_offset,
                                        uint3 & decoded_uint2)
{
    decoded_uint2 = (encoded_message[message_offset] & VALID_DATA);
}

