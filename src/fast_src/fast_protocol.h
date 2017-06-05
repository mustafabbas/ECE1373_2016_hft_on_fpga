#ifndef FAST_PROTOCOL_H
#define FAST_PROTOCOL_H

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include <hls_stream.h>
#include "ap_int.h"
#include <stdint.h>

using namespace hls;

//////////////////////////
// Networking interface //
//////////////////////////

const uint16_t REQUEST = 0x0100;
const uint16_t REPLY = 0x0200;
const ap_uint<32> replyTimeOut = 65536;

const ap_uint<48> MY_MAC_ADDR = 0xE59D02350A00;  // LSB first, 00:0A:35:02:9D:E5
const ap_uint<48> BROADCAST_MAC = 0xFFFFFFFFFFFF;   // Broadcast MAC Address

const uint8_t noOfArpTableEntries = 8;

struct axiWord
{
    ap_uint<64> data;
    ap_uint<8> keep;
    ap_uint<1> last;
};

struct sockaddr_in
{
    ap_uint<16> port;   // port in network byte order
    ap_uint<32> addr;   // Internet address
};

struct metadata
{
    sockaddr_in sourceSocket;
    sockaddr_in destinationSocket;
};

////////////////////////////////
// Encoder/ Decoder Interface //
////////////////////////////////

/* Using our market template a maximum message is of size 16-bytes containing:
 * - Pcap: 1-bytes
 * - template_ID: 1-byte
 * - Field 1: 6-bytes for price (16-bit fixed decimal)
 * - Field 2: 2-bytes for size (8-bit unsigned integer)
 * - Field 3: 5-bytes for orderID (32-bit unsigned integer)
 * - Field 4: 1-byte for type (2-bit value)
 *
 * Using our market template a minimum message is of size 7-bytes containing
 * one byte of data for each of the message fields noted above except for
 * the decimal which requires at a minimum 2-bytes, one for the exponent and one
 * for the mantissa.
 */
#define MESSAGE_BUFF_SIZE   16  // size in bytes

#define NUMBER_OF_FIELDS    6   // all fields are mandatory
// decimal mantissa and exponent count as
// Separate fields

// Order of fields
#define PRICE_FIELD_EXP_NUM     0
#define PRICE_FIELD_MAN_NUM     1
#define SIZE_FIELD_NUM          2
#define ORDER_ID_FIELD_NUM      3
#define TYPE_FIELD_NUM          4

// Needed for stream buffering
#define PACKET_SIZE         64
#define NUM_BYTES_IN_PACKET PACKET_SIZE/8
#define BYTE                8

// Data types
typedef ap_fixed<16, 8> fix16;  // 16-bit fixed point with 8 fractional bits
typedef ap_uint<1> bit;         // 1-bit of data
typedef ap_uint<3> uint3;       // 2-bits of data
typedef ap_uint<8> uint8;       // 1-byte of data
typedef ap_uint<32> uint32;     // 4-bytes of data
typedef ap_uint<64> uint64;     // 8-bytes of data
typedef ap_uint<16> uint16;

/* Struct representing a market order, grouped data includes:
 * - the ask or bid "price" of the order
 * - the "size", i.e. the number of shares
 * - the "orderID" unique id tag for each order
 * - the "order_type" (0 for market sell, 1 for market buy,
 *                     2 for limited sell, and 3 for limited buy)
 */
struct order
{
    ap_fixed<16, 8> price;
    ap_uint<8> size;
    ap_uint<32> orderID;
    ap_uint<3> type;
};

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
                   stream<order> &order_from_book);
#endif
