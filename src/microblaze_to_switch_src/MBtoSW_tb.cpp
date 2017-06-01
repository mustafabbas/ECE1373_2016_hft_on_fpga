#include <iostream>
#include <hls_stream.h>
#include "ap_int.h"
#include "MBtoSW.hpp"
using hls::stream;
using std::cout;

int main () {

    ap_uint<32> best_bid_sw=0;
    ap_uint<32> best_ask_sw=0;

    stream< bool >       rxReplyPortOpen;
    stream<ap_uint<16> > txRequestPortOpen;

    stream <axiWord>      rxDataMonitor;
    stream <metadata>     rxMetadataMonitor;
    stream <ap_uint<16> > rxLengthMonitor;

	// run once to get a request on the port
    MicroblazeToSwitch(best_bid_sw,best_ask_sw,rxReplyPortOpen,txRequestPortOpen,rxDataMonitor,rxMetadataMonitor,rxLengthMonitor);

    // read port request and send reply
    cout << "p// read the requested portort request received at tb : " << txRequestPortOpen.read() << std::endl;
    rxReplyPortOpen.write(true);

    // run once to get transition to data writing state.
    MicroblazeToSwitch(best_bid_sw,best_ask_sw,rxReplyPortOpen,txRequestPortOpen,rxDataMonitor,rxMetadataMonitor,rxLengthMonitor);

    // run repeatedly to see if updates are sent
    for (int i=0; i < 10 ; i++){
        best_ask_sw--;
        best_bid_sw++;
        MicroblazeToSwitch(best_bid_sw,best_ask_sw,rxReplyPortOpen,txRequestPortOpen,rxDataMonitor,rxMetadataMonitor,rxLengthMonitor);
        axiWord a;
        if(!rxDataMonitor.empty()){
            a = rxDataMonitor.read();
            long unsigned int bid = (a.data & 0x0000FF00) >> 16;
            long unsigned int ask = (a.data & 0x000000FF);
            cout << "reading bid; " << bid<< std::endl;
            cout << "reading ask; " << ask << std::endl;
        } else {
            cout << "no update" << std::endl;
        }
    }


}
