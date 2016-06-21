/**
* Background controller
*
* When triggered, displays the background. This is done either as one large
* image (framebuffered), or multiple smaller images (tiled).
*/

module bg_ctrl (
    input logic clk, rst_n,
    input logic [31:0] tile_addr, buffer_addr,
    input logic bg_mode,    // 0 for framebuffer, 1 for tiled mode

    // Control signals for the frame controller
    input logic start,
    output logic busy,

    // Background tile table write port
    input logic [8:0] bg_table_wraddr,
    input logic [31:0] bg_table_wdata,
    input logic [3:0] bg_table_we,
    input logic bg_table_wren,

    // Descriptor interface
    input logic dma_busy,
    output logic dma_start,
    output logic [31:0] dma_source_addr,
    output logic [9:0] dma_dest_x, dma_dest_y,
    output logic [9:0] dma_dest_width, dma_dest_height,
    output logic dma_dest_mode    // 0 for stream, 1 for rectangle
);

    logic ram_rst;
    logic [31:0] tile_rdata;
    logic [8:0] tile_index;
    logic tile_rden;
    logic [4:0] x_count;
    logic [3:0] y_count;
    logic bg_mode_latch;

    // Number of rows and columns of tiles (20 cols, 15 rows)
    localparam integer TILE_COLS = 19;
    localparam integer TILE_ROWS = 14;

    // Background controller state machine variables
    typedef enum logic[2:0] {START, READ_TILE, BEGIN_DRAW, WAIT_DRAW, INCR_INDEX} bg_state;
    bg_state current_state, next_state;

    // Tile index is based off of the X and Y count
    assign tile_index = {y_count, x_count};

    // DMA Interface assignments
    assign dma_source_addr = (bg_mode_latch) ? (tile_addr + (tile_rdata[8:0] << 11)) : buffer_addr;
    assign dma_dest_x = (bg_mode_latch) ? (x_count << 5) : '0;
    assign dma_dest_y = (bg_mode_latch) ? (y_count << 5) : '0;
    assign dma_dest_width = (bg_mode_latch) ? 10'd32 : 10'd640;
    assign dma_dest_height = (bg_mode_latch) ? 10'd32 : 10'd480;
    assign dma_dest_mode = (bg_mode_latch) ? 1'b1 : 1'b0;

    // Block RAM reset is active high
    assign ram_rst = ~rst_n;

    // Ensure the background mode doens't change halfway through a transfer
    always_ff @(posedge clk) begin
        if(!rst_n)
            bg_mode_latch <= '0;
        else if(current_state == START)
            bg_mode_latch <= bg_mode;
        else
            bg_mode_latch <= bg_mode_latch;
    end

    // X counter
    always_ff @(posedge clk) begin
        if(!rst_n || current_state == START)
            x_count <= '0;
        else if (current_state == INCR_INDEX && x_count < TILE_COLS)
            x_count <= x_count + 1'b1;
        else if (current_state == INCR_INDEX && x_count ==  TILE_COLS)
            x_count <= '0;
        else
            x_count <= x_count;
    end

    // Y counter 
    always_ff @(posedge clk) begin
        if(!rst_n || current_state == START)
            y_count <= '0;
        else if (current_state == INCR_INDEX && x_count == TILE_COLS)
            y_count <= y_count + 1'b1;
        else
            y_count <= y_count;
    end

    // State changing logic
    always_ff @(posedge clk) begin
        if(!rst_n)
            current_state <= START;
        else
            current_state <= next_state;
    end

    // Next state and output-forming logic
    always_comb begin
        next_state = current_state;
        dma_start = 1'b0;
        busy = 1'b1;
        tile_rden = 1'b0;

        case(current_state)
            START : begin
                busy = 1'b0;
    
                if(start && !bg_mode)
                    next_state = BEGIN_DRAW;
                else if(start && bg_mode)
                    next_state = READ_TILE;
            end
    
            READ_TILE : begin
                tile_rden = 1'b1;

                next_state = BEGIN_DRAW;
            end

            BEGIN_DRAW : begin
                dma_start = 1'b1;
    
                next_state = WAIT_DRAW;
            end
    
            WAIT_DRAW : begin
                // If done drawing, go back to the START state
                if(!dma_busy) begin
                    if(bg_mode_latch && x_count == TILE_COLS && y_count == TILE_ROWS)
                        next_state = START;
                    else if(!bg_mode_latch)
                        next_state = START;
                    else
                        next_state = INCR_INDEX;
                end
            end

            INCR_INDEX : begin
                next_state = READ_TILE;
            end
        endcase
    end

    // Block RAM storing the tile attributes
    BRAM_SDP_MACRO #(
        .BRAM_SIZE("18Kb"), // Target BRAM, "18Kb" or "36Kb"
        .DEVICE("7SERIES"), // Target device: "7SERIES"
        .WRITE_WIDTH(32), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        .READ_WIDTH(32), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        .DO_REG(0), // Optional output register (0 or 1)
        .INIT_FILE ("NONE"),
        .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
        .SRVAL(32'h00000000), // Set/Reset value for port output
        .INIT(32'h000000000), // Initial values on output port
        .WRITE_MODE("READ_FIRST") // Specify "READ_FIRST" for same clock or synchronous clocks
    ) Tile_Attr_Table (
        .DO(tile_rdata), // Output read data port, width defined by READ_WIDTH parameter
        .DI(bg_table_wdata), // Input write data port, width defined by WRITE_WIDTH parameter
        .RDADDR(tile_index), // Input read address, width defined by read port depth
        .RDCLK(clk), // 1-bit input read clock
        .RDEN(tile_rden), // 1-bit input read port enable
        .REGCE(1'b1), // 1-bit input read output register enable
        .RST(ram_rst), // 1-bit input reset
        .WE(bg_table_we), // Input write enable, width defined by write port depth
        .WRADDR(bg_table_wraddr), // Input write address, width defined by write port depth
        .WRCLK(clk), // 1-bit input write clock
        .WREN(bg_table_wren) // 1-bit input write port enable
    );

endmodule // dma_ctrl