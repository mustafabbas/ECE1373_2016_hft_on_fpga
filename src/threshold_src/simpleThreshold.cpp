#include "simpleThreshold.hpp"

void simple_threshold(stream<order> &top_bid,
				stream<order> &top_ask,
				stream<Time> &incoming_time,
				stream<metadata> &incoming_meta,
				stream<order> &outgoing_order,
				stream<Time> &outgoing_time,
				stream<metadata> &outgoing_meta)
{
#pragma HLS RESOURCE core=AXI4Stream variable=top_bid
#pragma HLS RESOURCE core=AXI4Stream variable=top_ask
#pragma HLS RESOURCE core=AXI4Stream variable=incoming_time
#pragma HLS RESOURCE core=AXI4Stream variable=incoming_meta
#pragma HLS RESOURCE core=AXI4Stream variable=outgoing_order
#pragma HLS RESOURCE core=AXI4Stream variable=outgoing_time
#pragma HLS RESOURCE core=AXI4Stream variable=outgoing_meta

#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS DATA_PACK variable=outgoing_order struct_level
#pragma HLS DATA_PACK variable=top_bid struct_level
#pragma HLS DATA_PACK variable=top_ask struct_level
#pragma HLS DATA_PACK variable=incoming_meta
#pragma HLS DATA_PACK variable=outgoing_meta

	static const ap_ufixed<16,8> bid_threshold = 27.4;
	static const ap_ufixed<16,8> ask_threshold = 27.4;

	static order market_buy;
	market_buy.price = 1;
	market_buy.orderID = 123;
	market_buy.direction = 1;
	market_buy.size = 2;

	static order market_sell;
	market_sell.price = 1;
	market_sell.orderID = 123;
	market_sell.direction = 0;
	market_sell.size = 2;

	static order prev_bid;
	static order prev_ask;

	if(!top_bid.empty() && !top_ask.empty() && !incoming_time.empty() && !incoming_meta.empty()
			&& !outgoing_order.full() && !outgoing_time.full() && !outgoing_meta.full()){
		order bid = top_bid.read();
		order ask = top_ask.read();
		metadata meta_buffer = incoming_meta.read();
		Time time_buffer = incoming_time.read();

		if(bid.price > bid_threshold){
			outgoing_order.write(market_sell);
			outgoing_meta.write(meta_buffer);
			outgoing_time.write(time_buffer);
		}

		if(ask.price < bid_threshold){
			outgoing_order.write(market_buy);
			outgoing_meta.write(meta_buffer);
			outgoing_time.write(time_buffer);
		}

		prev_bid = bid;
		prev_ask = ask;
	}
}
