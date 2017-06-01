# Create Project and build the Block Design
source block_design.tcl
generate_target all [get_files hft_proj/hft_proj.srcs/sources_1/bd/design_1/design_1.bd]

# Make HDL Wrapper
validate_bd_design
make_wrapper -files [get_files ./hft_proj/hft_proj.src/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ./hft_proj/hft_proj.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add XDC
add_files -norecurse ad_8k5.xdc
