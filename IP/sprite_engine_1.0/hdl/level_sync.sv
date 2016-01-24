`timescale 1 ns / 1 ps

/**
* Synchronizes the sig_in to the clk. Handles metastability issues by running
* through synchronization registers.
*/
module level_sync (
    input logic clk,
    input logic sig_in,
    output logic sig_out
);

    logic [1:0] sync;

    assign sig_out = sync[1];

    always_ff @(posedge clk)
    begin
        sync[0] <= sig_in;
        sync[1] <= sync[0];
    end

endmodule // synchronizer