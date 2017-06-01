#include <iostream>
#include <fstream>
#include "priority_queue.hpp"

using namespace std;
using namespace hls;

#ifdef USEC
extern "C" {
void order_book(stream<order> &order_stream,
				stream<Time> &incoming_time,
				stream<metadata> &incoming_meta,
				stream<order> &top_bid,
				stream<order> &top_ask,
				stream<Time> &outgoing_time,
				stream<metadata> &outgoing_meta,
                ap_uint<32> &top_bid_id,
                ap_uint<32> &top_ask_id);
#else
void order_book(stream<order> &order_stream,
				stream<Time> &incoming_time,
				stream<metadata> &incoming_meta,
				stream<order> &top_bid,
				stream<order> &top_ask,
				stream<Time> &outgoing_time,
				stream<metadata> &outgoing_meta,
                ap_uint<32> &top_bid_id,
                ap_uint<32> &top_ask_id);
#endif

int main()
{
	//Set the test_mode to 0 to test the ask order book and 1 to test the bid order book
	int test_mode = 0;

	std::cout << "========TESTING STARTED========" << std::endl;

	//Output data-structures
	stream<order> top_bid_stream;
	stream<order> top_ask_stream;
	stream<Time> outgoing_time;
	stream<metadata> outgoing_meta;
	order top_bid;
	order top_ask;
	Time out_time;
	metadata out_meta;

	//Input data-structures
	stream<order> test_stream;
	stream<Time> test_time;
	stream<metadata> test_meta;
	sockaddr_in temp_1;
	metadata temp_meta;
	Time t;
	order test;

	//AXI-Lite
	ap_uint<32> top_bid_id;
	ap_uint<32> top_ask_id;

	//Specify the test case scenario
	if(test_mode == 0){
		test.price = 27.39; test.size = 4; test.orderID = 101; test.direction = 2;
		temp_1.port = 0; temp_1.addr = 0; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 0;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.2; test.size = 6; test.orderID = 102; test.direction = 2;
		temp_1.port = 1; temp_1.addr = 1; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 1;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.41; test.size = 2; test.orderID = 103; test.direction = 2;
		temp_1.port = 2; temp_1.addr = 2; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 2;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.4; test.size = 2; test.orderID = 104; test.direction = 2;
		temp_1.port = 3; temp_1.addr = 3; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 3;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.39; test.size = 4; test.orderID = 101; test.direction = 4;
		temp_1.port = 4; temp_1.addr = 4; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 4;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.35; test.size = 4; test.orderID = 105; test.direction = 2;
		temp_1.port = 5; temp_1.addr = 5; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 5;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 22; test.size = 11; test.orderID = 0; test.direction = 4;
		temp_1.port = 6; temp_1.addr = 6; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 6;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);
	}
	else{
		test.price = 27.39; test.size = 4; test.orderID = 101; test.direction = 3;
		temp_1.port = 0; temp_1.addr = 0; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 0;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.2; test.size = 6; test.orderID = 102; test.direction = 3;
		temp_1.port = 1; temp_1.addr = 1; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 1;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.41; test.size = 2; test.orderID = 103; test.direction = 3;
		temp_1.port = 2; temp_1.addr = 2; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 2;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.4; test.size = 2; test.orderID = 104; test.direction = 3;
		temp_1.port = 3; temp_1.addr = 3; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 3;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.39; test.size = 4; test.orderID = 101; test.direction = 5;
		temp_1.port = 4; temp_1.addr = 4; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 4;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 27.35; test.size = 4; test.orderID = 105; test.direction = 3;
		temp_1.port = 5; temp_1.addr = 5; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 5;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);

		test.price = 22; test.size = 7; test.orderID = 0; test.direction = 5;
		temp_1.port = 6; temp_1.addr = 6; temp_meta.destinationSocket = temp_1; temp_meta.sourceSocket = temp_1; t = 6;
		test_stream.write(test);
		test_time.write(t);
		test_meta.write(temp_meta);
	}

	//Feed the specified test cases to the IP core
	while(!test_stream.empty())
		order_book(test_stream, test_time, test_meta, top_bid_stream, top_ask_stream, outgoing_time, outgoing_meta, top_bid_id, top_ask_id);

	//Specify the golden outputs for the tested scenarios
	ap_ufixed<16, 8> golden_prices_bid[7] = {27.39, 27.39, 27.41, 27.41, 27.41, 27.41, 27.35};
	ap_uint<32> golden_IDs_bid[7] = {101, 101, 103, 103, 103, 103, 105};
	ap_uint<8> golden_size_bid[7] = {4, 4, 2, 2, 2, 2, 1};

	ap_ufixed<16, 8> golden_prices_ask[7] = {27.39, 27.2, 27.2, 27.2, 27.2, 27.2, 27.4};
	ap_uint<32> golden_IDs_ask[7] = {101, 102, 102, 102, 102, 102, 104};
	ap_uint<8> golden_size_ask[7] = {4, 6, 6, 6, 6, 6, 1};

	//Check the IP core outputs compared to the golden outputs
	for(unsigned i = 0; i < 7; i++){
		top_bid = top_bid_stream.read();
		if(test_mode == 1 && (top_bid.price != golden_prices_bid[i] || top_bid.orderID != golden_IDs_bid[i] || top_bid.size != golden_size_bid[i])){
			cout << "Time Step " << i+1 << ": Top Bid is " << top_bid.orderID << "\t" << top_bid.size << "\t" << fixed << setprecision(2) << top_bid.price.to_double() << endl;
			cout << "Bid result " << i << " not matching!" << endl;
			return 1;
		}

		top_ask = top_ask_stream.read();
		if(test_mode == 0 && (top_ask.price != golden_prices_ask[i] || top_ask.orderID != golden_IDs_ask[i] || top_ask.size != golden_size_ask[i])){
			cout << "Time Step " << i+1 << ": Top Ask is " << top_ask.orderID << "\t" << top_ask.size << "\t" << fixed << setprecision(2) << top_ask.price.to_double() << endl;
			cout << "Ask result " << i << " not matching!" << endl;
			return 1;
		}

		out_meta = outgoing_meta.read();
		if(out_meta.destinationSocket.addr != i || out_meta.destinationSocket.port != i || out_meta.sourceSocket.addr != i || out_meta.sourceSocket.port != i){
			cout << "Mismatch in metadata" << endl;
			return 1;
		}

		out_time = outgoing_time.read();
		if(out_time != i){
			cout << "Mismatch in timestamp" << endl;
			return 1;
		}

		if(test_mode == 1)
			cout << "Time Step " << i+1 << ": Top Bid is " << top_bid.orderID << "\t" << top_bid.size << "\t" << fixed << setprecision(2) << top_bid.price.to_double() << endl;
		else
			cout << "Time Step " << i+1 << ": Top Ask is " << top_ask.orderID << "\t" << top_ask.size << "\t" << fixed << setprecision(2) << top_ask.price.to_double() << endl;
	}

	std::cout << "========TESTING FINISHED========" << std::endl;

	return 0;
}
