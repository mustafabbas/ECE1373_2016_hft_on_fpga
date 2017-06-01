open_project order_book_hls -reset
set_top order_book
add_files order_book_src/priority_queue.cpp
add_files order_book_src/priority_queue.hpp
add_files -tb tb.cpp
open_solution "solution1"
set_part {xcku115-flva1517-2-e} -tool vivado
create_clock -period 5 -name default
csynth_design
export_design -format ip_catalog
exit
