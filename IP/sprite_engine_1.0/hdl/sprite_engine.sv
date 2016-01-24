`timescale 1 ns / 1 ps

module sprite_engine_v1_0 #
(
    // Horizontal timing parameters
    parameter H_VISIBLE = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC = 96,
    parameter H_BACK_PORCH = 48,

    // Vertical timing parameters
    parameter V_VISIBLE = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC = 2,
    parameter V_BACK_PORCH = 33,

    // Parameters of Axi Master Bus Interface M_FRAMEREAD_AXI
    parameter integer C_M_FRAMEREAD_AXI_BURST_LEN	= 16,
    parameter integer C_M_FRAMEREAD_AXI_ID_WIDTH	= 1,
    parameter integer C_M_FRAMEREAD_AXI_ADDR_WIDTH	= 32,
    parameter integer C_M_FRAMEREAD_AXI_DATA_WIDTH	= 32,
    parameter integer C_M_FRAMEREAD_AXI_ARUSER_WIDTH = 0,
    parameter integer C_M_FRAMEREAD_AXI_RUSER_WIDTH = 0,
    
    // Parameters of Axi Slave Bus Interface S_TEST_AXI
    parameter integer C_S_TEST_AXI_DATA_WIDTH	= 32,
    parameter integer C_S_TEST_AXI_ADDR_WIDTH	= 4
)
(
    // Sync gen ports
    input wire pixel_clk,
    output wire [4:0] red,
    output wire [5:0] green,
    output wire [4:0] blue,
    output wire h_sync, v_sync,
    output wire blank_n,

    // Ports of Axi Master Bus Interface M_FRAMEREAD_AXI
    input wire  m_frameread_axi_aclk,
    input wire  m_frameread_axi_aresetn,
    output wire [C_M_FRAMEREAD_AXI_ID_WIDTH-1 : 0] m_frameread_axi_arid,
    output wire [C_M_FRAMEREAD_AXI_ADDR_WIDTH-1 : 0] m_frameread_axi_araddr,
    output wire [7 : 0] m_frameread_axi_arlen,
    output wire [2 : 0] m_frameread_axi_arsize,
    output wire [1 : 0] m_frameread_axi_arburst,
    output wire  m_frameread_axi_arlock,
    output wire [3 : 0] m_frameread_axi_arcache,
    output wire [2 : 0] m_frameread_axi_arprot,
    output wire [3 : 0] m_frameread_axi_arqos,
    output wire [C_M_FRAMEREAD_AXI_ARUSER_WIDTH-1 : 0] m_frameread_axi_aruser,
    output wire  m_frameread_axi_arvalid,
    input wire  m_frameread_axi_arready,
    input wire [C_M_FRAMEREAD_AXI_ID_WIDTH-1 : 0] m_frameread_axi_rid,
    input wire [C_M_FRAMEREAD_AXI_DATA_WIDTH-1 : 0] m_frameread_axi_rdata,
    input wire [1 : 0] m_frameread_axi_rresp,
    input wire  m_frameread_axi_rlast,
    input wire [C_M_FRAMEREAD_AXI_RUSER_WIDTH-1 : 0] m_frameread_axi_ruser,
    input wire  m_frameread_axi_rvalid,
    output wire  m_frameread_axi_rready,

    // Ports of Axi Slave Bus Interface S_TEST_AXI
    input wire  s_test_axi_aclk,
    input wire  s_test_axi_aresetn,
    input wire [C_S_TEST_AXI_ADDR_WIDTH-1 : 0] s_test_axi_awaddr,
    input wire [2 : 0] s_test_axi_awprot,
    input wire  s_test_axi_awvalid,
    output wire  s_test_axi_awready,
    input wire [C_S_TEST_AXI_DATA_WIDTH-1 : 0] s_test_axi_wdata,
    input wire [(C_S_TEST_AXI_DATA_WIDTH/8)-1 : 0] s_test_axi_wstrb,
    input wire  s_test_axi_wvalid,
    output wire  s_test_axi_wready,
    output wire [1 : 0] s_test_axi_bresp,
    output wire  s_test_axi_bvalid,
    input wire  s_test_axi_bready,
    input wire [C_S_TEST_AXI_ADDR_WIDTH-1 : 0] s_test_axi_araddr,
    input wire [2 : 0] s_test_axi_arprot,
    input wire  s_test_axi_arvalid,
    output wire  s_test_axi_arready,
    output wire [C_S_TEST_AXI_DATA_WIDTH-1 : 0] s_test_axi_rdata,
    output wire [1 : 0] s_test_axi_rresp,
    output wire  s_test_axi_rvalid,
    input wire  s_test_axi_rready
);

logic v_blank, end_of_frame;
logic next_pixel_please;
logic [31:0] pixel_data;
logic enable, enable_sync_gen;

//logic base_addr;

// Instantiation of Axi Bus Interface M_FRAMEREAD_AXI
framereader # ( 
    .C_M_AXI_BURST_LEN(C_M_FRAMEREAD_AXI_BURST_LEN),
    .C_M_AXI_ID_WIDTH(C_M_FRAMEREAD_AXI_ID_WIDTH),
    .C_M_AXI_ADDR_WIDTH(C_M_FRAMEREAD_AXI_ADDR_WIDTH),
    .C_M_AXI_DATA_WIDTH(C_M_FRAMEREAD_AXI_DATA_WIDTH),
    .C_M_AXI_ARUSER_WIDTH(C_M_FRAMEREAD_AXI_ARUSER_WIDTH),
    .C_M_AXI_RUSER_WIDTH(C_M_FRAMEREAD_AXI_RUSER_WIDTH)
) framereader_inst (
    .pixel_clk(pixel_clk),
    .next_pixel_please(next_pixel_please),
    .pixel_data(pixel_data),
    .end_of_frame(end_of_frame),
    .base_addr(32'h00108078),
    .enable(enable),
    .M_AXI_ACLK(m_frameread_axi_aclk),
    .M_AXI_ARESETN(m_frameread_axi_aresetn),
    .M_AXI_ARID(m_frameread_axi_arid),
    .M_AXI_ARADDR(m_frameread_axi_araddr),
    .M_AXI_ARLEN(m_frameread_axi_arlen),
    .M_AXI_ARSIZE(m_frameread_axi_arsize),
    .M_AXI_ARBURST(m_frameread_axi_arburst),
    .M_AXI_ARLOCK(m_frameread_axi_arlock),
    .M_AXI_ARCACHE(m_frameread_axi_arcache),
    .M_AXI_ARPROT(m_frameread_axi_arprot),
    .M_AXI_ARQOS(m_frameread_axi_arqos),
    .M_AXI_ARUSER(m_frameread_axi_aruser),
    .M_AXI_ARVALID(m_frameread_axi_arvalid),
    .M_AXI_ARREADY(m_frameread_axi_arready),
    .M_AXI_RID(m_frameread_axi_rid),
    .M_AXI_RDATA(m_frameread_axi_rdata),
    .M_AXI_RRESP(m_frameread_axi_rresp),
    .M_AXI_RLAST(m_frameread_axi_rlast),
    .M_AXI_RUSER(m_frameread_axi_ruser),
    .M_AXI_RVALID(m_frameread_axi_rvalid),
    .M_AXI_RREADY(m_frameread_axi_rready)
);

// Instantiation of Axi Bus Interface S_TEST_AXI
sprite_engine_v1_0_S_TEST_AXI # ( 
    .C_S_AXI_DATA_WIDTH(C_S_TEST_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_TEST_AXI_ADDR_WIDTH)
) sprite_engine_v1_0_S_TEST_AXI_inst (
    .base_addr(),
    .enable(enable),
    .S_AXI_ACLK(s_test_axi_aclk),
    .S_AXI_ARESETN(s_test_axi_aresetn),
    .S_AXI_AWADDR(s_test_axi_awaddr),
    .S_AXI_AWPROT(s_test_axi_awprot),
    .S_AXI_AWVALID(s_test_axi_awvalid),
    .S_AXI_AWREADY(s_test_axi_awready),
    .S_AXI_WDATA(s_test_axi_wdata),
    .S_AXI_WSTRB(s_test_axi_wstrb),
    .S_AXI_WVALID(s_test_axi_wvalid),
    .S_AXI_WREADY(s_test_axi_wready),
    .S_AXI_BRESP(s_test_axi_bresp),
    .S_AXI_BVALID(s_test_axi_bvalid),
    .S_AXI_BREADY(s_test_axi_bready),
    .S_AXI_ARADDR(s_test_axi_araddr),
    .S_AXI_ARPROT(s_test_axi_arprot),
    .S_AXI_ARVALID(s_test_axi_arvalid),
    .S_AXI_ARREADY(s_test_axi_arready),
    .S_AXI_RDATA(s_test_axi_rdata),
    .S_AXI_RRESP(s_test_axi_rresp),
    .S_AXI_RVALID(s_test_axi_rvalid),
    .S_AXI_RREADY(s_test_axi_rready)
);

// Synchronization signal generator
sync_gen #(
   .H_VISIBLE(H_VISIBLE),
   .H_FRONT_PORCH(H_FRONT_PORCH),
   .H_SYNC(H_SYNC),
   .H_BACK_PORCH(H_BACK_PORCH),
   .V_VISIBLE(V_VISIBLE),
   .V_FRONT_PORCH(V_FRONT_PORCH),
   .V_SYNC(V_SYNC),
   .V_BACK_PORCH(V_BACK_PORCH)
) sync_gen_1 (
   .clk(pixel_clk),
   .enable(enable_sync_gen),
   .next_pixel_please(next_pixel_please),
   .pixel_data(pixel_data),
   .red(red),
   .green(green),
   .blue(blue),
   .h_sync(h_sync),
   .v_sync(v_sync),
   .h_blank(),
   .v_blank(v_blank),
   .blank_n(blank_n)
);

// Synchronizes the vblank signal to the AXI clock
posedge_sync posedge_sync_inst (
    .clk(m_frameread_axi_aclk),
    .sig_in(v_blank),
    .sig_out(end_of_frame)
);

// Synchronizes the enable signal to the pixel clock
level_sync level_sync_inst (
    .clk(pixel_clk),
    .sig_in(enable),
    .sig_out(enable_sync_gen)
);

endmodule
