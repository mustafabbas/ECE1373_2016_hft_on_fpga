set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/srcs/ip/config/ten_gig_eth_mac_ip/synth/ten_gig_eth_mac_ip.xdc rfile:../../config/ten_gig_eth_mac_ip/synth/ten_gig_eth_mac_ip.xdc id:1 order:EARLY scoped_inst:n10g_interface_inst/ten_gig_eth_mac_inst/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/srcs/ip/config/clk_wiz_0/clk_wiz_0.xdc rfile:../../config/clk_wiz_0/clk_wiz_0.xdc id:2 order:EARLY scoped_inst:n10g_interface_inst/dclk_generator/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/build/tcp_ip.srcs/ten_gig_eth_pcs_pma_ip/ip/ten_gig_eth_pcs_pma_ip/ip_0/synth/ten_gig_eth_pcs_pma_ip_gt.xdc rfile:../../../../build/tcp_ip.srcs/ten_gig_eth_pcs_pma_ip/ip/ten_gig_eth_pcs_pma_ip/ip_0/synth/ten_gig_eth_pcs_pma_ip_gt.xdc id:3 order:EARLY scoped_inst:n10g_interface_inst/ten_gig_eth_pcs_pma_ip_inst/inst/ten_gig_eth_pcs_pma_block_i/ten_gig_eth_pcs_pma_ip_gt_i/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/build/tcp_ip.srcs/ten_gig_eth_pcs_pma_ip/ip/ten_gig_eth_pcs_pma_ip/synth/ten_gig_eth_pcs_pma_ip.xdc rfile:../../../../build/tcp_ip.srcs/ten_gig_eth_pcs_pma_ip/ip/ten_gig_eth_pcs_pma_ip/synth/ten_gig_eth_pcs_pma_ip.xdc id:4 order:EARLY scoped_inst:n10g_interface_inst/ten_gig_eth_pcs_pma_ip_inst/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/build/tcp_ip.srcs/udpAppMux_0/ip/udpAppMux_0/constraints/udpAppMux.xdc rfile:../../../../build/tcp_ip.srcs/udpAppMux_0/ip/udpAppMux_0/constraints/udpAppMux.xdc id:5 order:EARLY scoped_inst:myAppMux/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/madanie1/Documents/masc/vivado_projects/tcp_ip_10g/build/tcp_ip.srcs/constrs_1/imports/constraints/ao_8k5.xdc rfile:../../../../build/tcp_ip.srcs/constrs_1/imports/constraints/ao_8k5.xdc id:6} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay 6.4000 -datapath_only -from [get_cells ten_gig_eth_mac_ip_core/rx/rx_pause_control/pause_quanta_reg[*]] -to [get_cells ten_gig_eth_mac_ip_core/tx/tx_cntl/pause_tx_quanta_reg[*]]
set_property src_info {type:SCOPED_XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.05
set_property src_info {type:SCOPED_XDC file:3 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC GTHE3_CHANNEL_X1Y16 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[28].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]
set_property src_info {type:SCOPED_XDC file:4 line:52 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_cells -hierarchical -filter {NAME =~ *elastic*rd_truegray_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -to [get_cells -hierarchical -filter {NAME =~ *elastic*rag_writesync0_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -datapath_only 6.400
set_property src_info {type:SCOPED_XDC file:4 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_cells -hierarchical -filter {NAME =~ *elastic*wr_gray_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -to [get_cells -hierarchical -filter {NAME =~ *elastic*wr_gray_rdclk0_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -datapath_only 3.100
set_property src_info {type:SCOPED_XDC file:4 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_cells -hierarchical -filter {NAME =~ *elastic*rd_lastgray_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -to [get_cells -hierarchical -filter {NAME =~ *elastic*rd_lastgray_wrclk0_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -datapath_only 6.400
set_property src_info {type:SCOPED_XDC file:4 line:61 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_cells -of [all_fanin -flat [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *resyncs*d1_reg}] -filter {NAME =~ *D}]] -filter {IS_SEQUENTIAL=="1" && NAME !~ "*resyncs*d1_reg"}] -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *resyncs*d1_reg}] -filter {NAME =~ *D}] 3.100 -datapath_only
set_property src_info {type:SCOPED_XDC file:4 line:78 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -datapath_only -from [get_cells -hierarchical -filter {NAME =~ *drp_ipif_i*synch_*d_reg_reg* && (PRIMITIVE_SUBGROUP =~ flop || PRIMITIVE_SUBGROUP =~ SDR)}] -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *drp_ipif_i*synch_*q_reg*}] -filter {NAME =~ *D || NAME =~ *R || NAME =~ *S}] 3.100
set_property src_info {type:SCOPED_XDC file:4 line:91 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC GTHE3_COMMON_X1Y4  [get_cells -hier -filter {NAME=~  *ten_gig_eth_pcs_pma_gt_common_block/*gthe3_common*}]
set_property src_info {type:SCOPED_XDC file:4 line:92 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC GTHE3_COMMON_X1Y4  [get_cells -hier -filter {NAME=~  *shared*ibufds_inst}]
set_property src_info {type:SCOPED_XDC file:5 line:1 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_ports rxPortApp0_V[*]] -to [all_clocks]
set_property src_info {type:SCOPED_XDC file:5 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -from [get_ports rxPortApp1_V[*]] -to [all_clocks]
set_property src_info {type:XDC file:6 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_min_delay -from [get_ports {refclk200}] -100.0
set_property src_info {type:XDC file:6 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_min_delay -to [get_ports "led_l[*]"] -100
set_property src_info {type:XDC file:6 line:35 export:INPUT save:INPUT read:READ} [current_design]
set_min_delay -from [get_ports "user_sw_l"] -100
