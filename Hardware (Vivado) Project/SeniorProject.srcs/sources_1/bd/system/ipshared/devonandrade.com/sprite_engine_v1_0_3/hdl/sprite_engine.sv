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

    parameter integer MAX_SPRITES = 256,

    // Parameters of Axi Master Bus Interface m_dma_AXI
    parameter integer C_M_AXI_DMA_MAX_BURST_LEN = 16,
    parameter integer C_M_AXI_DMA_ADDR_WIDTH = 32,
    parameter integer C_M_AXI_DMA_DATA_WIDTH = 32,

    // Parameters of Axi Master Bus Interface M_FRAMEREAD_AXI
    parameter integer C_M_FRAMEREAD_AXI_BURST_LEN	= 16,
    parameter integer C_M_FRAMEREAD_AXI_ADDR_WIDTH	= 32,
    parameter integer C_M_FRAMEREAD_AXI_DATA_WIDTH	= 32,
    
    // Parameters of Axi Slave Bus Interface S_TEST_AXI
    parameter integer C_S00_AXI_DATA_WIDTH  = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH  = 16
)
(
    // Sync gen ports
    input logic pixel_clk,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,
    output logic h_sync, v_sync,
    output logic blank_n,

    // Ports for Axi Master Bus Interface m_dma_AXI
    input logic  m_dma_axi_aclk,
    input logic  m_dma_axi_aresetn,
    output logic m_dma_axi_awid,
    output logic [C_M_AXI_DMA_ADDR_WIDTH-1:0] m_dma_axi_awaddr,
    output logic [3:0] m_dma_axi_awlen,
    output logic [2:0] m_dma_axi_awsize,
    output logic [1:0] m_dma_axi_awburst,
    output logic m_dma_axi_awlock,
    output logic [3:0] m_dma_axi_awcache,
    output logic [2:0] m_dma_axi_awprot,
    output logic [3:0] m_dma_axi_awqos,
    output logic m_dma_axi_awvalid,
    input logic  m_dma_axi_awready,
    output logic [C_M_AXI_DMA_DATA_WIDTH-1:0] m_dma_axi_wdata,
    output logic [C_M_AXI_DMA_DATA_WIDTH/8-1:0] m_dma_axi_wstrb,
    output logic m_dma_axi_wlast,
    output logic m_dma_axi_wvalid,
    input logic  m_dma_axi_wready,
    input logic  m_dma_axi_bid,
    input logic  [1:0] m_dma_axi_bresp,
    input logic  m_dma_axi_bvalid,
    output logic m_dma_axi_bready,
    output logic m_dma_axi_arid,
    output logic [C_M_AXI_DMA_DATA_WIDTH-1:0] m_dma_axi_araddr,
    output logic [3:0] m_dma_axi_arlen,
    output logic [2:0] m_dma_axi_arsize,
    output logic [1:0] m_dma_axi_arburst,
    output logic m_dma_axi_arlock,
    output logic [3:0] m_dma_axi_arcache,
    output logic [2:0] m_dma_axi_arprot,
    output logic [3:0] m_dma_axi_arqos,
    output logic m_dma_axi_arvalid,
    input logic  m_dma_axi_arready,
    input logic  m_dma_axi_rid,
    input logic  [C_M_AXI_DMA_DATA_WIDTH-1:0] m_dma_axi_rdata,
    input logic  [1:0] m_dma_axi_rresp,
    input logic  m_dma_axi_rlast,
    input logic  m_dma_axi_rvalid,
    output logic m_dma_axi_rready,

    // Ports for Axi Master Bus Interface M_FRAMEREAD_AXI
    input logic  m_frameread_axi_aclk,
    input logic  m_frameread_axi_aresetn,
    output logic m_frameread_axi_arid,
    output logic [C_M_FRAMEREAD_AXI_ADDR_WIDTH-1 : 0] m_frameread_axi_araddr,
    output logic [3 : 0] m_frameread_axi_arlen,
    output logic [2 : 0] m_frameread_axi_arsize,
    output logic [1 : 0] m_frameread_axi_arburst,
    output logic m_frameread_axi_arlock,
    output logic [3 : 0] m_frameread_axi_arcache,
    output logic [2 : 0] m_frameread_axi_arprot,
    output logic [3 : 0] m_frameread_axi_arqos,
    output logic m_frameread_axi_arvalid,
    input logic  m_frameread_axi_arready,
    input logic  m_frameread_axi_rid,
    input logic  [C_M_FRAMEREAD_AXI_DATA_WIDTH-1 : 0] m_frameread_axi_rdata,
    input logic  [1 : 0] m_frameread_axi_rresp,
    input logic  m_frameread_axi_rlast,
    input logic  m_frameread_axi_rvalid,
    output logic m_frameread_axi_rready,

    // Ports of Axi Slave Bus Interface S00_AXI
    input logic  s00_axi_aclk,
    input logic  s00_axi_aresetn,
    input logic  [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input logic  [2 : 0] s00_axi_awprot,
    input logic  s00_axi_awvalid,
    output logic s00_axi_awready,
    input logic  [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input logic  [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input logic  s00_axi_wvalid,
    output logic s00_axi_wready,
    output logic [1 : 0] s00_axi_bresp,
    output logic s00_axi_bvalid,
    input logic  s00_axi_bready,
    input logic  [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input logic  [2 : 0] s00_axi_arprot,
    input logic  s00_axi_arvalid,
    output logic s00_axi_arready,
    output logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output logic [1 : 0] s00_axi_rresp,
    output logic s00_axi_rvalid,
    input logic  s00_axi_rready
);

    // Sync Gen signals
    logic v_blank, end_of_frame;
    logic next_pixel_please;
    logic [31:0] pixel_data;
    logic enable, enable_sync_gen;

    // Addresses of memory locations
    logic [31:0] buffer1_addr, buffer2_addr;
    logic [31:0] bg_buffer_addr, tile_addr, sprite_addr;

    // Sprite table write interface
    logic [8:0] spr_table_wraddr;
    logic [63:0] spr_table_wdata;
    logic [7:0] spr_table_we;
    logic spr_table_wren;

    // Background table write interface
    logic [8:0] bg_table_wraddr;
    logic [31:0] bg_table_wdata;
    logic [3:0] bg_table_we;
    logic bg_table_wren;

    // Frame controller signals
    logic [31:0] create_addr, display_addr;
    logic descriptor_mux_sel, buffer_mux_sel;
    logic bg_start, bg_busy, spr_start, spr_busy;

    // Background Descriptor interface
    logic bg_dma_start;
    logic [31:0] bg_source_addr;
    logic [9:0] bg_dest_x, bg_dest_y;
    logic [9:0] bg_dest_width, bg_dest_height;
    logic bg_dest_mode;    // 0 for stream, 1 for rectangle
    logic bg_mode;         // 0 for framebuffer, 1 for tiled

    // Sprite Descriptor interface
    logic spr_dma_start;
    logic [31:0] spr_source_addr;
    logic [9:0] spr_dest_x, spr_dest_y;
    logic [9:0] spr_dest_width, spr_dest_height;
    logic spr_dest_mode;    // 0 for stream, 1 for rectangle

    // Final Descriptor interface
    logic dma_start, dma_busy;
    logic [31:0] dma_source_addr;
    logic [9:0] dma_dest_x, dma_dest_y;
    logic [9:0] dma_dest_width, dma_dest_height;
    logic dma_dest_mode;    // 0 for stream, 1 for rectangle


    // Instantiation of Graphics DMA
    graphics_dma # (
        .SCREEN_WIDTH(H_VISIBLE),
        .SCREEN_HEIGHT(V_VISIBLE),
        .C_M_AXI_DMA_MAX_BURST_LEN(C_M_AXI_DMA_MAX_BURST_LEN),
        .C_M_AXI_DMA_ADDR_WIDTH(C_M_AXI_DMA_ADDR_WIDTH),
        .C_M_AXI_DMA_DATA_WIDTH(C_M_AXI_DMA_DATA_WIDTH)
    ) graphics_dma_inst (
        .start            (dma_start),
        .busy             (dma_busy),
        .source_addr      (dma_source_addr),
        .dest_addr        (create_addr),
        .dest_x           (dma_dest_x),
        .dest_y           (dma_dest_y),
        .dest_width       (dma_dest_width),
        .dest_height      (dma_dest_height),
        .dest_mode        (dma_dest_mode),
        .transparent_color(16'hF81F),       // Bright magenta (all red, all blue) for transparent
        .m_dma_axi_aclk   (m_dma_axi_aclk),
        .m_dma_axi_aresetn(m_dma_axi_aresetn),
        .m_dma_axi_awid   (m_dma_axi_awid),
        .m_dma_axi_awaddr (m_dma_axi_awaddr),
        .m_dma_axi_awlen  (m_dma_axi_awlen),
        .m_dma_axi_awsize (m_dma_axi_awsize),
        .m_dma_axi_awburst(m_dma_axi_awburst),
        .m_dma_axi_awlock (m_dma_axi_awlock),
        .m_dma_axi_awcache(m_dma_axi_awcache),
        .m_dma_axi_awprot (m_dma_axi_awprot),
        .m_dma_axi_awqos  (m_dma_axi_awqos),
        .m_dma_axi_awvalid(m_dma_axi_awvalid),
        .m_dma_axi_awready(m_dma_axi_awready),
        .m_dma_axi_wdata  (m_dma_axi_wdata),
        .m_dma_axi_wstrb  (m_dma_axi_wstrb),
        .m_dma_axi_wlast  (m_dma_axi_wlast),
        .m_dma_axi_wvalid (m_dma_axi_wvalid),
        .m_dma_axi_wready (m_dma_axi_wready),
        .m_dma_axi_bid    (m_dma_axi_bid),
        .m_dma_axi_bresp  (m_dma_axi_bresp),
        .m_dma_axi_bvalid (m_dma_axi_bvalid),
        .m_dma_axi_bready (m_dma_axi_bready),
        .m_dma_axi_arid   (m_dma_axi_arid),
        .m_dma_axi_araddr (m_dma_axi_araddr),
        .m_dma_axi_arlen  (m_dma_axi_arlen),
        .m_dma_axi_arsize (m_dma_axi_arsize),
        .m_dma_axi_arburst(m_dma_axi_arburst),
        .m_dma_axi_arlock (m_dma_axi_arlock),
        .m_dma_axi_arcache(m_dma_axi_arcache),
        .m_dma_axi_arprot (m_dma_axi_arprot),
        .m_dma_axi_arqos  (m_dma_axi_arqos),
        .m_dma_axi_arvalid(m_dma_axi_arvalid),
        .m_dma_axi_arready(m_dma_axi_arready),
        .m_dma_axi_rid    (m_dma_axi_rid),
        .m_dma_axi_rdata  (m_dma_axi_rdata),
        .m_dma_axi_rresp  (m_dma_axi_rresp),
        .m_dma_axi_rlast  (m_dma_axi_rlast),
        .m_dma_axi_rvalid (m_dma_axi_rvalid),
        .m_dma_axi_rready (m_dma_axi_rready)
    );

    // Instantiation of Axi Bus Interface M_FRAMEREAD_AXI
    framereader # ( 
        .C_M_AXI_BURST_LEN(C_M_FRAMEREAD_AXI_BURST_LEN),
        .C_M_AXI_ADDR_WIDTH(C_M_FRAMEREAD_AXI_ADDR_WIDTH),
        .C_M_AXI_DATA_WIDTH(C_M_FRAMEREAD_AXI_DATA_WIDTH)
    ) framereader_inst (
        .pixel_clk(pixel_clk),
        .next_pixel_please(next_pixel_please),
        .pixel_data(pixel_data),
        .end_of_frame(end_of_frame),
        .base_addr(display_addr),
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
        .M_AXI_ARVALID(m_frameread_axi_arvalid),
        .M_AXI_ARREADY(m_frameread_axi_arready),
        .M_AXI_RID(m_frameread_axi_rid),
        .M_AXI_RDATA(m_frameread_axi_rdata),
        .M_AXI_RRESP(m_frameread_axi_rresp),
        .M_AXI_RLAST(m_frameread_axi_rlast),
        .M_AXI_RVALID(m_frameread_axi_rvalid),
        .M_AXI_RREADY(m_frameread_axi_rready)
    );

    // Instantiation of Axi Bus Interface S_TEST_AXI
    cmd_interface # ( 
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) cmd_interface_inst (
        .enable(enable),
        .buffer1_addr(buffer1_addr),
        .buffer2_addr(buffer2_addr),
        .bg_buffer_addr(bg_buffer_addr),
        .tile_addr(tile_addr),
        .sprite_addr(sprite_addr),
        .spr_table_wraddr(spr_table_wraddr),
        .spr_table_wdata(spr_table_wdata),
        .spr_table_we(spr_table_we),
        .spr_table_wren(spr_table_wren),
        .bg_table_wraddr(bg_table_wraddr),
        .bg_table_wdata(bg_table_wdata),
        .bg_table_we(bg_table_we),
        .bg_table_wren(bg_table_wren),
        .bg_mode(bg_mode),
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWPROT(s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WSTRB(s00_axi_wstrb),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready)
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

    // Make sure the display controller is displaying a different buffer than the DMA is writing to
    framebuffer_mux display_buffer_mux (
        .sel(buffer_mux_sel),
        .in1(buffer1_addr),
        .in2(buffer2_addr),
        .out(display_addr)
    );

    framebuffer_mux create_buffer_mux (
        .sel(buffer_mux_sel),
        .in1(buffer2_addr),
        .in2(buffer1_addr),
        .out(create_addr)
    );

    // Flip between the BG and Sprite controllers having access to the DMA
    dma_descriptor_mux dma_descriptor_mux_inst (
        .sel            (descriptor_mux_sel),
        .bg_start       (bg_dma_start),
        .bg_source_addr (bg_source_addr),
        .bg_dest_x      (bg_dest_x),
        .bg_dest_y      (bg_dest_y),
        .bg_dest_width  (bg_dest_width),
        .bg_dest_height (bg_dest_height),
        .bg_dest_mode   (bg_dest_mode),
        .spr_start      (spr_dma_start),
        .spr_source_addr(spr_source_addr),
        .spr_dest_x     (spr_dest_x),
        .spr_dest_y     (spr_dest_y),
        .spr_dest_width (spr_dest_width),
        .spr_dest_height(spr_dest_height),
        .spr_dest_mode  (spr_dest_mode),
        .start          (dma_start),
        .source_addr    (dma_source_addr),
        .dest_x         (dma_dest_x),
        .dest_y         (dma_dest_y),
        .dest_width     (dma_dest_width),
        .dest_height    (dma_dest_height),
        .dest_mode      (dma_dest_mode)
    );

    // Draw the background
    bg_ctrl bg_ctrl_inst (
        .clk            (m_dma_axi_aclk),
        .rst_n          (m_dma_axi_aresetn),
        .tile_addr      (tile_addr),
        .buffer_addr    (bg_buffer_addr),
        .bg_mode        (bg_mode),
        .start          (bg_start),
        .busy           (bg_busy),
        .bg_table_wraddr(bg_table_wraddr),
        .bg_table_wdata (bg_table_wdata),
        .bg_table_we    (bg_table_we),
        .bg_table_wren  (bg_table_wren),
        .dma_busy       (dma_busy),
        .dma_start      (bg_dma_start),
        .dma_source_addr(bg_source_addr),
        .dma_dest_x     (bg_dest_x),
        .dma_dest_y     (bg_dest_y),
        .dma_dest_width (bg_dest_width),
        .dma_dest_height(bg_dest_height),
        .dma_dest_mode  (bg_dest_mode)
    );

    // Draw the sprites
    spr_ctrl # (
        .MAX_SPRITES(MAX_SPRITES)
    ) spr_ctrl_inst (
        .clk             (m_dma_axi_aclk),
        .rst_n           (m_dma_axi_aresetn),
        .sprite_addr     (sprite_addr),
        .spr_table_wraddr(spr_table_wraddr),
        .spr_table_wdata (spr_table_wdata),
        .spr_table_we    (spr_table_we),
        .spr_table_wren  (spr_table_wren),
        .start           (spr_start),
        .busy            (spr_busy),
        .dma_busy        (dma_busy),
        .dma_start       (spr_dma_start),
        .dma_source_addr (spr_source_addr),
        .dma_dest_x      (spr_dest_x),
        .dma_dest_y      (spr_dest_y),
        .dma_dest_width  (spr_dest_width),
        .dma_dest_height (spr_dest_height),
        .dma_dest_mode   (spr_dest_mode)
    );

    // Frame Controller
    frame_ctrl frame_ctrl_inst (
        .clk               (m_dma_axi_aclk),
        .rst_n             (m_dma_axi_aresetn),
        .enable            (enable),
        .end_of_frame      (end_of_frame),
        .bg_busy           (bg_busy),
        .spr_busy          (spr_busy),
        .bg_start          (bg_start),
        .spr_start         (spr_start),
        .descriptor_mux_sel(descriptor_mux_sel),
        .buffer_mux_sel    (buffer_mux_sel)
    );

endmodule
