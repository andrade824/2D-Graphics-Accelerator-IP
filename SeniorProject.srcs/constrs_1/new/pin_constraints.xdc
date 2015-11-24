set_property IOSTANDARD LVCMOS33 [get_ports {blue[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[0]}]
set_property PACKAGE_PIN G19 [get_ports {blue[4]}]
set_property PACKAGE_PIN J18 [get_ports {blue[3]}]
set_property PACKAGE_PIN K19 [get_ports {blue[2]}]
set_property PACKAGE_PIN M20 [get_ports {blue[1]}]
set_property PACKAGE_PIN P20 [get_ports {blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports h_sync]
set_property IOSTANDARD LVCMOS33 [get_ports v_sync]
set_property PACKAGE_PIN P19 [get_ports h_sync]
set_property PACKAGE_PIN R19 [get_ports v_sync]
set_property PACKAGE_PIN F20 [get_ports {green[5]}]
set_property PACKAGE_PIN H20 [get_ports {green[4]}]
set_property PACKAGE_PIN J19 [get_ports {green[3]}]
set_property PACKAGE_PIN L19 [get_ports {green[2]}]
set_property PACKAGE_PIN N20 [get_ports {green[1]}]
set_property PACKAGE_PIN H18 [get_ports {green[0]}]
set_property PACKAGE_PIN F19 [get_ports {red[4]}]
set_property PACKAGE_PIN G20 [get_ports {red[3]}]
set_property PACKAGE_PIN J20 [get_ports {red[2]}]
set_property PACKAGE_PIN L20 [get_ports {red[1]}]
set_property PACKAGE_PIN M19 [get_ports {red[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports {btns_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns_tri_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns_tri_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btns_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_tri_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_tri_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_tri_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_tri_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches_tri_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches_tri_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switches_tri_i[0]}]
set_property PACKAGE_PIN Y16 [get_ports {btns_tri_i[3]}]
set_property PACKAGE_PIN V16 [get_ports {btns_tri_i[2]}]
set_property PACKAGE_PIN P16 [get_ports {btns_tri_i[1]}]
set_property PACKAGE_PIN R18 [get_ports {btns_tri_i[0]}]
set_property PACKAGE_PIN D18 [get_ports {leds_tri_o[3]}]
set_property PACKAGE_PIN G14 [get_ports {leds_tri_o[2]}]
set_property PACKAGE_PIN M15 [get_ports {leds_tri_o[1]}]
set_property PACKAGE_PIN M14 [get_ports {leds_tri_o[0]}]
set_property PACKAGE_PIN T16 [get_ports {switches_tri_i[3]}]
set_property PACKAGE_PIN W13 [get_ports {switches_tri_i[2]}]
set_property PACKAGE_PIN P15 [get_ports {switches_tri_i[1]}]
set_property PACKAGE_PIN G15 [get_ports {switches_tri_i[0]}]




set_property MARK_DEBUG true [get_nets system_i/sprite_engine_0/inst/posedge_sync_inst_n_0]

set_property MARK_DEBUG true [get_nets system_i/sprite_engine_0/inst/blank_n]
set_property MARK_DEBUG true [get_nets system_i/sprite_engine_0/inst/v_sync]
set_property MARK_DEBUG true [get_nets system_i/sprite_engine_0/inst/v_blank]
connect_debug_port u_ila_1/probe10 [get_nets [list system_i/sprite_engine_0/inst/posedge_sync_inst_n_0]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list system_i/clk_wiz_0/inst/clk_out1]]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {system_i/sprite_engine_0/inst/framereader_inst/current_state[0]} {system_i/sprite_engine_0/inst/framereader_inst/current_state[1]}]]
create_debug_core u_ila_1_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_1_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1_0]
set_property port_width 1 [get_debug_ports u_ila_1_0/clk]
connect_debug_port u_ila_1_0/clk [get_nets [list system_i/clk_wiz_0/inst/clk_out2]]
set_property port_width 1 [get_debug_ports u_ila_1_0/probe0]
connect_debug_port u_ila_1_0/probe0 [get_nets [list system_i/sprite_engine_0/inst/blank_n]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[0]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[1]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[2]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[3]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[4]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[5]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[6]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[7]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[8]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[9]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[10]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[11]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[12]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[13]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[14]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[15]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[16]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[17]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[18]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[19]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[20]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[21]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[22]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[23]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[24]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[25]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[26]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[27]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[28]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[29]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[30]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_RDATA[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[0]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[1]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[2]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[3]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[4]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[5]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[6]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[7]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[8]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[9]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[10]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[11]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[12]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[13]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[14]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[15]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[16]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[17]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[18]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[19]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[20]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[21]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[22]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[23]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[24]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[25]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[26]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[27]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[28]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[29]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[30]} {system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARADDR[31]}]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARREADY]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list system_i/sprite_engine_0_M_FRAMEREAD_AXI_ARVALID]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list system_i/sprite_engine_0_M_FRAMEREAD_AXI_RLAST]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list system_i/sprite_engine_0_M_FRAMEREAD_AXI_RREADY]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list system_i/sprite_engine_0_M_FRAMEREAD_AXI_RVALID]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe1]
connect_debug_port u_ila_1_0/probe1 [get_nets [list system_i/sprite_engine_0/inst/v_blank]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe2]
connect_debug_port u_ila_1_0/probe2 [get_nets [list system_i/sprite_engine_0/inst/v_sync]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe3]
connect_debug_port u_ila_1_0/probe3 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[0]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe4]
connect_debug_port u_ila_1_0/probe4 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[1]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe5]
connect_debug_port u_ila_1_0/probe5 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[2]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe6]
connect_debug_port u_ila_1_0/probe6 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[3]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe7]
connect_debug_port u_ila_1_0/probe7 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[4]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe8]
connect_debug_port u_ila_1_0/probe8 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[5]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe9]
connect_debug_port u_ila_1_0/probe9 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[6]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe10]
connect_debug_port u_ila_1_0/probe10 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[7]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe11]
connect_debug_port u_ila_1_0/probe11 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[8]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe12]
connect_debug_port u_ila_1_0/probe12 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[9]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe13]
connect_debug_port u_ila_1_0/probe13 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[10]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe14]
connect_debug_port u_ila_1_0/probe14 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[11]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe15]
connect_debug_port u_ila_1_0/probe15 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[12]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe16]
connect_debug_port u_ila_1_0/probe16 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[13]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe17]
connect_debug_port u_ila_1_0/probe17 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[14]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe18]
connect_debug_port u_ila_1_0/probe18 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[15]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe19]
connect_debug_port u_ila_1_0/probe19 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[16]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe20]
connect_debug_port u_ila_1_0/probe20 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[17]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe21]
connect_debug_port u_ila_1_0/probe21 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[18]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe22]
connect_debug_port u_ila_1_0/probe22 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[19]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe23]
connect_debug_port u_ila_1_0/probe23 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[20]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe24]
connect_debug_port u_ila_1_0/probe24 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[21]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe25]
connect_debug_port u_ila_1_0/probe25 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[22]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe26]
connect_debug_port u_ila_1_0/probe26 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[23]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe27]
connect_debug_port u_ila_1_0/probe27 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[24]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe28]
connect_debug_port u_ila_1_0/probe28 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[25]}]]
create_debug_port u_ila_1_0 probe
set_property port_width 1 [get_debug_ports u_ila_1_0/probe29]
connect_debug_port u_ila_1_0/probe29 [get_nets [list {system_i/sprite_engine_0/inst/sync_gen_1/pixel_cache_reg_n_0_[26]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out1]
