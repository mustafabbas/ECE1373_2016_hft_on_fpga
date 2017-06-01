
#reference 200mhz clk
set_property PACKAGE_PIN AM19 [get_ports {refclk200}]
set_property IOSTANDARD LVCMOS33 [get_ports {refclk200}]
#
set_max_delay -from [get_ports {refclk200}]  100.0
set_min_delay -from [get_ports {refclk200}] -100.0
#
create_clock -period 5.000 -name refclk200 [get_ports {refclk200}]

#PCI express reset
set_property PACKAGE_PIN AE15 [get_ports perst_n]
set_property IOSTANDARD LVCMOS18 [get_ports perst_n]
set_property PULLUP true [get_ports perst_n]

set_false_path -from [get_ports perst_n]
#leds
set_property PACKAGE_PIN AT19    [get_ports "led_l[0]"] ; # USER_LED_G0
set_property IOSTANDARD LVCMOS33 [get_ports "led_l[0]"]

set_property PACKAGE_PIN AU19    [get_ports "led_l[1]"] ; # USER_LED_G1
set_property IOSTANDARD LVCMOS33 [get_ports "led_l[1]"]

set_property PACKAGE_PIN AU20    [get_ports "led_l[2]"] ; # USER_LED_R
set_property IOSTANDARD LVCMOS33 [get_ports "led_l[2]"]

set_max_delay -to [get_ports "led_l[*]"]  100
set_min_delay -to [get_ports "led_l[*]"] -100

#switch
set_property PACKAGE_PIN AV18    [get_ports "user_sw_l"]
set_property IOSTANDARD LVCMOS33 [get_ports "user_sw_l"]

set_max_delay -from [get_ports "user_sw_l"]  100
set_min_delay -from [get_ports "user_sw_l"] -100

#GTH Tranceivers

## gth_refclk clock constraints
#SFP 0 (BOT)
#set_property PACKAGE_PIN AE8 [get_ports xphy_refclk_p]
#set_property PACKAGE_PIN AE7 [get_ports xphy_refclk_n]

#??
#set_property PACKAGE_PIN AC8 [get_ports gth_refclk1p_i[0]]
#set_property PACKAGE_PIN AC7 [get_ports gth_refclk1n_i[0]]

#SFP 1 (TOP)
set_property PACKAGE_PIN AA8 [get_ports refclk_p]
set_property PACKAGE_PIN AA7 [get_ports refclk_n]

#SI5328_REFCLK_OUT0
#set_property PACKAGE_PIN W8 [get_ports gth_refclk1p_i[1]]
#set_property PACKAGE_PIN W7 [get_ports gth_refclk1n_i[1]]

#Firefly GTH_CLK_2 MGTREFCLK0_232
#set_property PACKAGE_PIN F10 [get_ports gth_refclk0p_i[2]]
#set_property PACKAGE_PIN F9 [get_ports gth_refclk0n_i[2]]

#Firefly EXT_CLK MGTREFCLK0_232
#set_property PACKAGE_PIN D10 [get_ports gth_refclk1p_i[2]]
#set_property PACKAGE_PIN D9 [get_ports gth_refclk1n_i[2]]

## Refclk constraints
#create_clock -name xphy_refclk -period 6.4 [get_ports xphy_refclk_p]
#create_clock -name gth_refclk1_8 -period 6.4 [get_ports gth_refclk1p_i[0]]
#set_clock_groups -group [get_clocks xphy_refclk -include_generated_clocks] -asynchronous
#set_clock_groups -group [get_clocks gth_refclk1_8 -include_generated_clocks] -asynchronous
#create_clock -name gth_refclk0_9 -period 6.4 [get_ports gth_refclk0p_i[1]]
#create_clock -name gth_refclk1_9 -period 6.4 [get_ports gth_refclk1p_i[1]]
#set_clock_groups -group [get_clocks gth_refclk0_9 -include_generated_clocks] -asynchronous
#set_clock_groups -group [get_clocks gth_refclk1_9 -include_generated_clocks] -asynchronous
#create_clock -name gth_refclk0_13 -period 6.4 [get_ports gth_refclk0p_i[2]]
#create_clock -name gth_refclk1_13 -period 6.4 [get_ports gth_refclk1p_i[2]]
#set_clock_groups -group [get_clocks gth_refclk0_13 -include_generated_clocks] -asynchronous
#set_clock_groups -group [get_clocks gth_refclk1_13 -include_generated_clocks] -asynchronous


## TX/RX out clock clock constraints
# GT X0Y12
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[0].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[0].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y13
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[1].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[1].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y14
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[2].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[2].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y15
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[3].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[0].u_q/CH[3].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y16
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[0].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[0].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y17
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[1].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[1].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y18
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[2].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[2].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y19
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[3].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[1].u_q/CH[3].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y28
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[0].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[0].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y29
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[1].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[1].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y30
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[2].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[2].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y31
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[3].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[2].u_q/CH[3].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y32
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[0].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[0].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y33
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[1].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[1].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y34
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[2].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[2].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]
## # GT X0Y35
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[3].u_ch/u_gthe3_channel/RXOUTCLK}] -include_generated_clocks]
## set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {u_ibert_gth_core/inst/QUAD[3].u_q/CH[3].u_ch/u_gthe3_channel/TXOUTCLK}] -include_generated_clocks]

##DDR4 bank 0 x72

#set_property PACKAGE_PIN G16 [get_ports "c0_ddr4_sys_clk_p"]
#set_property PACKAGE_PIN G15 [get_ports "c0_ddr4_sys_clk_n"]

#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "c0_ddr4_sys_clk_p"]
#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "c0_ddr4_sys_clk_n"]


#set_property PACKAGE_PIN C17 [get_ports "c0_ddr4_dqs_t[0]"]
#set_property PACKAGE_PIN B17 [get_ports "c0_ddr4_dqs_c[0]"]
#set_property PACKAGE_PIN C22 [get_ports "c0_ddr4_dqs_t[1]"]
#set_property PACKAGE_PIN B22 [get_ports "c0_ddr4_dqs_c[1]"]
#set_property PACKAGE_PIN K16 [get_ports "c0_ddr4_dqs_t[2]"]
#set_property PACKAGE_PIN J16 [get_ports "c0_ddr4_dqs_c[2]"]
#set_property PACKAGE_PIN N21 [get_ports "c0_ddr4_dqs_t[3]"]
#set_property PACKAGE_PIN N22 [get_ports "c0_ddr4_dqs_c[3]"]
#set_property PACKAGE_PIN F17 [get_ports "c0_ddr4_dqs_t[4]"]
#set_property PACKAGE_PIN E17 [get_ports "c0_ddr4_dqs_c[4]"]
#set_property PACKAGE_PIN G24 [get_ports "c0_ddr4_dqs_t[5]"]
#set_property PACKAGE_PIN F24 [get_ports "c0_ddr4_dqs_c[5]"]
#set_property PACKAGE_PIN M20 [get_ports "c0_ddr4_dqs_t[6]"]
#set_property PACKAGE_PIN M21 [get_ports "c0_ddr4_dqs_c[6]"]
#set_property PACKAGE_PIN T18 [get_ports "c0_ddr4_dqs_t[7]"]
#set_property PACKAGE_PIN T17 [get_ports "c0_ddr4_dqs_c[7]"]
#set_property PACKAGE_PIN N12 [get_ports "c0_ddr4_dqs_t[8]"]
#set_property PACKAGE_PIN M12 [get_ports "c0_ddr4_dqs_c[8]"]

#set_property PACKAGE_PIN B20 [get_ports "c0_ddr4_dq[0]"]
#set_property PACKAGE_PIN C18 [get_ports "c0_ddr4_dq[1]"]
#set_property PACKAGE_PIN B19 [get_ports "c0_ddr4_dq[2]"]
#set_property PACKAGE_PIN A18 [get_ports "c0_ddr4_dq[3]"]
#set_property PACKAGE_PIN A20 [get_ports "c0_ddr4_dq[4]"]
#set_property PACKAGE_PIN D18 [get_ports "c0_ddr4_dq[5]"]
#set_property PACKAGE_PIN A19 [get_ports "c0_ddr4_dq[6]"]
#set_property PACKAGE_PIN A17 [get_ports "c0_ddr4_dq[7]"]
#set_property PACKAGE_PIN C21 [get_ports "c0_ddr4_dq[8]"]
#set_property PACKAGE_PIN D23 [get_ports "c0_ddr4_dq[9]"]
#set_property PACKAGE_PIN A24 [get_ports "c0_ddr4_dq[10]"]
#set_property PACKAGE_PIN B24 [get_ports "c0_ddr4_dq[11]"]
#set_property PACKAGE_PIN B21 [get_ports "c0_ddr4_dq[12]"]
#set_property PACKAGE_PIN C23 [get_ports "c0_ddr4_dq[13]"]
#set_property PACKAGE_PIN D21 [get_ports "c0_ddr4_dq[14]"]
#set_property PACKAGE_PIN A22 [get_ports "c0_ddr4_dq[15]"]
#set_property PACKAGE_PIN J19 [get_ports "c0_ddr4_dq[16]"]
#set_property PACKAGE_PIN M17 [get_ports "c0_ddr4_dq[17]"]
#set_property PACKAGE_PIN K18 [get_ports "c0_ddr4_dq[18]"]
#set_property PACKAGE_PIN L19 [get_ports "c0_ddr4_dq[19]"]
#set_property PACKAGE_PIN J18 [get_ports "c0_ddr4_dq[20]"]
#set_property PACKAGE_PIN M16 [get_ports "c0_ddr4_dq[21]"]
#set_property PACKAGE_PIN J20 [get_ports "c0_ddr4_dq[22]"]
#set_property PACKAGE_PIN L18 [get_ports "c0_ddr4_dq[23]"]
#set_property PACKAGE_PIN T22 [get_ports "c0_ddr4_dq[24]"]
#set_property PACKAGE_PIN R20 [get_ports "c0_ddr4_dq[25]"]
#set_property PACKAGE_PIN P23 [get_ports "c0_ddr4_dq[26]"]
#set_property PACKAGE_PIN N23 [get_ports "c0_ddr4_dq[27]"]
#set_property PACKAGE_PIN R22 [get_ports "c0_ddr4_dq[28]"]
#set_property PACKAGE_PIN P21 [get_ports "c0_ddr4_dq[29]"]
#set_property PACKAGE_PIN R21 [get_ports "c0_ddr4_dq[30]"]
#set_property PACKAGE_PIN P20 [get_ports "c0_ddr4_dq[31]"]
#set_property PACKAGE_PIN E20 [get_ports "c0_ddr4_dq[32]"]
#set_property PACKAGE_PIN F18 [get_ports "c0_ddr4_dq[33]"]
#set_property PACKAGE_PIN F20 [get_ports "c0_ddr4_dq[34]"]
#set_property PACKAGE_PIN E18 [get_ports "c0_ddr4_dq[35]"]
#set_property PACKAGE_PIN F19 [get_ports "c0_ddr4_dq[36]"]
#set_property PACKAGE_PIN G20 [get_ports "c0_ddr4_dq[37]"]
#set_property PACKAGE_PIN H18 [get_ports "c0_ddr4_dq[38]"]
#set_property PACKAGE_PIN H17 [get_ports "c0_ddr4_dq[39]"]
#set_property PACKAGE_PIN G22 [get_ports "c0_ddr4_dq[40]"]
#set_property PACKAGE_PIN E23 [get_ports "c0_ddr4_dq[41]"]
#set_property PACKAGE_PIN G21 [get_ports "c0_ddr4_dq[42]"]
#set_property PACKAGE_PIN F23 [get_ports "c0_ddr4_dq[43]"]
#set_property PACKAGE_PIN H24 [get_ports "c0_ddr4_dq[44]"]
#set_property PACKAGE_PIN E22 [get_ports "c0_ddr4_dq[45]"]
#set_property PACKAGE_PIN H23 [get_ports "c0_ddr4_dq[46]"]
#set_property PACKAGE_PIN E21 [get_ports "c0_ddr4_dq[47]"]
#set_property PACKAGE_PIN J23 [get_ports "c0_ddr4_dq[48]"]
#set_property PACKAGE_PIN K22 [get_ports "c0_ddr4_dq[49]"]
#set_property PACKAGE_PIN K23 [get_ports "c0_ddr4_dq[50]"]
#set_property PACKAGE_PIN L24 [get_ports "c0_ddr4_dq[51]"]
#set_property PACKAGE_PIN J24 [get_ports "c0_ddr4_dq[52]"]
#set_property PACKAGE_PIN L20 [get_ports "c0_ddr4_dq[53]"]
#set_property PACKAGE_PIN L23 [get_ports "c0_ddr4_dq[54]"]
#set_property PACKAGE_PIN K20 [get_ports "c0_ddr4_dq[55]"]
#set_property PACKAGE_PIN P16 [get_ports "c0_ddr4_dq[56]"]
#set_property PACKAGE_PIN R18 [get_ports "c0_ddr4_dq[57]"]
#set_property PACKAGE_PIN R17 [get_ports "c0_ddr4_dq[58]"]
#set_property PACKAGE_PIN N19 [get_ports "c0_ddr4_dq[59]"]
#set_property PACKAGE_PIN R16 [get_ports "c0_ddr4_dq[60]"]
#set_property PACKAGE_PIN N18 [get_ports "c0_ddr4_dq[61]"]
#set_property PACKAGE_PIN N16 [get_ports "c0_ddr4_dq[62]"]
#set_property PACKAGE_PIN N17 [get_ports "c0_ddr4_dq[63]"]
#set_property PACKAGE_PIN N14 [get_ports "c0_ddr4_dq[64]"]
#set_property PACKAGE_PIN R12 [get_ports "c0_ddr4_dq[65]"]
#set_property PACKAGE_PIN P15 [get_ports "c0_ddr4_dq[66]"]
#set_property PACKAGE_PIN P14 [get_ports "c0_ddr4_dq[67]"]
#set_property PACKAGE_PIN M14 [get_ports "c0_ddr4_dq[68]"]
#set_property PACKAGE_PIN R13 [get_ports "c0_ddr4_dq[69]"]
#set_property PACKAGE_PIN L15 [get_ports "c0_ddr4_dq[70]"]
#set_property PACKAGE_PIN M15 [get_ports "c0_ddr4_dq[71]"]

#set_property PACKAGE_PIN D14 [get_ports "c0_ddr4_adr[0]"]
#set_property PACKAGE_PIN F15 [get_ports "c0_ddr4_adr[1]"]
#set_property PACKAGE_PIN G12 [get_ports "c0_ddr4_adr[2]"]
#set_property PACKAGE_PIN E13 [get_ports "c0_ddr4_adr[3]"]
#set_property PACKAGE_PIN A13 [get_ports "c0_ddr4_adr[4]"]
#set_property PACKAGE_PIN C12 [get_ports "c0_ddr4_adr[5]"]
#set_property PACKAGE_PIN B12 [get_ports "c0_ddr4_adr[6]"]
#set_property PACKAGE_PIN F12 [get_ports "c0_ddr4_adr[7]"]
#set_property PACKAGE_PIN D13 [get_ports "c0_ddr4_adr[8]"]
#set_property PACKAGE_PIN C13 [get_ports "c0_ddr4_adr[9]"]
#set_property PACKAGE_PIN C14 [get_ports "c0_ddr4_adr[10]"]
#set_property PACKAGE_PIN E12 [get_ports "c0_ddr4_adr[11]"]
#set_property PACKAGE_PIN B14 [get_ports "c0_ddr4_adr[12]"]
#set_property PACKAGE_PIN J15 [get_ports "c0_ddr4_adr[13]"]
#set_property PACKAGE_PIN H12 [get_ports "c0_ddr4_adr[14]"]
#set_property PACKAGE_PIN B16 [get_ports "c0_ddr4_adr[15]"]
#set_property PACKAGE_PIN A15 [get_ports "c0_ddr4_adr[16]"]

#set_property PACKAGE_PIN K13 [get_ports "c0_ddr4_ck_t"]
#set_property PACKAGE_PIN K12 [get_ports "c0_ddr4_ck_c"]

#set_property PACKAGE_PIN B15 [get_ports "c0_ddr4_ba[0]"]
#set_property PACKAGE_PIN F14 [get_ports "c0_ddr4_ba[1]"]

#set_property PACKAGE_PIN G14 [get_ports "c0_ddr4_bg[0]"]
#set_property PACKAGE_PIN H14 [get_ports "c0_ddr4_bg[1]"]

#set_property PACKAGE_PIN D15 [get_ports "c0_ddr4_cs_n[0]"]
#set_property PACKAGE_PIN E16 [get_ports "c0_ddr4_cke[0]"]
#set_property PACKAGE_PIN D16 [get_ports "c0_ddr4_odt[0]"]

#set_property PACKAGE_PIN F13 [get_ports "c0_ddr4_act_n"]
#set_property PACKAGE_PIN A14 [get_ports "c0_ddr4_reset_n"]

#set_property PACKAGE_PIN D19 [get_ports "c0_ddr4_dm_dbi_n[0]"]
#set_property PACKAGE_PIN D24 [get_ports "c0_ddr4_dm_dbi_n[1]"]
#set_property PACKAGE_PIN L17 [get_ports "c0_ddr4_dm_dbi_n[2]"]
#set_property PACKAGE_PIN T23 [get_ports "c0_ddr4_dm_dbi_n[3]"]
#set_property PACKAGE_PIN H19 [get_ports "c0_ddr4_dm_dbi_n[4]"]
#set_property PACKAGE_PIN H21 [get_ports "c0_ddr4_dm_dbi_n[5]"]
#set_property PACKAGE_PIN K21 [get_ports "c0_ddr4_dm_dbi_n[6]"]
#set_property PACKAGE_PIN P19 [get_ports "c0_ddr4_dm_dbi_n[7]"]
#set_property PACKAGE_PIN P13 [get_ports "c0_ddr4_dm_dbi_n[8]"]

##
## This file contains constraints for signals of SDRAM bank 0 that are not used
## by MIG as of Vivado 2015.4.
##
## The pins referenced in this file are tied off to constant levels in order to
## avoid spurious transitions but must nevertheless be constrained.
##

## Use ODT (output only) as a model for PAR (output only)
#set odt_iostandard       [get_property IOSTANDARD       [get_ports "c0_ddr4_odt[0]"]]
#set odt_output_impedance [get_property OUTPUT_IMPEDANCE [get_ports "c0_ddr4_odt[0]"]]
#set odt_slew             [get_property SLEW             [get_ports "c0_ddr4_odt[0]"]]
#set_property PACKAGE_PIN      H13                   [get_ports "c0_ddr4_par"]
#set_property IOSTANDARD       $odt_iostandard       [get_ports "c0_ddr4_par"]
#set_property OUTPUT_IMPEDANCE $odt_output_impedance [get_ports "c0_ddr4_par"]
#set_property SLEW             $odt_slew             [get_ports "c0_ddr4_par"]

## Use RESET# (output only) as a model for TEN (output only)
#set reset_iostandard [get_property IOSTANDARD [get_ports "c0_ddr4_reset_n"]]
#set reset_drive      [get_property DRIVE      [get_ports "c0_ddr4_reset_n"]]
#set_property PACKAGE_PIN K15               [get_ports "c0_ddr4_ten"]
#set_property IOSTANDARD  $reset_iostandard [get_ports "c0_ddr4_ten"]
#set_property DRIVE       $reset_drive      [get_ports "c0_ddr4_ten"]

## ALERT# is open-drain
#set_property PACKAGE_PIN A12      [get_ports "c0_ddr4_alert_n"]
#set_property IOSTANDARD  LVCMOS12 [get_ports "c0_ddr4_alert_n"]

## Use ADR0 (output only) as a model for ADR17 (output only)
#set adr0_iostandard       [get_property IOSTANDARD       [get_ports "c0_ddr4_adr[0]"]]
#set adr0_output_impedance [get_property OUTPUT_IMPEDANCE [get_ports "c0_ddr4_adr[0]"]]
#set adr0_slew             [get_property SLEW             [get_ports "c0_ddr4_adr[0]"]]
#set_property PACKAGE_PIN      L13                    [get_ports "c0_ddr4_adr[17]"]
#set_property IOSTANDARD       $adr0_iostandard       [get_ports "c0_ddr4_adr[17]"]
#set_property OUTPUT_IMPEDANCE $adr0_output_impedance [get_ports "c0_ddr4_adr[17]"]
#set_property SLEW             $adr0_slew             [get_ports "c0_ddr4_adr[17]"]

##
## This file contains non-PACKAGE_PIN constraints for twin-die / stacked-die related signals of
## SDRAM bank 0 that are not driven by MIG when it is in a single-die configuration. Without
## these constraints, the IOSTANDARD, SLEW & OUTPUT_IMPEDANCE would not be specified.
##

#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c0_ddr4_cke[0]"]]  [get_ports "c0_ddr4_cke[1]"]
#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c0_ddr4_cs_n[0]"]] [get_ports "c0_ddr4_cs_n[1]"]
#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c0_ddr4_odt[0]"]]  [get_ports "c0_ddr4_odt[1]"]

#set_property SLEW [get_property SLEW [get_ports "c0_ddr4_cke[0]"]]  [get_ports "c0_ddr4_cke[1]"]
#set_property SLEW [get_property SLEW [get_ports "c0_ddr4_cs_n[0]"]] [get_ports "c0_ddr4_cs_n[1]"]
#set_property SLEW [get_property SLEW [get_ports "c0_ddr4_odt[0]"]]  [get_ports "c0_ddr4_odt[1]"]

#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c0_ddr4_cke[0]"]]  [get_ports "c0_ddr4_cke[1]"]
#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c0_ddr4_cs_n[0]"]] [get_ports "c0_ddr4_cs_n[1]"]
#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c0_ddr4_odt[0]"]]  [get_ports "c0_ddr4_odt[1]"]

#set_property PACKAGE_PIN L12 [get_ports "c0_ddr4_cke[1]"]      ; # C0
#set_property PACKAGE_PIN E15 [get_ports "c0_ddr4_cs_n[1]"]     ; # C1
#set_property PACKAGE_PIN J13 [get_ports "c0_ddr4_odt[1]"]      ; # C2

##DDR4 bank 1 x72

#set_property PACKAGE_PIN AM22 [get_ports "c1_ddr4_sys_clk_p"]
#set_property PACKAGE_PIN AN22 [get_ports "c1_ddr4_sys_clk_n"]

#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "c1_ddr4_sys_clk_p"]
#set_property IOSTANDARD DIFF_HSTL_I_12 [get_ports "c1_ddr4_sys_clk_n"]


#set_property PACKAGE_PIN AU21 [get_ports "c1_ddr4_dqs_t[0]"]
#set_property PACKAGE_PIN AV22 [get_ports "c1_ddr4_dqs_c[0]"]
#set_property PACKAGE_PIN AU25 [get_ports "c1_ddr4_dqs_t[1]"]
#set_property PACKAGE_PIN AU26 [get_ports "c1_ddr4_dqs_c[1]"]
#set_property PACKAGE_PIN AL24 [get_ports "c1_ddr4_dqs_t[2]"]
#set_property PACKAGE_PIN AL25 [get_ports "c1_ddr4_dqs_c[2]"]
#set_property PACKAGE_PIN AF24 [get_ports "c1_ddr4_dqs_t[3]"]
#set_property PACKAGE_PIN AG24 [get_ports "c1_ddr4_dqs_c[3]"]
#set_property PACKAGE_PIN AP25 [get_ports "c1_ddr4_dqs_t[4]"]
#set_property PACKAGE_PIN AR25 [get_ports "c1_ddr4_dqs_c[4]"]
#set_property PACKAGE_PIN H37  [get_ports "c1_ddr4_dqs_t[5]"]
#set_property PACKAGE_PIN H38  [get_ports "c1_ddr4_dqs_c[5]"]
#set_property PACKAGE_PIN L38  [get_ports "c1_ddr4_dqs_t[6]"]
#set_property PACKAGE_PIN K38  [get_ports "c1_ddr4_dqs_c[6]"]
#set_property PACKAGE_PIN B35  [get_ports "c1_ddr4_dqs_t[7]"]
#set_property PACKAGE_PIN A35  [get_ports "c1_ddr4_dqs_c[7]"]
#set_property PACKAGE_PIN C38  [get_ports "c1_ddr4_dqs_t[8]"]
#set_property PACKAGE_PIN B39  [get_ports "c1_ddr4_dqs_c[8]"]

#set_property PACKAGE_PIN AV23 [get_ports "c1_ddr4_dq[0]"]
#set_property PACKAGE_PIN AT22 [get_ports "c1_ddr4_dq[1]"]
#set_property PACKAGE_PIN AT24 [get_ports "c1_ddr4_dq[2]"]
#set_property PACKAGE_PIN AT23 [get_ports "c1_ddr4_dq[3]"]
#set_property PACKAGE_PIN AW23 [get_ports "c1_ddr4_dq[4]"]
#set_property PACKAGE_PIN AU22 [get_ports "c1_ddr4_dq[5]"]
#set_property PACKAGE_PIN AW21 [get_ports "c1_ddr4_dq[6]"]
#set_property PACKAGE_PIN AV21 [get_ports "c1_ddr4_dq[7]"]
#set_property PACKAGE_PIN AT27 [get_ports "c1_ddr4_dq[8]"]
#set_property PACKAGE_PIN AV27 [get_ports "c1_ddr4_dq[9]"]
#set_property PACKAGE_PIN AR28 [get_ports "c1_ddr4_dq[10]"]
#set_property PACKAGE_PIN AW25 [get_ports "c1_ddr4_dq[11]"]
#set_property PACKAGE_PIN AU27 [get_ports "c1_ddr4_dq[12]"]
#set_property PACKAGE_PIN AV26 [get_ports "c1_ddr4_dq[13]"]
#set_property PACKAGE_PIN AT28 [get_ports "c1_ddr4_dq[14]"]
#set_property PACKAGE_PIN AW26 [get_ports "c1_ddr4_dq[15]"]
#set_property PACKAGE_PIN AL28 [get_ports "c1_ddr4_dq[16]"]
#set_property PACKAGE_PIN AJ25 [get_ports "c1_ddr4_dq[17]"]
#set_property PACKAGE_PIN AH26 [get_ports "c1_ddr4_dq[18]"]
#set_property PACKAGE_PIN AH24 [get_ports "c1_ddr4_dq[19]"]
#set_property PACKAGE_PIN AJ26 [get_ports "c1_ddr4_dq[20]"]
#set_property PACKAGE_PIN AJ24 [get_ports "c1_ddr4_dq[21]"]
#set_property PACKAGE_PIN AL27 [get_ports "c1_ddr4_dq[22]"]
#set_property PACKAGE_PIN AK25 [get_ports "c1_ddr4_dq[23]"]
#set_property PACKAGE_PIN AD26 [get_ports "c1_ddr4_dq[24]"]
#set_property PACKAGE_PIN AG27 [get_ports "c1_ddr4_dq[25]"]
#set_property PACKAGE_PIN AE27 [get_ports "c1_ddr4_dq[26]"]
#set_property PACKAGE_PIN AF27 [get_ports "c1_ddr4_dq[27]"]
#set_property PACKAGE_PIN AE26 [get_ports "c1_ddr4_dq[28]"]
#set_property PACKAGE_PIN AG25 [get_ports "c1_ddr4_dq[29]"]
#set_property PACKAGE_PIN AF25 [get_ports "c1_ddr4_dq[30]"]
#set_property PACKAGE_PIN AG26 [get_ports "c1_ddr4_dq[31]"]
#set_property PACKAGE_PIN AM27 [get_ports "c1_ddr4_dq[32]"]
#set_property PACKAGE_PIN AM24 [get_ports "c1_ddr4_dq[33]"]
#set_property PACKAGE_PIN AN27 [get_ports "c1_ddr4_dq[34]"]
#set_property PACKAGE_PIN AN28 [get_ports "c1_ddr4_dq[35]"]
#set_property PACKAGE_PIN AM26 [get_ports "c1_ddr4_dq[36]"]
#set_property PACKAGE_PIN AN26 [get_ports "c1_ddr4_dq[37]"]
#set_property PACKAGE_PIN AM25 [get_ports "c1_ddr4_dq[38]"]
#set_property PACKAGE_PIN AP28 [get_ports "c1_ddr4_dq[39]"]
#set_property PACKAGE_PIN H34  [get_ports "c1_ddr4_dq[40]"]
#set_property PACKAGE_PIN G39  [get_ports "c1_ddr4_dq[41]"]
#set_property PACKAGE_PIN F37  [get_ports "c1_ddr4_dq[42]"]
#set_property PACKAGE_PIN G37  [get_ports "c1_ddr4_dq[43]"]
#set_property PACKAGE_PIN H36  [get_ports "c1_ddr4_dq[44]"]
#set_property PACKAGE_PIN H39  [get_ports "c1_ddr4_dq[45]"]
#set_property PACKAGE_PIN G34  [get_ports "c1_ddr4_dq[46]"]
#set_property PACKAGE_PIN G36  [get_ports "c1_ddr4_dq[47]"]
#set_property PACKAGE_PIN J38  [get_ports "c1_ddr4_dq[48]"]
#set_property PACKAGE_PIN J35  [get_ports "c1_ddr4_dq[49]"]
#set_property PACKAGE_PIN K37  [get_ports "c1_ddr4_dq[50]"]
#set_property PACKAGE_PIN K35  [get_ports "c1_ddr4_dq[51]"]
#set_property PACKAGE_PIN J39  [get_ports "c1_ddr4_dq[52]"]
#set_property PACKAGE_PIN J34  [get_ports "c1_ddr4_dq[53]"]
#set_property PACKAGE_PIN L37  [get_ports "c1_ddr4_dq[54]"]
#set_property PACKAGE_PIN L35  [get_ports "c1_ddr4_dq[55]"]
#set_property PACKAGE_PIN E35  [get_ports "c1_ddr4_dq[56]"]
#set_property PACKAGE_PIN B34  [get_ports "c1_ddr4_dq[57]"]
#set_property PACKAGE_PIN B36  [get_ports "c1_ddr4_dq[58]"]
#set_property PACKAGE_PIN D34  [get_ports "c1_ddr4_dq[59]"]
#set_property PACKAGE_PIN D35  [get_ports "c1_ddr4_dq[60]"]
#set_property PACKAGE_PIN A34  [get_ports "c1_ddr4_dq[61]"]
#set_property PACKAGE_PIN C36  [get_ports "c1_ddr4_dq[62]"]
#set_property PACKAGE_PIN C34  [get_ports "c1_ddr4_dq[63]"]
#set_property PACKAGE_PIN A38  [get_ports "c1_ddr4_dq[64]"]
#set_property PACKAGE_PIN D38  [get_ports "c1_ddr4_dq[65]"]
#set_property PACKAGE_PIN C39  [get_ports "c1_ddr4_dq[66]"]
#set_property PACKAGE_PIN D39  [get_ports "c1_ddr4_dq[67]"]
#set_property PACKAGE_PIN A37  [get_ports "c1_ddr4_dq[68]"]
#set_property PACKAGE_PIN E37  [get_ports "c1_ddr4_dq[69]"]
#set_property PACKAGE_PIN B37  [get_ports "c1_ddr4_dq[70]"]
#set_property PACKAGE_PIN C37  [get_ports "c1_ddr4_dq[71]"]

#set_property PACKAGE_PIN AG22 [get_ports "c1_ddr4_adr[0]"]
#set_property PACKAGE_PIN AE20 [get_ports "c1_ddr4_adr[1]"]
#set_property PACKAGE_PIN AL20 [get_ports "c1_ddr4_adr[2]"]
#set_property PACKAGE_PIN AJ23 [get_ports "c1_ddr4_adr[3]"]
#set_property PACKAGE_PIN AK21 [get_ports "c1_ddr4_adr[4]"]
#set_property PACKAGE_PIN AM20 [get_ports "c1_ddr4_adr[5]"]
#set_property PACKAGE_PIN AN21 [get_ports "c1_ddr4_adr[6]"]
#set_property PACKAGE_PIN AD21 [get_ports "c1_ddr4_adr[7]"]
#set_property PACKAGE_PIN AG21 [get_ports "c1_ddr4_adr[8]"]
#set_property PACKAGE_PIN AP20 [get_ports "c1_ddr4_adr[9]"]
#set_property PACKAGE_PIN AH23 [get_ports "c1_ddr4_adr[10]"]
#set_property PACKAGE_PIN AH22 [get_ports "c1_ddr4_adr[11]"]
#set_property PACKAGE_PIN AF23 [get_ports "c1_ddr4_adr[12]"]
#set_property PACKAGE_PIN AF22 [get_ports "c1_ddr4_adr[13]"]
#set_property PACKAGE_PIN AK23 [get_ports "c1_ddr4_adr[14]"]
#set_property PACKAGE_PIN AE21 [get_ports "c1_ddr4_adr[15]"]
#set_property PACKAGE_PIN AL22 [get_ports "c1_ddr4_adr[16]"]

#set_property PACKAGE_PIN AP21 [get_ports "c1_ddr4_ck_t"]
#set_property PACKAGE_PIN AR21 [get_ports "c1_ddr4_ck_c"]

#set_property PACKAGE_PIN AK22 [get_ports "c1_ddr4_ba[0]"]
#set_property PACKAGE_PIN AK20 [get_ports "c1_ddr4_ba[1]"]

#set_property PACKAGE_PIN AN23 [get_ports "c1_ddr4_bg[0]"]
#set_property PACKAGE_PIN AE23 [get_ports "c1_ddr4_bg[1]"]

#set_property PACKAGE_PIN AR22 [get_ports "c1_ddr4_cs_n[0]"]
#set_property PACKAGE_PIN AL23 [get_ports "c1_ddr4_cke[0]"]
#set_property PACKAGE_PIN AE22 [get_ports "c1_ddr4_odt[0]"]

#set_property PACKAGE_PIN AR23 [get_ports "c1_ddr4_act_n"]
#set_property PACKAGE_PIN AJ21 [get_ports "c1_ddr4_reset_n"]

#set_property PACKAGE_PIN AV24 [get_ports "c1_ddr4_dm_dbi_n[0]"]
#set_property PACKAGE_PIN AV28 [get_ports "c1_ddr4_dm_dbi_n[1]"]
#set_property PACKAGE_PIN AK27 [get_ports "c1_ddr4_dm_dbi_n[2]"]
#set_property PACKAGE_PIN AD25 [get_ports "c1_ddr4_dm_dbi_n[3]"]
#set_property PACKAGE_PIN AR26 [get_ports "c1_ddr4_dm_dbi_n[4]"]
#set_property PACKAGE_PIN G35  [get_ports "c1_ddr4_dm_dbi_n[5]"]
#set_property PACKAGE_PIN K36  [get_ports "c1_ddr4_dm_dbi_n[6]"]
#set_property PACKAGE_PIN E36  [get_ports "c1_ddr4_dm_dbi_n[7]"]
#set_property PACKAGE_PIN F38  [get_ports "c1_ddr4_dm_dbi_n[8]"]

##
## This file contains constraints for signals of SDRAM bank 1 that are not used
## by MIG as of Vivado 2015.4.
##
## The pins referenced in this file are tied off to constant levels in order to
## avoid spurious transitions but must nevertheless be constrained.
##

## Use ODT (output only) as a model for PAR (output only)
#set odt_iostandard       [get_property IOSTANDARD       [get_ports "c1_ddr4_odt[0]"]]
#set odt_output_impedance [get_property OUTPUT_IMPEDANCE [get_ports "c1_ddr4_odt[0]"]]
#set odt_slew             [get_property SLEW             [get_ports "c1_ddr4_odt[0]"]]
#set_property PACKAGE_PIN      AG20                  [get_ports "c1_ddr4_par"]
#set_property IOSTANDARD       $odt_iostandard       [get_ports "c1_ddr4_par"]
#set_property OUTPUT_IMPEDANCE $odt_output_impedance [get_ports "c1_ddr4_par"]
#set_property SLEW             $odt_slew             [get_ports "c1_ddr4_par"]

## Use RESET# (output only) as a model for TEN (output only)
#set reset_iostandard [get_property IOSTANDARD [get_ports "c1_ddr4_reset_n"]]
#set reset_drive      [get_property DRIVE      [get_ports "c1_ddr4_reset_n"]]
#set_property PACKAGE_PIN AD20              [get_ports "c1_ddr4_ten"]
#set_property IOSTANDARD  $reset_iostandard [get_ports "c1_ddr4_ten"]
#set_property DRIVE       $reset_drive      [get_ports "c1_ddr4_ten"]

## ALERT# is open-drain
#set_property PACKAGE_PIN AJ20     [get_ports "c1_ddr4_alert_n"]
#set_property IOSTANDARD  LVCMOS12 [get_ports "c1_ddr4_alert_n"]

## Use ADR0 (output only) as a model for ADR17 (output only)
#set adr0_iostandard       [get_property IOSTANDARD       [get_ports "c1_ddr4_adr[0]"]]
#set adr0_output_impedance [get_property OUTPUT_IMPEDANCE [get_ports "c1_ddr4_adr[0]"]]
#set adr0_slew             [get_property SLEW             [get_ports "c1_ddr4_adr[0]"]]
#set_property PACKAGE_PIN      AF20                   [get_ports "c1_ddr4_adr[17]"]
#set_property IOSTANDARD       $adr0_iostandard       [get_ports "c1_ddr4_adr[17]"]
#set_property OUTPUT_IMPEDANCE $adr0_output_impedance [get_ports "c1_ddr4_adr[17]"]
#set_property SLEW             $adr0_slew             [get_ports "c1_ddr4_adr[17]"]

##
## this file contains non-package_pin constraints for twin-die / stacked-die related signals of
## sdram bank 1 that are not driven by mig when it is in a single-die configuration. without
## these constraints, the iostandard, slew & output_impedance would not be specified.
##

#set_property PACKAGE_PIN AN24 [get_ports "c1_ddr4_cke[1]"]      ; # C0
#set_property PACKAGE_PIN AP24 [get_ports "c1_ddr4_cs_n[1]"]     ; # C1
#set_property PACKAGE_PIN AP23 [get_ports "c1_ddr4_odt[1]"]      ; # C2
#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c1_ddr4_cke[0]"]]  [get_ports "c1_ddr4_cke[1]"]
#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c1_ddr4_cs_n[0]"]] [get_ports "c1_ddr4_cs_n[1]"]
#set_property IOSTANDARD [get_property IOSTANDARD [get_ports "c1_ddr4_odt[0]"]]  [get_ports "c1_ddr4_odt[1]"]

#set_property SLEW [get_property SLEW [get_ports "c1_ddr4_cke[0]"]]  [get_ports "c1_ddr4_cke[1]"]
#set_property SLEW [get_property SLEW [get_ports "c1_ddr4_cs_n[0]"]] [get_ports "c1_ddr4_cs_n[1]"]
#set_property SLEW [get_property SLEW [get_ports "c1_ddr4_odt[0]"]]  [get_ports "c1_ddr4_odt[1]"]

#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c1_ddr4_cke[0]"]]  [get_ports "c1_ddr4_cke[1]"]
#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c1_ddr4_cs_n[0]"]] [get_ports "c1_ddr4_cs_n[1]"]
#set_property OUTPUT_IMPEDANCE [get_property OUTPUT_IMPEDANCE [get_ports "c1_ddr4_odt[0]"]]  [get_ports "c1_ddr4_odt[1]"]


## SFP pins
set_property PACKAGE_PIN AG17 [get_ports sfp_tx_disable[0]]
set_property IOSTANDARD LVCMOS33 [get_ports sfp_tx_disable[0]]
set_property PACKAGE_PIN AF19 [get_ports sfp_tx_disable[1]]
set_property IOSTANDARD LVCMOS33 [get_ports sfp_tx_disable[1]]
#set_property PACKAGE_PIN AJ19 [get_ports sfp0_rs0]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp0_rs0]
#set_property PACKAGE_PIN AD16 [get_ports sfp1_rs0]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp1_rs0]
#set_property PACKAGE_PIN AJ18 [get_ports sfp0_rs1]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp0_rs1]
#set_property PACKAGE_PIN AE17 [get_ports sfp1_rs1]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp1_rs1]
#set_property PACKAGE_PIN AL18 [get_ports firefly0_reset_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly0_reset_l]
#set_property PACKAGE_PIN AK16 [get_ports firefly1_reset_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly1_reset_l]
#set_property PACKAGE_PIN AK17 [get_ports firefly0_sel_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly0_sel_l]
#set_property PACKAGE_PIN AN16 [get_ports firefly1_sel_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly1_sel_l]

#set_property PACKAGE_PIN AE16 [get_ports sfp0_tx_fault]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp0_tx_fault]
#set_property PACKAGE_PIN AG19 [get_ports sfp1_tx_fault]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp1_tx_fault]
#set_property PACKAGE_PIN AH19 [get_ports sfp0_mod_abs]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp0_mod_abs]
#set_property PACKAGE_PIN AD18 [get_ports sfp1_mod_abs]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp1_mod_abs]
#set_property PACKAGE_PIN AM16 [get_ports sfp0_los]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp0_los]
#set_property PACKAGE_PIN AF17 [get_ports sfp1_los]
#set_property IOSTANDARD LVCMOS33 [get_ports sfp1_los]
#set_property PACKAGE_PIN AL17 [get_ports firefly0_int_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly0_int_l]
#set_property PACKAGE_PIN AM17 [get_ports firefly1_int_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly1_int_l]
#set_property PACKAGE_PIN AH17 [get_ports firefly0_modprs_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly0_modprs_l]
#set_property PACKAGE_PIN AL19 [get_ports firefly1_modprs_l]
#set_property IOSTANDARD LVCMOS33 [get_ports firefly1_modprs_l]

#bitstream constraints
# Configuration from G18 Flash as per XAPP1220
set_property BITSTREAM.GENERAL.COMPRESS {TRUE} [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN {DIV-1} [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE {TYPE1} [current_design]
set_property CONFIG_MODE {BPI16} [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN {Pullnone} [current_design]

# Set safety trigger to power down FPGA at 125degC
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN {Enable} [current_design]

# Set CFGBVS to GND to match schematics
set_property CFGBVS {GND} [current_design]

# Set CONFIG_VOLTAGE to 1.8V to match schematics
set_property CONFIG_VOLTAGE {1.8} [current_design]

