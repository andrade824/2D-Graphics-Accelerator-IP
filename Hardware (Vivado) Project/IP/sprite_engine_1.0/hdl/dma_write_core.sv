`timescale 1 ns / 1 ps

module dma_write_core #
(
    // Video resolution parameters
    parameter SCREEN_WIDTH = 640,
    parameter SCREEN_HEIGHT = 480,

    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    parameter integer C_M_AXI_MAX_BURST_LEN = 16,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH = 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH = 32
)
(
    // DMA Signals
    input logic start, 
    output logic done,
    input logic [20:0] size_in_bytes,
    input logic [31:0] dest_addr,
    input logic [9:0] dest_x, dest_y,
    input logic [9:0] dest_width, dest_height,
    input logic dest_mode,                        // 0 for stream, 1 for rectangle
    input logic [15:0] transparent_color,

    // FIFO signals
    input logic [31:0] fifo_rdata,
    input logic fifo_empty,
    output logic fifo_rden,

    /* GENERIC SIGNALS */
    // Global Clock Signal.
    input logic M_AXI_ACLK,
    // Global Reset Singal. This Signal is Active Low
    input logic M_AXI_ARESETN,

    /* WRITE ADDRESS */
    // Master Interface Write Address ID
    output logic M_AXI_AWID,
    // Master Interface Write Address
    output logic [C_M_AXI_ADDR_WIDTH-1:0] M_AXI_AWADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output logic [3:0] M_AXI_AWLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output logic [2:0] M_AXI_AWSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    output logic [1:0] M_AXI_AWBURST,
    // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
    output logic M_AXI_AWLOCK,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    output logic [3:0] M_AXI_AWCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    output logic [2:0] M_AXI_AWPROT,
    // Quality of Service, QoS identifier sent for each write transaction.
    output logic [3:0] M_AXI_AWQOS,
    // Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
    output logic M_AXI_AWVALID,
    // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    input logic M_AXI_AWREADY,

    /* WRITE DATA */
    // Master Interface Write Data.
    output logic [C_M_AXI_DATA_WIDTH-1:0] M_AXI_WDATA,
    // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
    output logic [C_M_AXI_DATA_WIDTH/8-1:0] M_AXI_WSTRB,
    // Write last. This signal indicates the last transfer in a write burst.
    output logic M_AXI_WLAST,
    // Write valid. This signal indicates that valid write
    // data and strobes are available
    output logic M_AXI_WVALID,
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    input logic M_AXI_WREADY,

    /* WRITE RESPONSE */
    // Master Interface Write Response.
    input logic M_AXI_BID,
    // Write response. This signal indicates the status of the write transaction.
    input logic [1:0] M_AXI_BRESP,
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    input logic M_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    output logic M_AXI_BREADY
);

    // function called clogb2 that returns an integer which has the 
    // value of the ceiling of the log base 2.                      
    function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
            bit_depth = bit_depth >> 1;
        end
    endfunction

    // This is how many bits it takes to store the maximum burst length number in binary
    localparam integer BITS_FOR_BURST = clogb2(C_M_AXI_MAX_BURST_LEN - 1);

    // Write core state machine variables
    typedef enum logic[2:0] {START, START_BURST, WRITE_LINE, FINISH_LINE, STREAM_WRITE} write_state;
    write_state current_state, next_state;

    // The current offset at which to read pixels from
    logic [20:0] addr_offset, addr_offset_reset_val, addr_offset_increment_val;

    // AXI4 internal temp signals
    logic axi_awvalid;
    logic axi_wlast;
    logic axi_wvalid;
    logic axi_bready;

    // Size of burst_length in bytes (for stream transfers)
    logic [BITS_FOR_BURST + 2:0] burst_size_bytes;

    // How many bytes need to be written in a stream transfer
    logic [20:0] bytes_left;

    // Keeps track of how many lines have been written if in RECT mode
    logic [9:0] line_index;

    // How many "beats" have been sent in the current burst transaction
    logic [7:0] write_index;

    // How many "beats" to burst in the next transaction
    logic [4:0] burst_length;
    logic [4:0] burst_length_stream;

    // Asserted when starting a burst write transfer (no shit)
    logic start_single_burst_write;

    // How many "beats" to burst by (each beat is two pixels)
    assign bytes_left = size_in_bytes - addr_offset;
    assign burst_length_stream = (bytes_left >= (C_M_AXI_MAX_BURST_LEN << 2)) ? C_M_AXI_MAX_BURST_LEN : (bytes_left >> 2);

    // Burst size in bytes
    assign burst_size_bytes = burst_length << 2;

    // Example (width = 32): 32 >> 1 == 32 / 2 == 16 data beats (each with 2 pixels each)
    assign burst_length = (dest_mode) ? (dest_width >> 1) : burst_length_stream;

    // Change how addr_offset works when in Stream vs Rect mode
    assign addr_offset_reset_val = (dest_mode) ? ((dest_y * SCREEN_WIDTH + dest_x) << 1) : '0;
    assign addr_offset_increment_val = (dest_mode) ? (SCREEN_WIDTH << 1) : (burst_size_bytes);

    // AXI Signal Connections (most of these signals are unused or need to be tied to a certain value)
    // Check section A2 of the AXI Spec for descriptions of these signals and the values

    /*Write Address (AW) */
    assign M_AXI_AWID = 'b0;

    // The AXI address is a concatenation of the target base address + active offset range
    assign M_AXI_AWADDR = dest_addr + addr_offset;

    // Burst LENgth is number of transaction beats, minus 1
    assign M_AXI_AWLEN  = burst_length - 1;
    // Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
    assign M_AXI_AWSIZE = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
    //INCR burst type is usually used, except for keyhole bursts
    assign M_AXI_AWBURST = 2'b01;
    assign M_AXI_AWLOCK = 1'b0;

    // Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable.
    assign M_AXI_AWCACHE = 4'b0010;
    assign M_AXI_AWPROT = 3'h0;
    assign M_AXI_AWQOS = 4'h0;
    assign M_AXI_AWVALID = axi_awvalid;

    /* Write Data (W) */
    assign M_AXI_WDATA = fifo_rdata;

    // Only write out pixels that aren't "transparent"
    assign M_AXI_WSTRB[1:0] = (fifo_rdata[15:0] == transparent_color) ? 2'b00 : 2'b11;
    assign M_AXI_WSTRB[3:2] = (fifo_rdata[31:16] == transparent_color) ? 2'b00 : 2'b11;

    assign M_AXI_WLAST = axi_wlast;
    assign M_AXI_WVALID = axi_wvalid & !fifo_empty;

    /* Write Response (B) */
    assign M_AXI_BID = 'b0;
    assign M_AXI_BREADY = axi_bready;

    //--------------------
    // Write Address Channel
    //--------------------

    /**
    * Waits until the start_single_burst_write signal gets asserted (by the state machine)
    * then transfers the address over to the slave.
    */
    always @(posedge M_AXI_ACLK)
    begin
        if (!M_AXI_ARESETN)
            axi_awvalid <= 1'b0;
        else if (~axi_awvalid && start_single_burst_write)
            axi_awvalid <= 1'b1;    // If previously not valid , start next transaction
        else if (M_AXI_AWREADY && axi_awvalid)
            axi_awvalid <= 1'b0;
        else
            axi_awvalid <= axi_awvalid;
    end

    /*
    * After the address is received by the slave, increment it so it's
    * ready to go for the next burst transfer
    */
    always @(posedge M_AXI_ACLK)
    begin
        if (!M_AXI_ARESETN || (start && current_state == START))
            addr_offset <= addr_offset_reset_val;
        else if (M_AXI_AWREADY && axi_awvalid)
            addr_offset <= addr_offset + addr_offset_increment_val;
        else
            addr_offset <= addr_offset;
    end

    // Possibly all combinational: 
    // assign addr_offset = ((dest_y + line_index) * SCREEN_WIDTH + dest_x) << 1;

    //--------------------
    // Write Data Channel
    //--------------------

    // Forward movement occurs when the write channel is valid and ready
    assign fifo_rden = M_AXI_WREADY & M_AXI_WVALID;

    /**
    * Assert that we have data to send whenever the FIFO isn't empty and the
    * slave is ready to receive data.
    */
    always @(posedge M_AXI_ACLK)
    begin
        if(!M_AXI_ARESETN)
            axi_wvalid <= 1'b0;
        else if (M_AXI_WREADY && !fifo_empty && write_index != 0)
            axi_wvalid <= 1'b1;
        else if (M_AXI_WREADY && fifo_empty && axi_wlast)
            axi_wvalid <= 1'b1;
        else
            axi_wvalid <= 1'b0;
    end

    // Generate WLAST when we're sending the last piece of data
    always @(posedge M_AXI_ACLK)
    begin
        if(!M_AXI_ARESETN)
            axi_wlast <= 1'b0;
        else if (fifo_rden && axi_wlast)
            axi_wlast <= 1'b0;
        else if (start_single_burst_write && (burst_length - 1) == 0)
            axi_wlast <= 1'b1;
        else if (fifo_rden && write_index == 1)
            axi_wlast <= 1'b1;
        else
            axi_wlast <= axi_wlast;
    end

    /*
    * Decrement the write index after every data beat is sent.
    * When the write_index is zero, that's the last data beat in this burst transaction.
    */
    always @(posedge M_AXI_ACLK)
    begin
        if(!M_AXI_ARESETN)
            write_index <= '0;
        else if (start_single_burst_write)
            write_index <= burst_length - 1;
        else if (fifo_rden && write_index != 0)
            write_index <= write_index - 1;
        else
            write_index <= write_index;
    end

    // Increment the line index every time an entire line has been written
    always @(posedge M_AXI_ACLK)
    begin
        if(!M_AXI_ARESETN || (start && current_state == START))
            line_index <= '0;
        else if (fifo_rden && axi_wlast)
            line_index <= line_index + 1;
        else
            line_index <= line_index;
    end

    //----------------------------
    // Write Response (B) Channel
    //----------------------------
    
    // I ignore the response, but we still need to let the slave know we got it
    always @(posedge M_AXI_ACLK)
    begin
        if (!M_AXI_ARESETN)
            axi_bready <= 1'b0;
        else if (M_AXI_BVALID && ~axi_bready)
            axi_bready <= 1'b1;
        else if (axi_bready)
            axi_bready <= 1'b0;
        else
            axi_bready <= axi_bready;
    end

    //----------------------------
    // Control State Machine
    //----------------------------

    // State changing logic
    always_ff @(posedge M_AXI_ACLK) begin
        if(!M_AXI_ARESETN)
            current_state <= START;
        else
            current_state <= next_state;
    end

    // Next-state and output-forming logic
    always_comb begin
        next_state = current_state;
        start_single_burst_write = 1'b0;
        done = 1'b0;

        case(current_state)
            // Once the start signal is received, start the burst write
            START : begin
                done = 1'b1;

                if(start)
                    next_state = START_BURST;
            end

            // Start the burst write transaction
            START_BURST : begin
                start_single_burst_write = 1'b1;
                
                // 0 for stream mode, 1 for rect
                if(dest_mode == 0)
                    next_state = STREAM_WRITE;
                else
                    next_state = WRITE_LINE;
            end

            // Wait until the burst transfer has completed
            WRITE_LINE : begin
                // Move to the start state after the last data beat has transferred
                if(fifo_rden && axi_wlast) begin
                    next_state = FINISH_LINE;
                end
            end

            // A single line has finished being written, check if there's more to write
            FINISH_LINE : begin
                if(line_index < dest_height)
                    next_state = START_BURST;
                else
                    next_state = START;
            end

            // Perform a burst transaction for a stream type transfer
            STREAM_WRITE : begin
                if(fifo_rden && axi_wlast) begin
                    if(addr_offset >= size_in_bytes)
                        next_state = START;
                    else
                        next_state = START_BURST;
                end
            end
        endcase
    end

endmodule
