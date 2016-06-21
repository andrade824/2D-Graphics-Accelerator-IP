/*
* 100MHz to 166.66KHz clock divider (~6us period)
*
* A 6us clock is required for reading from the NES controller.
*/
`timescale 1ns / 1ps
module clk_div(
    input logic clk,
    output logic clk_div);

    logic [8:0] count;
    logic c_tog;

    assign c_tog = (count == 9'd300);
    
    // For simulations
    initial begin
        count = '0;
        clk_div = '0;
    end
    
    // 1KHz clock divider
    always @(posedge clk)
    begin
        if(count < 9'd300)
            count = count + 1'b1;
        else
            count = '0;
    end
    
    always @(negedge clk)
    begin
        if(c_tog == 1'b1)
            clk_div = ~clk_div;
        else
            clk_div = clk_div;
    end
    
endmodule 
