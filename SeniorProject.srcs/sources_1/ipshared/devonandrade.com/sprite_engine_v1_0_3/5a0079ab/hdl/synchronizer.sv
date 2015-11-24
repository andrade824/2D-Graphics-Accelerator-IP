`timescale 1 ns / 1 ps

/**
* Synchronizes the sig_in to the clk. Handles metastability issues by running
* through synchronization registers.
*
* Outputs one 'clk' pulse on sig_out when the positive edge of sig_in occurs.
*/
module posedge_sync (
    input logic clk,
    input logic sig_in,
    output logic sig_out
);

    logic [2:0] sync;

    // Asserts sig_out on positive edge of sig_in
    assign sig_out = sync[1] & ~sync[2];

    always_ff @(posedge clk)
    begin
        sync[0] <= sig_in;
        sync[1] <= sync[0];
        sync[2] <= sync[1];
    end

endmodule // synchronizer