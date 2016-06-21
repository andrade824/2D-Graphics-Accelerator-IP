/**
* Framebuffer Address Mux
*
* This 2:1 mux chooses between the addresses for the two framebuffers
*/

module framebuffer_mux (
    input logic sel,
    input logic [31:0] in1, in2,
    output logic [31:0] out
);

    always_comb begin
        case(sel)
            1'b0 : out = in1;
            1'b1 : out = in2;
        endcase // sel
    end

endmodule // framebuffer_mux