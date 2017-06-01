#include <hls_stream.h>
#include "ap_int.h"

using namespace hls;

struct axiWord {
    ap_uint<64>     data;
    ap_uint<8>      keep;
    ap_uint<1>      last;
};

struct sockaddr_in {
    ap_uint<16>     port;   /* port in network byte order */
    ap_uint<32>     addr;   /* internet address */
};

struct metadata {
    sockaddr_in sourceSocket;
    sockaddr_in destinationSocket;
};

void MicroblazeToSwitch(
        //MicroBlaze Interface
        ap_uint<32> best_bid_sw,
        ap_uint<32> best_ask_sw,

        // Port Request Interface
        //stream< bool >       &rxReplyPortOpen,
        //stream<ap_uint<16> > &txRequestPortOpen,

        //Switch Interface
        stream <axiWord>      &rxDataMonitor,
        stream <metadata>     &rxMetadataMonitor,
        stream <ap_uint<16> > &rxLengthMonitor);


