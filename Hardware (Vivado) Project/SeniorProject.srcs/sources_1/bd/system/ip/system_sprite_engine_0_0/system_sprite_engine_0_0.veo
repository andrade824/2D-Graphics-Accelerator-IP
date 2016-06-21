// (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: devonandrade.com:user:sprite_engine:1.0.3
// IP Revision: 26

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
system_sprite_engine_0_0 your_instance_name (
  .pixel_clk(pixel_clk),                              // input wire pixel_clk
  .red(red),                                          // output wire [4 : 0] red
  .green(green),                                      // output wire [5 : 0] green
  .blue(blue),                                        // output wire [4 : 0] blue
  .h_sync(h_sync),                                    // output wire h_sync
  .v_sync(v_sync),                                    // output wire v_sync
  .blank_n(blank_n),                                  // output wire blank_n
  .m_dma_axi_aclk(m_dma_axi_aclk),                    // input wire m_dma_axi_aclk
  .m_dma_axi_aresetn(m_dma_axi_aresetn),              // input wire m_dma_axi_aresetn
  .m_dma_axi_awid(m_dma_axi_awid),                    // output wire m_dma_axi_awid
  .m_dma_axi_awaddr(m_dma_axi_awaddr),                // output wire [31 : 0] m_dma_axi_awaddr
  .m_dma_axi_awlen(m_dma_axi_awlen),                  // output wire [3 : 0] m_dma_axi_awlen
  .m_dma_axi_awsize(m_dma_axi_awsize),                // output wire [2 : 0] m_dma_axi_awsize
  .m_dma_axi_awburst(m_dma_axi_awburst),              // output wire [1 : 0] m_dma_axi_awburst
  .m_dma_axi_awlock(m_dma_axi_awlock),                // output wire m_dma_axi_awlock
  .m_dma_axi_awcache(m_dma_axi_awcache),              // output wire [3 : 0] m_dma_axi_awcache
  .m_dma_axi_awprot(m_dma_axi_awprot),                // output wire [2 : 0] m_dma_axi_awprot
  .m_dma_axi_awqos(m_dma_axi_awqos),                  // output wire [3 : 0] m_dma_axi_awqos
  .m_dma_axi_awvalid(m_dma_axi_awvalid),              // output wire m_dma_axi_awvalid
  .m_dma_axi_awready(m_dma_axi_awready),              // input wire m_dma_axi_awready
  .m_dma_axi_wdata(m_dma_axi_wdata),                  // output wire [31 : 0] m_dma_axi_wdata
  .m_dma_axi_wstrb(m_dma_axi_wstrb),                  // output wire [3 : 0] m_dma_axi_wstrb
  .m_dma_axi_wlast(m_dma_axi_wlast),                  // output wire m_dma_axi_wlast
  .m_dma_axi_wvalid(m_dma_axi_wvalid),                // output wire m_dma_axi_wvalid
  .m_dma_axi_wready(m_dma_axi_wready),                // input wire m_dma_axi_wready
  .m_dma_axi_bid(m_dma_axi_bid),                      // input wire m_dma_axi_bid
  .m_dma_axi_bresp(m_dma_axi_bresp),                  // input wire [1 : 0] m_dma_axi_bresp
  .m_dma_axi_bvalid(m_dma_axi_bvalid),                // input wire m_dma_axi_bvalid
  .m_dma_axi_bready(m_dma_axi_bready),                // output wire m_dma_axi_bready
  .m_dma_axi_arid(m_dma_axi_arid),                    // output wire m_dma_axi_arid
  .m_dma_axi_araddr(m_dma_axi_araddr),                // output wire [31 : 0] m_dma_axi_araddr
  .m_dma_axi_arlen(m_dma_axi_arlen),                  // output wire [3 : 0] m_dma_axi_arlen
  .m_dma_axi_arsize(m_dma_axi_arsize),                // output wire [2 : 0] m_dma_axi_arsize
  .m_dma_axi_arburst(m_dma_axi_arburst),              // output wire [1 : 0] m_dma_axi_arburst
  .m_dma_axi_arlock(m_dma_axi_arlock),                // output wire m_dma_axi_arlock
  .m_dma_axi_arcache(m_dma_axi_arcache),              // output wire [3 : 0] m_dma_axi_arcache
  .m_dma_axi_arprot(m_dma_axi_arprot),                // output wire [2 : 0] m_dma_axi_arprot
  .m_dma_axi_arqos(m_dma_axi_arqos),                  // output wire [3 : 0] m_dma_axi_arqos
  .m_dma_axi_arvalid(m_dma_axi_arvalid),              // output wire m_dma_axi_arvalid
  .m_dma_axi_arready(m_dma_axi_arready),              // input wire m_dma_axi_arready
  .m_dma_axi_rid(m_dma_axi_rid),                      // input wire m_dma_axi_rid
  .m_dma_axi_rdata(m_dma_axi_rdata),                  // input wire [31 : 0] m_dma_axi_rdata
  .m_dma_axi_rresp(m_dma_axi_rresp),                  // input wire [1 : 0] m_dma_axi_rresp
  .m_dma_axi_rlast(m_dma_axi_rlast),                  // input wire m_dma_axi_rlast
  .m_dma_axi_rvalid(m_dma_axi_rvalid),                // input wire m_dma_axi_rvalid
  .m_dma_axi_rready(m_dma_axi_rready),                // output wire m_dma_axi_rready
  .m_frameread_axi_aclk(m_frameread_axi_aclk),        // input wire m_frameread_axi_aclk
  .m_frameread_axi_aresetn(m_frameread_axi_aresetn),  // input wire m_frameread_axi_aresetn
  .m_frameread_axi_arid(m_frameread_axi_arid),        // output wire [0 : 0] m_frameread_axi_arid
  .m_frameread_axi_araddr(m_frameread_axi_araddr),    // output wire [31 : 0] m_frameread_axi_araddr
  .m_frameread_axi_arlen(m_frameread_axi_arlen),      // output wire [3 : 0] m_frameread_axi_arlen
  .m_frameread_axi_arsize(m_frameread_axi_arsize),    // output wire [2 : 0] m_frameread_axi_arsize
  .m_frameread_axi_arburst(m_frameread_axi_arburst),  // output wire [1 : 0] m_frameread_axi_arburst
  .m_frameread_axi_arlock(m_frameread_axi_arlock),    // output wire m_frameread_axi_arlock
  .m_frameread_axi_arcache(m_frameread_axi_arcache),  // output wire [3 : 0] m_frameread_axi_arcache
  .m_frameread_axi_arprot(m_frameread_axi_arprot),    // output wire [2 : 0] m_frameread_axi_arprot
  .m_frameread_axi_arqos(m_frameread_axi_arqos),      // output wire [3 : 0] m_frameread_axi_arqos
  .m_frameread_axi_arvalid(m_frameread_axi_arvalid),  // output wire m_frameread_axi_arvalid
  .m_frameread_axi_arready(m_frameread_axi_arready),  // input wire m_frameread_axi_arready
  .m_frameread_axi_rid(m_frameread_axi_rid),          // input wire [0 : 0] m_frameread_axi_rid
  .m_frameread_axi_rdata(m_frameread_axi_rdata),      // input wire [31 : 0] m_frameread_axi_rdata
  .m_frameread_axi_rresp(m_frameread_axi_rresp),      // input wire [1 : 0] m_frameread_axi_rresp
  .m_frameread_axi_rlast(m_frameread_axi_rlast),      // input wire m_frameread_axi_rlast
  .m_frameread_axi_rvalid(m_frameread_axi_rvalid),    // input wire m_frameread_axi_rvalid
  .m_frameread_axi_rready(m_frameread_axi_rready),    // output wire m_frameread_axi_rready
  .s00_axi_aclk(s00_axi_aclk),                        // input wire s00_axi_aclk
  .s00_axi_aresetn(s00_axi_aresetn),                  // input wire s00_axi_aresetn
  .s00_axi_awaddr(s00_axi_awaddr),                    // input wire [15 : 0] s00_axi_awaddr
  .s00_axi_awprot(s00_axi_awprot),                    // input wire [2 : 0] s00_axi_awprot
  .s00_axi_awvalid(s00_axi_awvalid),                  // input wire s00_axi_awvalid
  .s00_axi_awready(s00_axi_awready),                  // output wire s00_axi_awready
  .s00_axi_wdata(s00_axi_wdata),                      // input wire [31 : 0] s00_axi_wdata
  .s00_axi_wstrb(s00_axi_wstrb),                      // input wire [3 : 0] s00_axi_wstrb
  .s00_axi_wvalid(s00_axi_wvalid),                    // input wire s00_axi_wvalid
  .s00_axi_wready(s00_axi_wready),                    // output wire s00_axi_wready
  .s00_axi_bresp(s00_axi_bresp),                      // output wire [1 : 0] s00_axi_bresp
  .s00_axi_bvalid(s00_axi_bvalid),                    // output wire s00_axi_bvalid
  .s00_axi_bready(s00_axi_bready),                    // input wire s00_axi_bready
  .s00_axi_araddr(s00_axi_araddr),                    // input wire [15 : 0] s00_axi_araddr
  .s00_axi_arprot(s00_axi_arprot),                    // input wire [2 : 0] s00_axi_arprot
  .s00_axi_arvalid(s00_axi_arvalid),                  // input wire s00_axi_arvalid
  .s00_axi_arready(s00_axi_arready),                  // output wire s00_axi_arready
  .s00_axi_rdata(s00_axi_rdata),                      // output wire [31 : 0] s00_axi_rdata
  .s00_axi_rresp(s00_axi_rresp),                      // output wire [1 : 0] s00_axi_rresp
  .s00_axi_rvalid(s00_axi_rvalid),                    // output wire s00_axi_rvalid
  .s00_axi_rready(s00_axi_rready)                    // input wire s00_axi_rready
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

