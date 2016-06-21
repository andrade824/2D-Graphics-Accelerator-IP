/**
* Frame Controller
*
* Peforms two important jobs:
*   1. Manages swapping the framebuffers after every frame is drawn
*   2. Handles drawing the background and then the sprites
*/

module frame_ctrl(
    input logic clk, rst_n,
    input logic enable,
    input logic end_of_frame,
    input logic bg_busy, spr_busy,
    output logic bg_start, spr_start,
    output logic descriptor_mux_sel,        // 0 for background, 1 for sprites
    output logic buffer_mux_sel
);

    // State machine variables
    typedef enum logic[2:0] {START, SWAP_BUFFERS, DRAW_BG, WAIT_BG, DRAW_SPR, WAIT_SPR} frame_ctrl_state;
    frame_ctrl_state current_state, next_state;

    // Swap the buffers in the SWAP_BUFFERS state
    always_ff @(posedge clk) begin
        if(!rst_n)
            buffer_mux_sel <= 1'b0;
        else if(current_state == SWAP_BUFFERS)
            buffer_mux_sel <= ~buffer_mux_sel;
        else
            buffer_mux_sel <= buffer_mux_sel;
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
        bg_start = 1'b0;
        spr_start = 1'b0;
        descriptor_mux_sel = 1'b0;

        case(current_state)
            
            // Once the end_of_frame signal is received, start draw cycle
            START : begin
                if(end_of_frame && enable)
                    next_state = SWAP_BUFFERS;
                else
                    next_state = current_state;
            end

            // Swap the two framebuffers (this is a double-buffered system)
            SWAP_BUFFERS : begin
                // Actual buffer swapping is handled in the above always block
                next_state = DRAW_BG;
            end

            // Draw the background
            DRAW_BG : begin
                descriptor_mux_sel = 1'b0;
                bg_start = 1'b1;

                next_state = WAIT_BG;
            end

            // Wait for the background to finish drawing
            WAIT_BG : begin
                descriptor_mux_sel = 1'b0;

                if(bg_busy)
                    next_state = current_state;
                else
                    next_state = DRAW_SPR;
            end

            // Draw the sprites
            DRAW_SPR : begin
                descriptor_mux_sel = 1'b1;
                spr_start = 1'b1;

                next_state = WAIT_SPR;
            end

            // Wait for the sprites to finish drawing
            WAIT_SPR : begin
                descriptor_mux_sel = 1'b1;

                if(spr_busy)
                    next_state = current_state;
                else
                    next_state = START;
            end

        endcase // current_state
    end

endmodule // frame_ctrl