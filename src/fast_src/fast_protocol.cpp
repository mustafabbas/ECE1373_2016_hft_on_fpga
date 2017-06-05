#include "fast_protocol.h"
#include "fast_decoder.h"
#include "fast_encoder.h"

#define PORT 641

#define STOP_BIT    0x80
#define VALID_DATA  0x7F
#define SIGN_BIT    0x40

#define NUMBER_OF_VALID_BITS_IN_BYTE    7

#define pow(x,y)  exp(y*log(x))

#define PRICE_FIELD_EXP_NUM     0
#define PRICE_FIELD_MAN_NUM     1
#define SIZE_FIELD_NUM          2
#define ORDER_ID_FIELD_NUM      3
#define TYPE_FIELD_NUM          4

void rxPath(stream<axiWord>& lbRxDataIn,
            stream<metadata>& lbRxMetadataIn,
            stream<ap_uint<16> >& lbRequestPortOpenOut,
            stream<bool>& lbPortOpenReplyIn,
            stream<metadata> &metadata_to_book,
            stream<ap_uint<64> > &tagsIn,
            stream<ap_uint<64> > &time_to_book,
            stream<order> & order_to_book)
{
#pragma HLS PIPELINE II=1

    static enum Rx_State
    {
        PORT_OPEN = 0, PORT_REPLY, READ_FIRST, READ_SECOND, WRITE, FUNC, FUNC_2
    } next_state;

    static ap_uint<32> openPortWaitTime = 100;
    static ap_uint<8> encoded_message[MESSAGE_BUFF_SIZE] = { 0. };
    static order temp_order = { 0, 0, 0, 0 };
#pragma HLS ARRAY_PARTITION variable=encoded_message complete dim=1

    static ap_uint<64> first_packet = 0;
    static ap_uint<64> second_packet = 0;

    switch (next_state)
    {
    case PORT_OPEN:
        if (!lbRequestPortOpenOut.full() && openPortWaitTime == 0)
        {
            lbRequestPortOpenOut.write(PORT);
            next_state = PORT_REPLY;
        }
        else
        {
            openPortWaitTime--;
        }
        break;
    case PORT_REPLY:
        if (!lbPortOpenReplyIn.empty())
        {
            bool openPort = lbPortOpenReplyIn.read();
            next_state = READ_FIRST;
        }
        break;
    case READ_FIRST:
        // Wait until data has arrived and output streams are ready for new input
        if (!lbRxDataIn.empty() && !lbRxMetadataIn.empty()
                && !metadata_to_book.full() && !tagsIn.empty()
                && !time_to_book.full())
        {
            // Pass-through for time
            time_to_book.write(tagsIn.read());

            // Switch the source and destination port for the metadata
            // and implement a pass-through for it.
            metadata tempMetadata = lbRxMetadataIn.read();
            sockaddr_in tempSocket = tempMetadata.sourceSocket;
            tempMetadata.sourceSocket = tempMetadata.destinationSocket;
            tempMetadata.destinationSocket = tempSocket;
            metadata_to_book.write(tempMetadata);

            // Buffer input packet for later use by the decoder
            // Ideally there are two 64-bit packets that make up a
            // 128-bit encoded message
            axiWord tempWord = lbRxDataIn.read();

            first_packet = tempWord.data;

            if (!tempWord.last)
            {
                // If more than once packet was sent read the next packet
                next_state = READ_SECOND;
            }
            else
            {
                // If only once packet is set then perform the decoding
                next_state = FUNC;
            }
        }
        break;
    case FUNC:
        if (true)
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

            temp_order.price = price_buff;
            temp_order.size = size_buff;
            temp_order.orderID = orderID_buff;
            temp_order.type = order_type_buff;
            next_state = WRITE;
        }
        break;
    case READ_SECOND:
        // Wait until next packet has arrived and output stream is ready
        if (!lbRxDataIn.empty())
        {
            // Buffer in second input packet for use by the decoder
            axiWord tempWord = lbRxDataIn.read();

            second_packet = tempWord.data;

            if (tempWord.last)
            {
                // If the packet received is the last then perform the decoding

                next_state = FUNC_2;
            }
        }
        break;
    case FUNC_2:
        if (true)
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

            temp_order.price = price_buff;
            temp_order.size = size_buff;
            temp_order.orderID = orderID_buff;
            temp_order.type = order_type_buff;
            next_state = WRITE;
        }
        break;
    case WRITE:
        if (!order_to_book.full())
        {
            order_to_book.write(temp_order);
            next_state = READ_FIRST;
        }
        break;
    }
}

void txPath(stream<metadata> &metadata_from_book,
            stream<axiWord> &lbTxDataOut,
            stream<metadata> &lbTxMetadataOut,
            stream<ap_uint<16> > &lbTxLengthOut,
            stream<ap_uint<64> > &time_from_book,
            stream<ap_uint<64> > &tagsOut,
            stream<order> & order_from_book)
{
#pragma HLS PIPELINE II=1

    static enum Tx_State
    {
        READ = 0, WRITE_FIRST, WRITE_SECOND
    } next_state;

    static uint16_t lbPacketLength = 0;
    // Buffer the 128-bit encoded message in two 64-bit packets
    static axiWord second_packet = { 0, 0xFF, 1 };
    static axiWord first_packet = { 0, 0xFF, 0 };

    switch (next_state)
    {
    case READ:
        // Wait until data has arrived and output streams are ready for new input
        if (!metadata_from_book.empty() && !time_from_book.empty()
                && !order_from_book.empty() && !lbTxMetadataOut.full()
                && !lbTxLengthOut.full() && !tagsOut.full())
        {
            // Pass-through for time and metadata
            tagsOut.write(time_from_book.read());
            lbTxMetadataOut.write(metadata_from_book.read());

            // Run the encoder
            order decoded_message = order_from_book.read();
            ap_uint<64> first_packet_data;
            ap_uint<64> second_packet_data;
            std::cout << "here" << std::endl;

            ///////////////////////
            //// ENCODER Start ////
            ///////////////////////
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

            encoded_message[message_offset++] = (0x80 | decoded_message.type);

            for (int i = NUM_BYTES_IN_PACKET - 1; i >= 0; i--)
            {
                first_packet_data = (first_packet_data << BYTE)
                        | encoded_message[i];
                second_packet_data = (second_packet_data << BYTE)
                        | encoded_message[i + NUM_BYTES_IN_PACKET];
            }

            ///////////////////////
            //// ENCODER End //////
            ///////////////////////

            std::cout << "here2" << std::endl;

            // Buffer the 128-bit encoded message in two 64-bit packets
            first_packet.data = first_packet_data;
            second_packet.data = second_packet_data;

            next_state = WRITE_FIRST;
            std::cout << "here3" << std::endl;
        }
        break;
    case WRITE_FIRST:
        // Wait until data has arrived and output streams are ready for new input
        if (!lbTxDataOut.full())
        {
            //std::cout << "here3" << std::endl;
            // Write first packet
            lbTxDataOut.write(first_packet);

            // Count how many bytes kept.
            ap_uint<4> counter = 0;
            counter = (first_packet.keep & 128 >> 7)
                    + (first_packet.keep & 64 >> 6)
                    + (first_packet.keep & 32 >> 5)
                    + (first_packet.keep & 16 >> 4)
                    + (first_packet.keep & 8 >> 3)
                    + (first_packet.keep & 4 >> 2)
                    + (first_packet.keep & 2 >> 1) + (first_packet.keep & 1);
            lbPacketLength = counter;

            next_state = WRITE_SECOND;
        }
        break;
    case WRITE_SECOND:
        // Wait until output streams are ready for new input
        if (!lbTxDataOut.full() && !lbTxLengthOut.full())
        {
            // Write second packet
            lbTxDataOut.write(second_packet);

            // Count how many bytes kept.
            ap_uint<4> counter = 0;
            counter = (second_packet.keep & 128 >> 7)
                    + (second_packet.keep & 64 >> 6)
                    + (second_packet.keep & 32 >> 5)
                    + (second_packet.keep & 16 >> 4)
                    + (second_packet.keep & 8 >> 3)
                    + (second_packet.keep & 4 >> 2)
                    + (second_packet.keep & 2 >> 1) + (second_packet.keep & 1);
            lbPacketLength += counter;

            // Write out the length
            lbTxLengthOut.write(lbPacketLength);

            next_state = READ;
        }
        break;
    }
}

void fast_protocol(stream<axiWord>& lbRxDataIn,
                   stream<metadata>& lbRxMetadataIn,
                   stream<ap_uint<16> >& lbRequestPortOpenOut,
                   stream<bool>& lbPortOpenReplyIn,
                   stream<axiWord> &lbTxDataOut,
                   stream<metadata> &lbTxMetadataOut,
                   stream<ap_uint<16> > &lbTxLengthOut,
                   stream<ap_uint<64> > &tagsIn,
                   stream<ap_uint<64> > &tagsOut,
                   stream<metadata> &metadata_to_book,
                   stream<metadata> &metadata_from_book,
                   stream<ap_uint<64> > &time_to_book,
                   stream<ap_uint<64> > &time_from_book,
                   stream<order> &order_to_book,
                   stream<order> &order_from_book)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS DATAFLOW

#pragma HLS resource core=AXI4Stream variable=lbRxDataIn           metadata="-bus_bundle lbRxDataIn"
#pragma HLS resource core=AXI4Stream variable=lbRxMetadataIn       metadata="-bus_bundle lbRxMetadataIn"
#pragma HLS resource core=AXI4Stream variable=lbRequestPortOpenOut metadata="-bus_bundle lbRequestPortOpenOut"
#pragma HLS resource core=AXI4Stream variable=lbPortOpenReplyIn    metadata="-bus_bundle lbPortOpenReplyIn"
#pragma HLS resource core=AXI4Stream variable=lbTxDataOut          metadata="-bus_bundle lbTxDataOut"
#pragma HLS resource core=AXI4Stream variable=lbTxMetadataOut      metadata="-bus_bundle lbTxMetadataOut"
#pragma HLS resource core=AXI4Stream variable=lbTxLengthOut        metadata="-bus_bundle lbTxLengthOut"
#pragma HLS resource core=AXI4Stream variable=tagsIn               metadata="-bus_bundle tagsIn"
#pragma HLS resource core=AXI4Stream variable=tagsOut              metadata="-bus_bundle tagsOut"

#pragma HLS DATA_PACK variable=lbRxMetadataIn
#pragma HLS DATA_PACK variable=lbTxMetadataOut

#pragma HLS resource core=AXI4Stream variable=metadata_to_book    //metadata="-bus_bundle metadata_to_book"
#pragma HLS resource core=AXI4Stream variable=metadata_from_book   //metadata="-bus_bundle metadata_from_book"

#pragma HLS resource core=AXI4Stream variable=time_to_book        // metadata="-bus_bundle time_to_book"
#pragma HLS resource core=AXI4Stream variable=time_from_book      // metadata="-bus_bundle time_from_book"

#pragma HLS RESOURCE core=AXI4Stream variable=order_to_book
#pragma HLS RESOURCE core=AXI4Stream variable=order_from_book

#pragma HLS DATA_PACK variable=metadata_to_book
#pragma HLS DATA_PACK variable=metadata_from_book

#pragma HLS DATA_PACK variable=order_to_book      struct_level
#pragma HLS DATA_PACK variable=order_from_book    struct_level

    rxPath(lbRxDataIn,
           lbRxMetadataIn,
           lbRequestPortOpenOut,
           lbPortOpenReplyIn,
           metadata_to_book,
           tagsIn,
           time_to_book,
           order_to_book);

    txPath(metadata_from_book,
           lbTxDataOut,
           lbTxMetadataOut,
           lbTxLengthOut,
           time_from_book,
           tagsOut,
           order_from_book);
}
