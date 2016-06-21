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

(* X_CORE_INFO = "sprite_engine_v1_0,Vivado 2015.4" *)
(* CHECK_LICENSE_TYPE = "system_sprite_engine_0_0,sprite_engine_v1_0,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_sprite_engine_0_0 (
  pixel_clk,
  red,
  green,
  blue,
  h_sync,
  v_sync,
  blank_n,
  m_dma_axi_aclk,
  m_dma_axi_aresetn,
  m_dma_axi_awid,
  m_dma_axi_awaddr,
  m_dma_axi_awlen,
  m_dma_axi_awsize,
  m_dma_axi_awburst,
  m_dma_axi_awlock,
  m_dma_axi_awcache,
  m_dma_axi_awprot,
  m_dma_axi_awqos,
  m_dma_axi_awvalid,
  m_dma_axi_awready,
  m_dma_axi_wdata,
  m_dma_axi_wstrb,
  m_dma_axi_wlast,
  m_dma_axi_wvalid,
  m_dma_axi_wready,
  m_dma_axi_bid,
  m_dma_axi_bresp,
  m_dma_axi_bvalid,
  m_dma_axi_bready,
  m_dma_axi_arid,
  m_dma_axi_araddr,
  m_dma_axi_arlen,
  m_dma_axi_arsize,
  m_dma_axi_arburst,
  m_dma_axi_arlock,
  m_dma_axi_arcache,
  m_dma_axi_arprot,
  m_dma_axi_arqos,
  m_dma_axi_arvalid,
  m_dma_axi_arready,
  m_dma_axi_rid,
  m_dma_axi_rdata,
  m_dma_axi_rresp,
  m_dma_axi_rlast,
  m_dma_axi_rvalid,
  m_dma_axi_rready,
  m_frameread_axi_aclk,
  m_frameread_axi_aresetn,
  m_frameread_axi_arid,
  m_frameread_axi_araddr,
  m_frameread_axi_arlen,
  m_frameread_axi_arsize,
  m_frameread_axi_arburst,
  m_frameread_axi_arlock,
  m_frameread_axi_arcache,
  m_frameread_axi_arprot,
  m_frameread_axi_arqos,
  m_frameread_axi_arvalid,
  m_frameread_axi_arready,
  m_frameread_axi_rid,
  m_frameread_axi_rdata,
  m_frameread_axi_rresp,
  m_frameread_axi_rlast,
  m_frameread_axi_rvalid,
  m_frameread_axi_rready,
  s00_axi_aclk,
  s00_axi_aresetn,
  s00_axi_awaddr,
  s00_axi_awprot,
  s00_axi_awvalid,
  s00_axi_awready,
  s00_axi_wdata,
  s00_axi_wstrb,
  s00_axi_wvalid,
  s00_axi_wready,
  s00_axi_bresp,
  s00_axi_bvalid,
  s00_axi_bready,
  s00_axi_araddr,
  s00_axi_arprot,
  s00_axi_arvalid,
  s00_axi_arready,
  s00_axi_rdata,
  s00_axi_rresp,
  s00_axi_rvalid,
  s00_axi_rready
);

input wire pixel_clk;
output wire [4 : 0] red;
output wire [5 : 0] green;
output wire [4 : 0] blue;
output wire h_sync;
output wire v_sync;
output wire blank_n;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m_dma_axi_aclk CLK" *)
input wire m_dma_axi_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 m_dma_axi_aresetn RST" *)
input wire m_dma_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWID" *)
output wire m_dma_axi_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWADDR" *)
output wire [31 : 0] m_dma_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWLEN" *)
output wire [3 : 0] m_dma_axi_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWSIZE" *)
output wire [2 : 0] m_dma_axi_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWBURST" *)
output wire [1 : 0] m_dma_axi_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWLOCK" *)
output wire m_dma_axi_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWCACHE" *)
output wire [3 : 0] m_dma_axi_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWPROT" *)
output wire [2 : 0] m_dma_axi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWQOS" *)
output wire [3 : 0] m_dma_axi_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWVALID" *)
output wire m_dma_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI AWREADY" *)
input wire m_dma_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI WDATA" *)
output wire [31 : 0] m_dma_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI WSTRB" *)
output wire [3 : 0] m_dma_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI WLAST" *)
output wire m_dma_axi_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI WVALID" *)
output wire m_dma_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI WREADY" *)
input wire m_dma_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI BID" *)
input wire m_dma_axi_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI BRESP" *)
input wire [1 : 0] m_dma_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI BVALID" *)
input wire m_dma_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI BREADY" *)
output wire m_dma_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARID" *)
output wire m_dma_axi_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARADDR" *)
output wire [31 : 0] m_dma_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARLEN" *)
output wire [3 : 0] m_dma_axi_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARSIZE" *)
output wire [2 : 0] m_dma_axi_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARBURST" *)
output wire [1 : 0] m_dma_axi_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARLOCK" *)
output wire m_dma_axi_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARCACHE" *)
output wire [3 : 0] m_dma_axi_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARPROT" *)
output wire [2 : 0] m_dma_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARQOS" *)
output wire [3 : 0] m_dma_axi_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARVALID" *)
output wire m_dma_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI ARREADY" *)
input wire m_dma_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RID" *)
input wire m_dma_axi_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RDATA" *)
input wire [31 : 0] m_dma_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RRESP" *)
input wire [1 : 0] m_dma_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RLAST" *)
input wire m_dma_axi_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RVALID" *)
input wire m_dma_axi_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DMA_AXI RREADY" *)
output wire m_dma_axi_rready;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M_FRAMEREAD_AXI_CLK CLK, xilinx.com:signal:clock:1.0 m_frameread_axi_aclk CLK" *)
input wire m_frameread_axi_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M_FRAMEREAD_AXI_RST RST, xilinx.com:signal:reset:1.0 m_frameread_axi_aresetn RST" *)
input wire m_frameread_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARID" *)
output wire [0 : 0] m_frameread_axi_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARADDR" *)
output wire [31 : 0] m_frameread_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARLEN" *)
output wire [3 : 0] m_frameread_axi_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARSIZE" *)
output wire [2 : 0] m_frameread_axi_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARBURST" *)
output wire [1 : 0] m_frameread_axi_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARLOCK" *)
output wire m_frameread_axi_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARCACHE" *)
output wire [3 : 0] m_frameread_axi_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARPROT" *)
output wire [2 : 0] m_frameread_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARQOS" *)
output wire [3 : 0] m_frameread_axi_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARVALID" *)
output wire m_frameread_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI ARREADY" *)
input wire m_frameread_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RID" *)
input wire [0 : 0] m_frameread_axi_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RDATA" *)
input wire [31 : 0] m_frameread_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RRESP" *)
input wire [1 : 0] m_frameread_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RLAST" *)
input wire m_frameread_axi_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RVALID" *)
input wire m_frameread_axi_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_FRAMEREAD_AXI RREADY" *)
output wire m_frameread_axi_rready;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_test_axi_aclk CLK" *)
input wire s00_axi_aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_test_axi_aresetn RST" *)
input wire s00_axi_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI AWADDR" *)
input wire [15 : 0] s00_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI AWPROT" *)
input wire [2 : 0] s00_axi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI AWVALID" *)
input wire s00_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI AWREADY" *)
output wire s00_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI WDATA" *)
input wire [31 : 0] s00_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI WSTRB" *)
input wire [3 : 0] s00_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI WVALID" *)
input wire s00_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI WREADY" *)
output wire s00_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI BRESP" *)
output wire [1 : 0] s00_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI BVALID" *)
output wire s00_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI BREADY" *)
input wire s00_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI ARADDR" *)
input wire [15 : 0] s00_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI ARPROT" *)
input wire [2 : 0] s00_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI ARVALID" *)
input wire s00_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI ARREADY" *)
output wire s00_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI RDATA" *)
output wire [31 : 0] s00_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI RRESP" *)
output wire [1 : 0] s00_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI RVALID" *)
output wire s00_axi_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_CMD_AXI RREADY" *)
input wire s00_axi_rready;

  sprite_engine_v1_0 #(
    .C_M_FRAMEREAD_AXI_BURST_LEN(16),  // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    .C_M_FRAMEREAD_AXI_ADDR_WIDTH(32),  // Width of Address Bus
    .C_M_FRAMEREAD_AXI_DATA_WIDTH(32),  // Width of Data Bus
    .H_VISIBLE(640),
    .H_FRONT_PORCH(16),
    .H_SYNC(96),
    .H_BACK_PORCH(48),
    .V_VISIBLE(480),
    .V_FRONT_PORCH(10),
    .V_SYNC(2),
    .V_BACK_PORCH(33),
    .C_M_AXI_DMA_MAX_BURST_LEN(16),
    .C_M_AXI_DMA_ADDR_WIDTH(32),
    .C_M_AXI_DMA_DATA_WIDTH(32),
    .C_S00_AXI_DATA_WIDTH(32),
    .C_S00_AXI_ADDR_WIDTH(16),
    .MAX_SPRITES(256)
  ) inst (
    .pixel_clk(pixel_clk),
    .red(red),
    .green(green),
    .blue(blue),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .blank_n(blank_n),
    .m_dma_axi_aclk(m_dma_axi_aclk),
    .m_dma_axi_aresetn(m_dma_axi_aresetn),
    .m_dma_axi_awid(m_dma_axi_awid),
    .m_dma_axi_awaddr(m_dma_axi_awaddr),
    .m_dma_axi_awlen(m_dma_axi_awlen),
    .m_dma_axi_awsize(m_dma_axi_awsize),
    .m_dma_axi_awburst(m_dma_axi_awburst),
    .m_dma_axi_awlock(m_dma_axi_awlock),
    .m_dma_axi_awcache(m_dma_axi_awcache),
    .m_dma_axi_awprot(m_dma_axi_awprot),
    .m_dma_axi_awqos(m_dma_axi_awqos),
    .m_dma_axi_awvalid(m_dma_axi_awvalid),
    .m_dma_axi_awready(m_dma_axi_awready),
    .m_dma_axi_wdata(m_dma_axi_wdata),
    .m_dma_axi_wstrb(m_dma_axi_wstrb),
    .m_dma_axi_wlast(m_dma_axi_wlast),
    .m_dma_axi_wvalid(m_dma_axi_wvalid),
    .m_dma_axi_wready(m_dma_axi_wready),
    .m_dma_axi_bid(m_dma_axi_bid),
    .m_dma_axi_bresp(m_dma_axi_bresp),
    .m_dma_axi_bvalid(m_dma_axi_bvalid),
    .m_dma_axi_bready(m_dma_axi_bready),
    .m_dma_axi_arid(m_dma_axi_arid),
    .m_dma_axi_araddr(m_dma_axi_araddr),
    .m_dma_axi_arlen(m_dma_axi_arlen),
    .m_dma_axi_arsize(m_dma_axi_arsize),
    .m_dma_axi_arburst(m_dma_axi_arburst),
    .m_dma_axi_arlock(m_dma_axi_arlock),
    .m_dma_axi_arcache(m_dma_axi_arcache),
    .m_dma_axi_arprot(m_dma_axi_arprot),
    .m_dma_axi_arqos(m_dma_axi_arqos),
    .m_dma_axi_arvalid(m_dma_axi_arvalid),
    .m_dma_axi_arready(m_dma_axi_arready),
    .m_dma_axi_rid(m_dma_axi_rid),
    .m_dma_axi_rdata(m_dma_axi_rdata),
    .m_dma_axi_rresp(m_dma_axi_rresp),
    .m_dma_axi_rlast(m_dma_axi_rlast),
    .m_dma_axi_rvalid(m_dma_axi_rvalid),
    .m_dma_axi_rready(m_dma_axi_rready),
    .m_frameread_axi_aclk(m_frameread_axi_aclk),
    .m_frameread_axi_aresetn(m_frameread_axi_aresetn),
    .m_frameread_axi_arid(m_frameread_axi_arid),
    .m_frameread_axi_araddr(m_frameread_axi_araddr),
    .m_frameread_axi_arlen(m_frameread_axi_arlen),
    .m_frameread_axi_arsize(m_frameread_axi_arsize),
    .m_frameread_axi_arburst(m_frameread_axi_arburst),
    .m_frameread_axi_arlock(m_frameread_axi_arlock),
    .m_frameread_axi_arcache(m_frameread_axi_arcache),
    .m_frameread_axi_arprot(m_frameread_axi_arprot),
    .m_frameread_axi_arqos(m_frameread_axi_arqos),
    .m_frameread_axi_arvalid(m_frameread_axi_arvalid),
    .m_frameread_axi_arready(m_frameread_axi_arready),
    .m_frameread_axi_rid(m_frameread_axi_rid),
    .m_frameread_axi_rdata(m_frameread_axi_rdata),
    .m_frameread_axi_rresp(m_frameread_axi_rresp),
    .m_frameread_axi_rlast(m_frameread_axi_rlast),
    .m_frameread_axi_rvalid(m_frameread_axi_rvalid),
    .m_frameread_axi_rready(m_frameread_axi_rready),
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready)
  );
endmodule
