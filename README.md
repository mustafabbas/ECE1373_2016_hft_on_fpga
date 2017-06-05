ECE1373 Course Project - High Frequency Trading
===============================================

Summary
-----------------------------
This project is an HFT subsystem for Xilinx FPGAs, that provides a very low latency 
(<450ns roundtrip) abstract view of a FAST (FIX Adapted For Streaming) financial data
Eternet feed. The core idea is to factor out the common aspects of an HFT system 
(efficient networking, encoding/decoding, sorting and storing market data) into an 
easy to use moidule that is accesible entirely through AXI Streams, so that more 
specialized HFT trading algortihms can be built on top of it.

The module also supports timestamping outgoing orders for in-hardware latency profiling

How to use
----------

Step 1: Build the HLS IP cores:

- Navigate to src folder and run the following comands:

vivado_hls -f build_fast_core.tcl
vivado_hls -f build_microblaze_to_switch_core.tcl
vivado_hls -f build_order_book_core.tcl
vivado_hls -f build_threshold_core.tcl

Step 2: Build the Vivado IP Integrator Project

- Navigate to src folder and open vivado tcl console using the following comand:

vivado -mode tcl

- In the tcl console run the following comand

build_project.tcl

Step 3: Program the FPGA 

- Open vivado and open the project in src/hft_proj

- click generate bitstream: this will run through the vivado synth and place and route flow

- Export bitstream and launch the sdk if you wish to program the microblaze (step not needed)

- program the device using the sdk src files found in src/sdk_src

Step 3: Run the scripts

scripts/testSystem.py [input testcase from createTestVectors.py]
   - Tests the system using the provided testcase. Order book is displayed in a GUI window.
scripts/manualPacketTest.py
   - Allows simple sending of hex number over the network. 

Repository structure
--------------------
src/
Contains the Vivado project used to build the project

/src/*_src/
Contains the src code of HLS projects for the various parts of our project. All project cores
 were developed using Vivado HLS. 

Authors
-------
Brett Grady, Mustafa Abbas, Andrew Boutros

Acknowledgements
----------------
Thanks to Dan Ly-Ma for providing the initial base project (simple demonstration
 of Xilinx Network Stack on 8K5) which this project used as a base.

