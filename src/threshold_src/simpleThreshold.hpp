#include <cfloat>
#include <iostream>
#include <bitset>
#include <hls_stream.h>
#include "ap_int.h"

using namespace hls;

typedef ap_uint<64> Time;	/*Time stamp for round-trip latency measurements*/

struct sockaddr_in {
    ap_uint<16>     port;   /* port in network byte order */
    ap_uint<32>     addr;   /* internet address */
};

struct metadata {
    sockaddr_in sourceSocket;
    sockaddr_in destinationSocket;
};

struct order{
	ap_ufixed<16, 8> price; /*Order price as an 8Q8 fixed-point number*/
	ap_uint<8> size; 		/*Order size in hundreds*/
	ap_uint<32> orderID; 	/*Unique ID for each order*/
	ap_uint<3> direction; 	/*Order type: 0 - MARKET SELL 	1 - MARKET BUY   */
};							/*			  2 - INCOMING ASK 	3 - INCOMING BID */
							/*		   	  4 - REMOVE ASK	5 - REMOVE BID	 */

void simple_threshold(stream<order> &top_bid,
				stream<order> &top_ask,
				stream<Time> &incoming_time,
				stream<metadata> &incoming_meta,
				stream<order> &outgoing_order,
				stream<Time> &outgoing_time,
				stream<metadata> &outgoing_meta);
