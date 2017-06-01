#include "MBtoSW.hpp"

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
        stream <ap_uint<16> > &rxLengthMonitor)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis register both port=rxLengthMonitor
#pragma HLS INTERFACE axis register both port=rxDataMonitor
#pragma HLS INTERFACE axis register both port=rxMetadataMonitor
#pragma HLS DATA_PACK variable=rxMetadataMonitor
#pragma HLS INTERFACE s_axilite port=best_bid_sw
#pragma HLS INTERFACE s_axilite port=best_ask_sw

//#pragma HLS INTERFACE axis register both port=rxReplyPortOpen
//#pragma HLS INTERFACE axis register both port=txRequestPortOpen



    static ap_uint<32> prev_bid = 0;
    static ap_uint<32> prev_ask = 0;


        std::cout << "state : SENDING DATA" << std::endl;
        //if((prev_bid != best_bid_sw) || (prev_ask != best_ask_sw)){
            if(!rxDataMonitor.full() && !rxMetadataMonitor.full() && !rxLengthMonitor.full()){
                volatile int wait = 0;
                for(;wait<10000000; wait++);

                axiWord msg;
                msg.data = best_bid_sw.concat(best_ask_sw);
                //msg.data=123456;
                msg.keep = 0xFF;
                msg.last = 1;

                ap_uint<16> length = 8;

                sockaddr_in src;
                src.port = 641;
                src.addr = 0x01010101; // 1.1.1.1

                sockaddr_in dst;
                dst.port = 1444;       // set using 'bind' in python script; could be anything
                dst.addr = 0x01010102; // 1.1.1.2

                metadata meta;
                meta.sourceSocket = src;
                meta.destinationSocket = dst;

                rxDataMonitor.write(msg);
                rxMetadataMonitor.write(meta);
                rxLengthMonitor.write(length);

                prev_bid = best_bid_sw;
                prev_ask = best_ask_sw;
            }
        //}

}
