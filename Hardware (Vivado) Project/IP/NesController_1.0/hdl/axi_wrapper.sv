`timescale 1 ns / 1 ps

module axi_wrapper #
(
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH = 32,

    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH = 4
)
(
    input logic [7:0] btns,

    // Global Clock Signal
    input logic  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input logic  S_AXI_ARESETN,
    // Read address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether the
    // transaction is a data access or an instruction access.
    input logic [2:0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
    // is signaling valid read address and control information.
    input logic  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
    // ready to accept an address and associated control signals.
    output logic  S_AXI_ARREADY,
    // Read data (issued by slave)
    output logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
    // read transfer.
    output logic [1:0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
    // signaling the required read data.
    output logic  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    input logic  S_AXI_RREADY
);

    // AXI4LITE temp signals
    logic axi_arready;
    logic [7:0] axi_rdata;
    logic axi_rvalid;
    
    // I/O Connections assignments
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA = {24'b0,axi_rdata};
    assign S_AXI_RRESP = '0;
    assign S_AXI_RVALID = axi_rvalid;
    
    //----------------------------
    // Read Address Channel
    //----------------------------
    
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN) begin
            axi_arready <= '0;
        end else if (~axi_arready && S_AXI_ARVALID) begin
            axi_arready <= 1'b1;
        end else begin
            axi_arready <= 1'b0;
        end
    end
    
    //--------------------------------
    // Read Data (and Response) Channel
    //--------------------------------
    
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN) begin
            axi_rvalid <= 0;
        end  else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
            // Valid read data is available at the read data bus
            axi_rvalid <= 1'b1;
        end else if (axi_rvalid && S_AXI_RREADY) begin
            // Read data is accepted by the master
            axi_rvalid <= 1'b0;
        end                
    end
    
    // Latch in register data for reading
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_rdata  <= '0;
        else if (axi_arready & S_AXI_ARVALID & ~axi_rvalid)
            axi_rdata <= btns;
        else
            axi_rdata <= axi_rdata;
    end

endmodule
