-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: devonandrade.com:user:sprite_engine:1.0.3
-- IP Revision: 26

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT system_sprite_engine_0_0
  PORT (
    pixel_clk : IN STD_LOGIC;
    red : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    green : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    blue : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    h_sync : OUT STD_LOGIC;
    v_sync : OUT STD_LOGIC;
    blank_n : OUT STD_LOGIC;
    m_dma_axi_aclk : IN STD_LOGIC;
    m_dma_axi_aresetn : IN STD_LOGIC;
    m_dma_axi_awid : OUT STD_LOGIC;
    m_dma_axi_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_dma_axi_awlen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_dma_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_dma_axi_awlock : OUT STD_LOGIC;
    m_dma_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_dma_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_awvalid : OUT STD_LOGIC;
    m_dma_axi_awready : IN STD_LOGIC;
    m_dma_axi_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_dma_axi_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_wlast : OUT STD_LOGIC;
    m_dma_axi_wvalid : OUT STD_LOGIC;
    m_dma_axi_wready : IN STD_LOGIC;
    m_dma_axi_bid : IN STD_LOGIC;
    m_dma_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_dma_axi_bvalid : IN STD_LOGIC;
    m_dma_axi_bready : OUT STD_LOGIC;
    m_dma_axi_arid : OUT STD_LOGIC;
    m_dma_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_dma_axi_arlen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_dma_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_dma_axi_arlock : OUT STD_LOGIC;
    m_dma_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_dma_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_dma_axi_arvalid : OUT STD_LOGIC;
    m_dma_axi_arready : IN STD_LOGIC;
    m_dma_axi_rid : IN STD_LOGIC;
    m_dma_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_dma_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_dma_axi_rlast : IN STD_LOGIC;
    m_dma_axi_rvalid : IN STD_LOGIC;
    m_dma_axi_rready : OUT STD_LOGIC;
    m_frameread_axi_aclk : IN STD_LOGIC;
    m_frameread_axi_aresetn : IN STD_LOGIC;
    m_frameread_axi_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_frameread_axi_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_frameread_axi_arlen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_frameread_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_frameread_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_frameread_axi_arlock : OUT STD_LOGIC;
    m_frameread_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_frameread_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_frameread_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_frameread_axi_arvalid : OUT STD_LOGIC;
    m_frameread_axi_arready : IN STD_LOGIC;
    m_frameread_axi_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_frameread_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_frameread_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_frameread_axi_rlast : IN STD_LOGIC;
    m_frameread_axi_rvalid : IN STD_LOGIC;
    m_frameread_axi_rready : OUT STD_LOGIC;
    s00_axi_aclk : IN STD_LOGIC;
    s00_axi_aresetn : IN STD_LOGIC;
    s00_axi_awaddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s00_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_awvalid : IN STD_LOGIC;
    s00_axi_awready : OUT STD_LOGIC;
    s00_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s00_axi_wvalid : IN STD_LOGIC;
    s00_axi_wready : OUT STD_LOGIC;
    s00_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_bvalid : OUT STD_LOGIC;
    s00_axi_bready : IN STD_LOGIC;
    s00_axi_araddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s00_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_arvalid : IN STD_LOGIC;
    s00_axi_arready : OUT STD_LOGIC;
    s00_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_rvalid : OUT STD_LOGIC;
    s00_axi_rready : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : system_sprite_engine_0_0
  PORT MAP (
    pixel_clk => pixel_clk,
    red => red,
    green => green,
    blue => blue,
    h_sync => h_sync,
    v_sync => v_sync,
    blank_n => blank_n,
    m_dma_axi_aclk => m_dma_axi_aclk,
    m_dma_axi_aresetn => m_dma_axi_aresetn,
    m_dma_axi_awid => m_dma_axi_awid,
    m_dma_axi_awaddr => m_dma_axi_awaddr,
    m_dma_axi_awlen => m_dma_axi_awlen,
    m_dma_axi_awsize => m_dma_axi_awsize,
    m_dma_axi_awburst => m_dma_axi_awburst,
    m_dma_axi_awlock => m_dma_axi_awlock,
    m_dma_axi_awcache => m_dma_axi_awcache,
    m_dma_axi_awprot => m_dma_axi_awprot,
    m_dma_axi_awqos => m_dma_axi_awqos,
    m_dma_axi_awvalid => m_dma_axi_awvalid,
    m_dma_axi_awready => m_dma_axi_awready,
    m_dma_axi_wdata => m_dma_axi_wdata,
    m_dma_axi_wstrb => m_dma_axi_wstrb,
    m_dma_axi_wlast => m_dma_axi_wlast,
    m_dma_axi_wvalid => m_dma_axi_wvalid,
    m_dma_axi_wready => m_dma_axi_wready,
    m_dma_axi_bid => m_dma_axi_bid,
    m_dma_axi_bresp => m_dma_axi_bresp,
    m_dma_axi_bvalid => m_dma_axi_bvalid,
    m_dma_axi_bready => m_dma_axi_bready,
    m_dma_axi_arid => m_dma_axi_arid,
    m_dma_axi_araddr => m_dma_axi_araddr,
    m_dma_axi_arlen => m_dma_axi_arlen,
    m_dma_axi_arsize => m_dma_axi_arsize,
    m_dma_axi_arburst => m_dma_axi_arburst,
    m_dma_axi_arlock => m_dma_axi_arlock,
    m_dma_axi_arcache => m_dma_axi_arcache,
    m_dma_axi_arprot => m_dma_axi_arprot,
    m_dma_axi_arqos => m_dma_axi_arqos,
    m_dma_axi_arvalid => m_dma_axi_arvalid,
    m_dma_axi_arready => m_dma_axi_arready,
    m_dma_axi_rid => m_dma_axi_rid,
    m_dma_axi_rdata => m_dma_axi_rdata,
    m_dma_axi_rresp => m_dma_axi_rresp,
    m_dma_axi_rlast => m_dma_axi_rlast,
    m_dma_axi_rvalid => m_dma_axi_rvalid,
    m_dma_axi_rready => m_dma_axi_rready,
    m_frameread_axi_aclk => m_frameread_axi_aclk,
    m_frameread_axi_aresetn => m_frameread_axi_aresetn,
    m_frameread_axi_arid => m_frameread_axi_arid,
    m_frameread_axi_araddr => m_frameread_axi_araddr,
    m_frameread_axi_arlen => m_frameread_axi_arlen,
    m_frameread_axi_arsize => m_frameread_axi_arsize,
    m_frameread_axi_arburst => m_frameread_axi_arburst,
    m_frameread_axi_arlock => m_frameread_axi_arlock,
    m_frameread_axi_arcache => m_frameread_axi_arcache,
    m_frameread_axi_arprot => m_frameread_axi_arprot,
    m_frameread_axi_arqos => m_frameread_axi_arqos,
    m_frameread_axi_arvalid => m_frameread_axi_arvalid,
    m_frameread_axi_arready => m_frameread_axi_arready,
    m_frameread_axi_rid => m_frameread_axi_rid,
    m_frameread_axi_rdata => m_frameread_axi_rdata,
    m_frameread_axi_rresp => m_frameread_axi_rresp,
    m_frameread_axi_rlast => m_frameread_axi_rlast,
    m_frameread_axi_rvalid => m_frameread_axi_rvalid,
    m_frameread_axi_rready => m_frameread_axi_rready,
    s00_axi_aclk => s00_axi_aclk,
    s00_axi_aresetn => s00_axi_aresetn,
    s00_axi_awaddr => s00_axi_awaddr,
    s00_axi_awprot => s00_axi_awprot,
    s00_axi_awvalid => s00_axi_awvalid,
    s00_axi_awready => s00_axi_awready,
    s00_axi_wdata => s00_axi_wdata,
    s00_axi_wstrb => s00_axi_wstrb,
    s00_axi_wvalid => s00_axi_wvalid,
    s00_axi_wready => s00_axi_wready,
    s00_axi_bresp => s00_axi_bresp,
    s00_axi_bvalid => s00_axi_bvalid,
    s00_axi_bready => s00_axi_bready,
    s00_axi_araddr => s00_axi_araddr,
    s00_axi_arprot => s00_axi_arprot,
    s00_axi_arvalid => s00_axi_arvalid,
    s00_axi_arready => s00_axi_arready,
    s00_axi_rdata => s00_axi_rdata,
    s00_axi_rresp => s00_axi_rresp,
    s00_axi_rvalid => s00_axi_rvalid,
    s00_axi_rready => s00_axi_rready
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

