open_project microblaze_to_switch_hls -reset
set_top MicroblazeToSwitch
add_files microblaze_to_switch_src/MBtoSW.cpp
add_files microblaze_to_switch_src/MBtoSW.hpp
add_files -tb micorblaze_to_switch_src/MBtoSW_tb.cpp
open_solution "solution1"
set_part {xcku115-flva1517-2-e} -tool vivado
create_clock -period 5 -name default
csynth_design
export_design -format ip_catalog
exit
