/**
* Sprite controller
*
* When triggered, displays every enabled sprite to the screen.
*/

module spr_ctrl # (
    parameter integer MAX_SPRITES = 256
)
(
    input logic clk, rst_n,
    input logic [31:0] sprite_addr,

    // Control signals for the frame controller
    input logic start,
    output logic busy,

    // Descriptor interface
    input logic dma_busy,
    output logic dma_start,
    output logic [31:0] dma_source_addr,
    output logic [9:0] dma_dest_x, dma_dest_y,
    output logic [9:0] dma_dest_width, dma_dest_height,
    output logic dma_dest_mode,    // 0 for stream, 1 for rectangle

    // Sprite table write port
    input logic [8:0] spr_table_wraddr,
    input logic [63:0] spr_table_wdata,
    input logic [7:0] spr_table_we,
    input logic spr_table_wren
);

    logic ram_rst;
    logic [63:0] spr_rdata;
    logic [8:0] spr_index;
    logic spr_rden;

    // Background controller state machine variables
    typedef enum logic[2:0] {START, READ_SPR, CHECK_ENABLED, BEGIN_DRAW, WAIT_DRAW, INCR_INDEX} spr_state;
    spr_state current_state, next_state;

    // Extract DMA descriptor info out of sprite attribute table
    assign dma_source_addr = sprite_addr + (spr_rdata[39:32] << 11);
    assign dma_dest_x = spr_rdata[15:0];
    assign dma_dest_y = spr_rdata[31:16];
    assign dma_dest_width = spr_rdata[47:40];
    assign dma_dest_height = spr_rdata[55:48];
    assign dma_dest_mode = 1'b1;

    // Block RAM reset is active high
    assign ram_rst = ~rst_n;

    // Sprite index counter
    always_ff @(posedge clk) begin
        if(!rst_n || current_state == START)
            spr_index <= '0;
        else if (current_state == INCR_INDEX)
            spr_index <= spr_index + 1'b1;
        else
            spr_index <= spr_index;
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
        spr_rden = 1'b0;

        case(current_state)
            START : begin
                busy = 1'b0;
    
                if(start)
                    next_state = READ_SPR;
            end
    
            READ_SPR : begin
                spr_rden = 1'b1;

                next_state = CHECK_ENABLED;
            end

            CHECK_ENABLED : begin
                //  If enable bit is set, go to draw state
                if(spr_rdata[56])
                    next_state = BEGIN_DRAW;
                else
                    next_state = INCR_INDEX;
            end

            BEGIN_DRAW : begin
                dma_start = 1'b1;
    
                next_state = WAIT_DRAW;
            end
    
            WAIT_DRAW : begin
                if(!dma_busy)
                    next_state = INCR_INDEX;
            end

            INCR_INDEX : begin
                // If done drawing, go back to start state
                if(spr_index < (MAX_SPRITES - 1))
                    next_state = READ_SPR;
                else
                    next_state = START;
            end
        endcase
    end

    // Block RAM storing the sprite attributes
    BRAM_SDP_MACRO #(
        .BRAM_SIZE("36Kb"), // Target BRAM, "18Kb" or "36Kb"
        .DEVICE("7SERIES"), // Target device: "7SERIES"
        .WRITE_WIDTH(64), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        .READ_WIDTH(64), // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
        .DO_REG(0), // Optional output register (0 or 1)
        .INIT_FILE ("NONE"),
        .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
        .SRVAL(64'h000000000000000000), // Set/Reset value for port output
        .INIT(64'h000000000000000000), // Initial values on output port
        .WRITE_MODE("READ_FIRST") // Specify "READ_FIRST" for same clock or synchronous clocks
    ) Sprite_Attr_Table (
        .DO(spr_rdata), // Output read data port, width defined by READ_WIDTH parameter
        .DI(spr_table_wdata), // Input write data port, width defined by WRITE_WIDTH parameter
        .RDADDR(spr_index), // Input read address, width defined by read port depth
        .RDCLK(clk), // 1-bit input read clock
        .RDEN(spr_rden), // 1-bit input read port enable
        .REGCE(1'b1), // 1-bit input read output register enable
        .RST(ram_rst), // 1-bit input reset
        .WE(spr_table_we), // Input write enable, width defined by write port depth
        .WRADDR(spr_table_wraddr), // Input write address, width defined by write port depth
        .WRCLK(clk), // 1-bit input write clock
        .WREN(spr_table_wren) // 1-bit input write port enable
    );
    
endmodule // dma_ctrl
