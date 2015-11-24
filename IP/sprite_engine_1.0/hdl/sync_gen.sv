`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Devon Andrade
// 
// Design Name: VGA Sync Generator
// Description: Generates sync and blanking pulses for a variety of
// resolutions. Check tinyvga.com for timing parameters. 
// 
//  640x480 Resolution parameters:
//    H_VISIBLE = 640,
//    H_FRONT_PORCH = 16,
//    H_SYNC = 96,
//    H_BACK_PORCH = 48,
//
//    V_VISIBLE = 480,
//    V_FRONT_PORCH = 10,
//    V_SYNC = 2,
//    V_BACK_PORCH = 33
//
//////////////////////////////////////////////////////////////////////////////////

module sync_gen #(
    // Horizontal timing parameters
    parameter H_VISIBLE = 640,
    parameter H_FRONT_PORCH = 16,
    parameter H_SYNC = 96,
    parameter H_BACK_PORCH = 48,

    // Vertical timing parameters
    parameter V_VISIBLE = 480,
    parameter V_FRONT_PORCH = 10,
    parameter V_SYNC = 2,
    parameter V_BACK_PORCH = 33
)
(
    input logic clk,
    input logic [31:0] pixel_data,
    output logic next_pixel_please,
    output logic [4:0] red,
    output logic [5:0] green,
    output logic [4:0] blue,
    output logic h_sync, v_sync, 
    output logic h_blank, v_blank, blank_n
);
    // function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction
	
	/* SYNCHRONIZATION SIGNAL LOGIC */
	localparam COUNTER_WIDTH  = clogb2(H_VISIBLE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH);

    // Parameters that determine the maximum line and frame sizes
    localparam [COUNTER_WIDTH-1:0] H_WHOLE_LINE = H_VISIBLE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH;
    localparam [COUNTER_WIDTH-1:0] V_WHOLE_FRAME = V_VISIBLE + V_FRONT_PORCH + V_SYNC + V_BACK_PORCH;
    
    // The counters used to create the sync and blank pulses
    logic [COUNTER_WIDTH-1:0] pix_x, pix_y;

    // Determines when to turn on sync and blank signals
    assign h_sync = (pix_x >= (H_VISIBLE + H_FRONT_PORCH) && pix_x < (H_VISIBLE + H_FRONT_PORCH + H_SYNC));
    assign h_blank = (pix_x >= H_VISIBLE && pix_x < H_WHOLE_LINE);
    
    assign v_sync = (pix_y >= (V_VISIBLE + V_FRONT_PORCH) && pix_y < (V_VISIBLE + V_FRONT_PORCH + V_SYNC));
    assign v_blank = (pix_y >= V_VISIBLE && pix_y < V_WHOLE_FRAME);
    
    // A single active-low blanking signal when either blanking is happening
    assign blank_n = ~(h_blank | v_blank);
    
    always_ff @(negedge clk) begin
        if (pix_x < H_WHOLE_LINE - 1) begin // End of pixel, go to next pixel
            pix_x <= pix_x + 1;
            pix_y <= pix_y;
        end else begin  // End of line, go to next line
            pix_x <= '0;
            if(pix_y < V_WHOLE_FRAME - 1)
                pix_y <= pix_y + 1;
            else    // End of frame, go back to top
                pix_y <= '0;
        end
    end
    
    /* COLOR LOGIC */
    logic pixel_toggle;
    logic [31:0] pixel_cache;
    
    // Determines when to grab the next pixel
    assign next_pixel_please = blank_n & pixel_toggle;
    
    // Toggle the pixel flag every clock edge we're displaying data
    always_ff @(posedge clk) begin
        if(blank_n)
            pixel_toggle <= ~pixel_toggle;
        else
            pixel_toggle <= pixel_toggle;
    end
    
    // Pixel cache stores the next two pixels to display
    always_ff @(posedge clk) begin
        if(next_pixel_please)
            pixel_cache <= pixel_data;
        else
            pixel_cache <= pixel_cache;
    end
    
    // Choose between which pixel in the cache to display (or nothing if during blanking)
    always_comb begin
        if(!blank_n) begin
            red = '0;
            green = '0;
            blue = '0;
        end else begin
            case(pixel_toggle)
                1'b0 : begin
                    red = pixel_cache[15:11];
                    green = pixel_cache[10:5];
                    blue = pixel_cache[4:0];
                end
                
                1'b1 : begin
                    red = pixel_cache[31:27];
                    green = pixel_cache[26:21];
                    blue = pixel_cache[20:16];
                end
            endcase
        end
    end
    
endmodule