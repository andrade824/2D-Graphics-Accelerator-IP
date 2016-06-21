/**
* Top-level module for the NES Controller driver design.
*/
`timescale 1 ns / 1 ps

module NesController #
(
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
)
(
    // Controller ports
    input logic data,
    output logic latch, pulse,

    // Ports of Axi Slave Bus Interface S00_AXI
    input logic s00_axi_aclk,
    input logic s00_axi_aresetn,
    input logic [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_araddr,
    input logic [2 : 0] s00_axi_arprot,
    input logic s00_axi_arvalid,
    output logic s00_axi_arready,
    output logic [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_rdata,
    output logic [1 : 0] s00_axi_rresp,
    output logic s00_axi_rvalid,
    input logic s00_axi_rready
);

    logic [7:0] btns;
    logic clk_nes;

    axi_wrapper # ( 
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) axi_wrapper_inst (
        .btns(btns),
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready)
    );

    // 100MHz to 166.66KHz clock divider (~6us period)
    clk_div clk_div_inst (
        .clk(s00_axi_aclk),
        .clk_div(clk_nes)
    );

    // NES Controller driver logic
    nes_driver nes_driver_inst (
        .clk(clk_nes),
        .data(data),
        .latch(latch),
        .pulse(pulse),
        .btns(btns)
    );

endmodule
