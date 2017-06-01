open_project fast_hls -reset
set_top fast_protocol
add_files fast_src/fast_decoder.cpp
add_files fast_src/fast_decoder.h
add_files fast_src/fast_encoder.cpp
add_files fast_src/fast_encoder.h
add_files fast_src/fast_protocol.cpp
add_files fast_src/fast_protocol.h
add_files -tb fast_src/in.dat
add_files -tb fast_src/out.dat
add_files -tb fast_src/test_bench.cpp
open_solution "solution1"
set_part {xcku115-flva1517-2-e} -tool vivado
create_clock -period 5 -name default
csynth_design
export_design -format ip_catalog
exit
