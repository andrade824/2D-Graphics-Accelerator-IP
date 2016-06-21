/**
* DMA Descriptor Mux
*
* This 2:1 mux chooses between the descriptor coming from the BG or Sprite controller
*/

module dma_descriptor_mux (
    input logic sel,
    
    // Background Descriptor interface
    input logic bg_start,
    input logic [31:0] bg_source_addr,
    input logic [9:0] bg_dest_x, bg_dest_y,
    input logic [9:0] bg_dest_width, bg_dest_height,
    input logic bg_dest_mode,    // 0 for stream, 1 for rectangle

    // Sprite Descriptor interface
    input logic spr_start,
    input logic [31:0] spr_source_addr,
    input logic [9:0] spr_dest_x, spr_dest_y,
    input logic [9:0] spr_dest_width, spr_dest_height,
    input logic spr_dest_mode,    // 0 for stream, 1 for rectangle

    // Final Descriptor interface
    output logic start,
    output logic [31:0] source_addr,
    output logic [9:0] dest_x, dest_y,
    output logic [9:0] dest_width, dest_height,
    output logic dest_mode    // 0 for stream, 1 for rectangle

);

    always_comb begin
        case(sel)
            // Background Descriptor
            1'b0 : begin
                start = bg_start;
                source_addr = bg_source_addr;
                dest_x = bg_dest_x;
                dest_y = bg_dest_y;
                dest_width = bg_dest_width;
                dest_height = bg_dest_height;
                dest_mode = bg_dest_mode;
            end

            // Sprite Descriptor
            1'b1 : begin
                start = spr_start;
                source_addr = spr_source_addr;
                dest_x = spr_dest_x;
                dest_y = spr_dest_y;
                dest_width = spr_dest_width;
                dest_height = spr_dest_height;
                dest_mode = spr_dest_mode;
            end
        endcase // sel
    end

endmodule // dma_descriptor_mux