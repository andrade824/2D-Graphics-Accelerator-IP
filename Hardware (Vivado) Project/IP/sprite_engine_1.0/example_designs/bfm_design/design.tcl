proc create_ipi_design { offsetfile design_name } {
	create_bd_design $design_name
	open_bd_design $design_name

	# Create Clock and Reset Ports
	set ACLK [ create_bd_port -dir I -type clk ACLK ]
	set_property -dict [ list CONFIG.FREQ_HZ {100000000} CONFIG.PHASE {0.000} CONFIG.CLK_DOMAIN "${design_name}_ACLK" ] $ACLK
	set ARESETN [ create_bd_port -dir I -type rst ARESETN ]
	set_property -dict [ list CONFIG.POLARITY {ACTIVE_LOW}  ] $ARESETN
	set_property CONFIG.ASSOCIATED_RESET ARESETN $ACLK

	# Create instance: sprite_engine_0, and set properties
	set sprite_engine_0 [ create_bd_cell -type ip -vlnv user.org:user:sprite_engine:1.0 sprite_engine_0]

	# Create External ports
	set M_FRAMEREAD_AXI_INIT_AXI_TXN [ create_bd_port -dir I M_FRAMEREAD_AXI_INIT_AXI_TXN ]
	set M_FRAMEREAD_AXI_ERROR [ create_bd_port -dir O M_FRAMEREAD_AXI_ERROR ]
	set M_FRAMEREAD_AXI_TXN_DONE [ create_bd_port -dir O M_FRAMEREAD_AXI_TXN_DONE ]

	# Create instance: slave_0, and set properties
	set slave_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cdn_axi_bfm slave_0]
	set_property -dict [ list CONFIG.C_PROTOCOL_SELECTION {1} CONFIG.C_MODE_SELECT {1} CONFIG.C_S_AXI4_HIGHADDR {0x4000FFFF} CONFIG.C_S_AXI4_BASEADDR {0x40000000} CONFIG.C_S_AXI4_MEMORY_MODEL_MODE {1} ] $slave_0

connect_bd_intf_net [get_bd_intf_pins slave_0/S_AXI] [get_bd_intf_pins sprite_engine_0/M_FRAMEREAD_AXI]
	# Create port connections
	connect_bd_net -net aclk_net [get_bd_ports ACLK] [get_bd_pins slave_0/S_AXI_ACLK] [get_bd_pins sprite_engine_0/M_FRAMEREAD_AXI_ACLK]
	connect_bd_net -net aresetn_net [get_bd_ports ARESETN] [get_bd_pins slave_0/S_AXI_ARESETN] [get_bd_pins sprite_engine_0/M_FRAMEREAD_AXI_ARESETN]
	connect_bd_net -net init_axi_txn_00 [get_bd_ports M_FRAMEREAD_AXI_INIT_AXI_TXN] [get_bd_pins sprite_engine_0/M_FRAMEREAD_AXI_INIT_AXI_TXN]
	connect_bd_net -net error_00 [get_bd_ports M_FRAMEREAD_AXI_ERROR] [get_bd_pins sprite_engine_0/M_FRAMEREAD_AXI_ERROR]
	connect_bd_net -net txn_done_00 [get_bd_ports M_FRAMEREAD_AXI_TXN_DONE] [get_bd_pins sprite_engine_0/M_FRAMEREAD_AXI_TXN_DONE]

	# Create instance: master_0, and set properties
	set master_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:cdn_axi_bfm master_0]
	set_property -dict [ list CONFIG.C_PROTOCOL_SELECTION {2} ] $master_0

	# Create interface connections
	connect_bd_intf_net [get_bd_intf_pins master_0/M_AXI_LITE] [get_bd_intf_pins sprite_engine_0/S_TEST_AXI]

	# Create port connections
	connect_bd_net -net aclk_net [get_bd_ports ACLK] [get_bd_pins master_0/M_AXI_LITE_ACLK] [get_bd_pins sprite_engine_0/S_TEST_AXI_ACLK]
	connect_bd_net -net aresetn_net [get_bd_ports ARESETN] [get_bd_pins master_0/M_AXI_LITE_ARESETN] [get_bd_pins sprite_engine_0/S_TEST_AXI_ARESETN]

	# Auto assign address
	assign_bd_address

	# Copy all address to interface_address.vh file
	set bd_path [file dirname [get_property NAME [get_files ${design_name}.bd]]]
	upvar 1 $offsetfile offset_file
	set offset_file "${bd_path}/sprite_engine_v1_0_tb_include.vh"
	set fp [open $offset_file "w"]
	puts $fp "`ifndef sprite_engine_v1_0_tb_include_vh_"
	puts $fp "`define sprite_engine_v1_0_tb_include_vh_\n"
	puts $fp "//Configuration current bd names"
	puts $fp "`define BD_INST_NAME ${design_name}_i"
	puts $fp "`define BD_WRAPPER ${design_name}_wrapper\n"
	puts $fp "//Configuration address parameters"

	set offset [get_property OFFSET [get_bd_addr_segs -of_objects [get_bd_addr_spaces master_0/Data_lite]]]
	set offset_hex [string replace $offset 0 1 "32'h"]
	puts $fp "`define S_TEST_AXI_SLAVE_ADDRESS ${offset_hex}"

	puts $fp "`endif"
	close $fp
}

set ip_path [file dirname [file normalize [get_property XML_FILE_NAME [ipx::get_cores user.org:user:sprite_engine:1.0]]]]
set test_bench_file ${ip_path}/example_designs/bfm_design/sprite_engine_v1_0_tb.v
set interface_address_vh_file ""

# Set IP Repository and Update IP Catalogue 
set repo_paths [get_property ip_repo_paths [current_fileset]] 
if { [lsearch -exact -nocase $repo_paths $ip_path ] == -1 } {
	set_property ip_repo_paths "$ip_path [get_property ip_repo_paths [current_fileset]]" [current_fileset]
	update_ip_catalog
}

set design_name ""
set all_bd {}
set all_bd_files [get_files *.bd -quiet]
foreach file $all_bd_files {
set file_name [string range $file [expr {[string last "/" $file] + 1}] end]
set bd_name [string range $file_name 0 [expr {[string last "." $file_name] -1}]]
lappend all_bd $bd_name
}

for { set i 1 } { 1 } { incr i } {
	set design_name "sprite_engine_v1_0_bfm_${i}"
	if { [lsearch -exact -nocase $all_bd $design_name ] == -1 } {
		break
	}
}

create_ipi_design interface_address_vh_file ${design_name}
validate_bd_design

set wrapper_file [make_wrapper -files [get_files ${design_name}.bd] -top -force]
import_files -force -norecurse $wrapper_file

set_property SOURCE_SET sources_1 [get_filesets sim_1]
import_files -fileset sim_1 -norecurse -force $test_bench_file
remove_files -quiet -fileset sim_1 sprite_engine_v1_0_tb_include.vh
import_files -fileset sim_1 -norecurse -force $interface_address_vh_file
set_property top sprite_engine_v1_0_tb [get_filesets sim_1]
set_property top_lib {} [get_filesets sim_1]
set_property top_file {} [get_filesets sim_1]
launch_xsim -simset sim_1 -mode behavioral
restart
run 1000 us
