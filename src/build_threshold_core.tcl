open_project threshold_hls -reset
set_top simple_threshold
add_files threshold_src/simpleThreshold.cpp
add_files threshold_src/simpleThreshold.hpp
open_solution "solution1"
set_part {xcku115-flva1517-2-e} -tool vivado
create_clock -period 5 -name default
csynth_design
export_design -format ip_catalog
exit
