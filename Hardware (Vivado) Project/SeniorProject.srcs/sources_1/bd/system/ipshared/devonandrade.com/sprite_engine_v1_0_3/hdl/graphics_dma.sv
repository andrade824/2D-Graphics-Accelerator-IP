`timescale 1 ns / 1 ps

    module graphics_dma #
    (
        // Video resolution parameters
        parameter SCREEN_WIDTH = 640,
        parameter SCREEN_HEIGHT = 480,

        // Parameters of Axi Master Bus Interface m_dma_AXI
        parameter integer C_M_AXI_DMA_MAX_BURST_LEN = 16,
        parameter integer C_M_AXI_DMA_ADDR_WIDTH = 32,
        parameter integer C_M_AXI_DMA_DATA_WIDTH = 32
    )
    (
        // Descriptor interface
        input logic start,
        output logic busy,
        input logic [31:0] source_addr, dest_addr,
        input logic [9:0] dest_x, dest_y,
        input logic [9:0] dest_width, dest_height,
        input logic dest_mode,    // 0 for stream, 1 for rectangle
        input logic [15:0] transparent_color,

        // Ports of Axi Master Bus Interface m_dma_AXI
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
        output logic m_dma_axi_rready
    );

    logic read_done, write_done;
    logic [20:0] size_in_bytes;

    // FIFO Interface
    logic [31:0] fifo_rdata, fifo_wdata;
    logic fifo_empty, fifo_full;
    logic fifo_rden, fifo_wren;

    // Descriptor interface latch registers
    logic [31:0] source_addr_latch, dest_addr_latch;
    logic [9:0] dest_x_latch, dest_y_latch;
    logic [9:0] dest_width_latch, dest_height_latch;
    logic dest_mode_latch;    // 0 for stream, 1 for rectangle
    logic start_latch;
    logic [15:0] transparent_color_latch;
    logic [20:0] size_in_bytes_latch;

    // FIFO reset is active high
    assign fifo_rst = ~m_dma_axi_aresetn;

    // Inform outside world that the DMA is busy until both internal cores are done
    assign busy = ~(read_done & write_done) | start_latch;

    // Determine the size in bytes of this DMA transfer
    assign size_in_bytes = (dest_width * dest_height) << 1;

    // Instantiation of the Write Core
    dma_write_core # (
        .SCREEN_WIDTH(SCREEN_WIDTH),
        .SCREEN_HEIGHT(SCREEN_HEIGHT),
        .C_M_AXI_MAX_BURST_LEN(C_M_AXI_DMA_MAX_BURST_LEN),
        .C_M_AXI_ADDR_WIDTH(C_M_AXI_DMA_ADDR_WIDTH),
        .C_M_AXI_DATA_WIDTH(C_M_AXI_DMA_DATA_WIDTH)
    ) dma_write_core_inst (
        .start(start_latch),
        .done(write_done),
        .size_in_bytes(size_in_bytes_latch),
        .dest_addr(dest_addr_latch),
        .dest_x(dest_x_latch),
        .dest_y(dest_y_latch),
        .dest_width(dest_width_latch),
        .dest_height(dest_height_latch),
        .dest_mode(dest_mode_latch),
        .transparent_color(transparent_color_latch),
        .fifo_rdata(fifo_rdata),
        .fifo_empty(fifo_empty),
        .fifo_rden(fifo_rden),
        .M_AXI_ACLK(m_dma_axi_aclk),
        .M_AXI_ARESETN(m_dma_axi_aresetn),
        .M_AXI_AWID(m_dma_axi_awid),
        .M_AXI_AWADDR(m_dma_axi_awaddr),
        .M_AXI_AWLEN(m_dma_axi_awlen),
        .M_AXI_AWSIZE(m_dma_axi_awsize),
        .M_AXI_AWBURST(m_dma_axi_awburst),
        .M_AXI_AWLOCK(m_dma_axi_awlock),
        .M_AXI_AWCACHE(m_dma_axi_awcache),
        .M_AXI_AWPROT(m_dma_axi_awprot),
        .M_AXI_AWQOS(m_dma_axi_awqos),
        .M_AXI_AWVALID(m_dma_axi_awvalid),
        .M_AXI_AWREADY(m_dma_axi_awready),
        .M_AXI_WDATA(m_dma_axi_wdata),
        .M_AXI_WSTRB(m_dma_axi_wstrb),
        .M_AXI_WLAST(m_dma_axi_wlast),
        .M_AXI_WVALID(m_dma_axi_wvalid),
        .M_AXI_WREADY(m_dma_axi_wready),
        .M_AXI_BID(m_dma_axi_bid),
        .M_AXI_BRESP(m_dma_axi_bresp),
        .M_AXI_BVALID(m_dma_axi_bvalid),
        .M_AXI_BREADY(m_dma_axi_bready)
    );

    // Instantiation of the Read Core
    dma_read_core # (
        .C_M_AXI_MAX_BURST_LEN(C_M_AXI_DMA_MAX_BURST_LEN),
        .C_M_AXI_ADDR_WIDTH(C_M_AXI_DMA_ADDR_WIDTH),
        .C_M_AXI_DATA_WIDTH(C_M_AXI_DMA_DATA_WIDTH)
    ) dma_read_core_inst (
        .start(start_latch),
        .done(read_done),
        .source_addr(source_addr_latch),
        .size_in_bytes(size_in_bytes_latch),
        .fifo_wdata(fifo_wdata),
        .fifo_full(fifo_full),
        .fifo_wren(fifo_wren),
        .M_AXI_ACLK(m_dma_axi_aclk),
        .M_AXI_ARESETN(m_dma_axi_aresetn),
        .M_AXI_ARID(m_dma_axi_arid),
        .M_AXI_ARADDR(m_dma_axi_araddr),
        .M_AXI_ARLEN(m_dma_axi_arlen),
        .M_AXI_ARSIZE(m_dma_axi_arsize),
        .M_AXI_ARBURST(m_dma_axi_arburst),
        .M_AXI_ARLOCK(m_dma_axi_arlock),
        .M_AXI_ARCACHE(m_dma_axi_arcache),
        .M_AXI_ARPROT(m_dma_axi_arprot),
        .M_AXI_ARQOS(m_dma_axi_arqos),
        .M_AXI_ARVALID(m_dma_axi_arvalid),
        .M_AXI_ARREADY(m_dma_axi_arready),
        .M_AXI_RID(m_dma_axi_rid),
        .M_AXI_RDATA(m_dma_axi_rdata),
        .M_AXI_RRESP(m_dma_axi_rresp),
        .M_AXI_RLAST(m_dma_axi_rlast),
        .M_AXI_RVALID(m_dma_axi_rvalid),
        .M_AXI_RREADY(m_dma_axi_rready)
    );

    // FIFO to transfer data between read and write cores
    FIFO36E1 #(
        .ALMOST_EMPTY_OFFSET(13'h0020), // Sets the almost empty threshold
        .ALMOST_FULL_OFFSET(13'h0020), // Sets almost full threshold
        .DATA_WIDTH(36), // Sets data width to 4-72
        .DO_REG(1), // Enable output register (1-0) Must be 1 if EN_SYN = FALSE
        .EN_ECC_READ("FALSE"), // Enable ECC decoder, FALSE, TRUE
        .EN_ECC_WRITE("FALSE"), // Enable ECC encoder, FALSE, TRUE
        .EN_SYN("FALSE"), // Specifies FIFO as Asynchronous (FALSE) or Synchronous (TRUE)
        .FIFO_MODE("FIFO36"), // Sets mode to "FIFO36" or "FIFO36_72"
        .FIRST_WORD_FALL_THROUGH("TRUE"), // Sets the FIFO FWFT to FALSE, TRUE
        .INIT(72'h000000000000000000), // Initial values on output port
        .SIM_DEVICE("7SERIES"), // Must be set to "7SERIES" for simulation behavior
        .SRVAL(72'h000000000000000000) // Set/Reset value for output port
    ) FIFO36E1_inst (
        // ECC Signals: 1-bit (each) output: Error Correction Circuitry ports
        .DBITERR(), // 1-bit output: Double bit error status
        .ECCPARITY(), // 8-bit output: Generated error correction parity
        .SBITERR(), // 1-bit output: Single bit error status
        
        // Read Data: 64-bit (each) output: Read output data
        .DO(fifo_rdata), // 64-bit output: Data output
        .DOP(), // 8-bit output: Parity data output
        
        // Status: 1-bit (each) output: Flags and other FIFO status outputs
        .ALMOSTEMPTY(), // 1-bit output: Almost empty flag
        .ALMOSTFULL(), // 1-bit output: Almost full flag
        .EMPTY(fifo_empty), // 1-bit output: Empty flag
        .FULL(fifo_full), // 1-bit output: Full flag
        .RDCOUNT(), // 13-bit output: Read count
        .RDERR(), // 1-bit output: Read error
        .WRCOUNT(), // 13-bit output: Write count
        .WRERR(), // 1-bit output: Write error
        
        // ECC Signals: 1-bit (each) input: Error Correction Circuitry ports
        .INJECTDBITERR(), // 1-bit input: Inject a double bit error input
        .INJECTSBITERR(),
        
        // Read Control Signals: 1-bit (each) input: Read clock, enable and reset input signals
        .RDCLK(m_dma_axi_aclk), // 1-bit input: Read clock
        .RDEN(fifo_rden), // 1-bit input: Read enable
        .REGCE(1'b1), // 1-bit input: Clock enable
        .RST(fifo_rst), // 1-bit input: Reset
        .RSTREG(1'b0), // 1-bit input: Output register set/reset
        
        // Write Control Signals: 1-bit (each) input: Write clock and enable input signals
        .WRCLK(m_dma_axi_aclk), // 1-bit input: Rising edge write clock.
        .WREN(fifo_wren), // 1-bit input: Write enable
        
        // Write Data: 64-bit (each) input: Write input data
        .DI(fifo_wdata), // 64-bit input: Data input
        .DIP() // 8-bit input: Parity input
    );

    // Latch the start signal for only one clock pulse
    always_ff @(posedge m_dma_axi_aclk) begin
        if(!m_dma_axi_aresetn)
            start_latch <= '0;
        else if (start)
            start_latch <= 1'b1;
        else if (start_latch)
            start_latch <= '0;
        else
            start_latch <= start_latch;
    end

    // Latch the rest of the descriptor interface so the DMA has 
    // consistent values to work with
    always_ff @(posedge m_dma_axi_aclk) begin
        if(!m_dma_axi_aresetn) begin
            source_addr_latch <= '0;
            dest_addr_latch <= '0;
            dest_x_latch <= '0;
            dest_y_latch <= '0;
            dest_width_latch <= '0;
            dest_height_latch <= '0;
            dest_mode_latch <= '0;
            transparent_color_latch <= '0;
            size_in_bytes_latch <= '0;
        end else if (start) begin
            source_addr_latch <= source_addr;
            dest_addr_latch <= dest_addr;
            dest_x_latch <= dest_x;
            dest_y_latch <= dest_y;
            dest_width_latch <= dest_width;
            dest_height_latch <= dest_height;
            dest_mode_latch <= dest_mode;
            transparent_color_latch <= transparent_color;
            size_in_bytes_latch <= size_in_bytes;
        end else begin
            source_addr_latch <= source_addr_latch;
            dest_addr_latch <= dest_addr_latch;
            dest_x_latch <= dest_x_latch;
            dest_y_latch <= dest_y_latch;
            dest_width_latch <= dest_width_latch;
            dest_height_latch <= dest_height_latch;
            dest_mode_latch <= dest_mode_latch;
            transparent_color_latch <= transparent_color_latch;
            size_in_bytes_latch <= size_in_bytes_latch;
        end
    end

    endmodule
