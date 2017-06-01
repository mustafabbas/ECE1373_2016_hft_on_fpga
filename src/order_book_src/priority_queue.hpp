#include <cfloat>
#include <iostream>
#include <bitset>
#include <hls_stream.h>
#include "ap_int.h"

#define CAPACITY 4096
#define LEVELS 12

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
	ap_uint<3> direction; 	/*Order type: 0 - MARKET ASK 	1 - MARKET BID   */
};							/*			  2 - INCOMING ASK 	3 - INCOMING BID */
							/*		   	  4 - REMOVE ASK	5 - REMOVE BID	 */

//This function is a LUT for the log-base-2 to get the tree level of an index
int log2(int index);
//This function returns the power-of-2 to get the starting index of a tree level
int pow2(int level);
//This function returns the insertion path of a new node in the tree
//(i.e. if it returns 5 (101 in binary) then the insertion path is right-left-right)
int find_path(int counter, int& hole_counter, int hole_reg[CAPACITY]);
//This function calculates the array index of the next node in the insertion path
unsigned calculate_index (int insert_path, int &level, int idx);
//Given the level and index of a node in the tree, this function returns its left child
order left_child(unsigned level, unsigned index, order heap[LEVELS][CAPACITY/2]);
//Given the level and index of a node in the tree, this function returns its right child
order right_child(unsigned level, unsigned index, order heap[LEVELS][CAPACITY/2]);
//This function adds an entry to the bid book
void add_bid(order heap[LEVELS][CAPACITY/2],
		     order &new_order,
			 unsigned& heap_counter,
			 int& hole_counter,
			 int hole_reg[CAPACITY],
			 ap_uint<4> log_rom[CAPACITY]);
//This function removes an entry from the bid book
void remove_bid(order heap[LEVELS][CAPACITY/2],
		 	 	ap_uint<8>& req_size,
				unsigned& heap_counter,
				int& hole_counter,
				int hole_reg[CAPACITY],
				order dummy_order);
//This function adds an entry to the ask book
void add_ask(order heap[LEVELS][CAPACITY/2],
		     order &new_order,
			 unsigned& heap_counter,
			 int& hole_counter,
			 int hole_reg[CAPACITY],
			 ap_uint<4> log_rom[CAPACITY]);
//This function removes an entry from the ask book
void remove_ask(order heap[LEVELS][CAPACITY/2],
		 	 	ap_uint<8>& req_size,
				unsigned& heap_counter,
				int& hole_counter,
				int hole_reg[CAPACITY],
				order dummy_order);

//Top-Level Function
void order_book(stream<order> &order_stream,
				stream<Time> &incoming_time,
				stream<metadata> &incoming_meta,
				stream<order> &top_bid,
				stream<order> &top_ask,
				stream<Time> &outgoing_time,
				stream<metadata> &outgoing_meta,
                ap_uint<32> &top_bid_id,
                ap_uint<32> &top_ask_id);
