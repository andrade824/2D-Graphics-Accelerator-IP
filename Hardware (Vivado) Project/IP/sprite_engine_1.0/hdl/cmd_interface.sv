
`timescale 1 ns / 1 ps

    module cmd_interface #
    (
        // Width of S_AXI data bus
        parameter integer C_S_AXI_DATA_WIDTH = 32,
        // Width of S_AXI address bus
        parameter integer C_S_AXI_ADDR_WIDTH = 16
    )
    (
        output logic enable,
        output logic [31:0] buffer1_addr, buffer2_addr, 
        output logic [31:0] bg_buffer_addr, tile_addr, sprite_addr,

        // Sprite table write port
        output logic [8:0] spr_table_wraddr,
        output logic [63:0] spr_table_wdata,
        output logic [7:0] spr_table_we,
        output logic spr_table_wren,

        // Background table write port
        output logic [8:0] bg_table_wraddr,
        output logic [31:0] bg_table_wdata,
        output logic [3:0] bg_table_we,
        output logic bg_table_wren,
        output logic bg_mode,
        
        // Global Clock Signal
        input logic S_AXI_ACLK,
        // Global Reset Signal. This Signal is Active LOW
        input logic S_AXI_ARESETN,
        // Write address (issued by master, acceped by Slave)
        input logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
        // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
        input logic [2:0] S_AXI_AWPROT,
        // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
        input logic S_AXI_AWVALID,
        // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
        output logic S_AXI_AWREADY,
        // Write data (issued by master, acceped by Slave) 
        input logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
        // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
        input logic [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
        // Write valid. This signal indicates that valid write
        // data and strobes are available.
        input logic S_AXI_WVALID,
        // Write ready. This signal indicates that the slave
        // can accept the write data.
        output logic S_AXI_WREADY,
        // Write response. This signal indicates the status
        // of the write transaction.
        output logic [1:0] S_AXI_BRESP,
        // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
        output logic S_AXI_BVALID,
        // Response ready. This signal indicates that the master
        // can accept a write response.
        input logic S_AXI_BREADY,
        // Read address (issued by master, acceped by Slave)
        input logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
        // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
        input logic [2:0] S_AXI_ARPROT,
        // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
        input logic S_AXI_ARVALID,
        // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
        output logic S_AXI_ARREADY,
        // Read data (issued by slave)
        output logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
        // Read response. This signal indicates the status of the
        // read transfer.
        output logic [1:0] S_AXI_RRESP,
        // Read valid. This signal indicates that the channel is
        // signaling the required read data.
        output logic S_AXI_RVALID,
        // Read ready. This signal indicates that the master can
        // accept the read data and response information.
        input logic S_AXI_RREADY
    );

    // Internal signals
    logic reg_wren, reg_rden;

    // AXI4LITE signals
    logic [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr;
    logic axi_awready;
    logic axi_wready;
    logic [1:0] axi_bresp;
    logic axi_bvalid;
    logic [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr;
    logic axi_arready;
    logic [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
    logic [1:0] axi_rresp;
    logic axi_rvalid;

    //----------------------------------------------
    //-- Registers
    //------------------------------------------------
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg4;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg5;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg6;
    logic [C_S_AXI_DATA_WIDTH-1:0] slv_reg7;
    logic slv_reg_rden;
    logic slv_reg_wren;
    logic [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;

    // Register Connections
    assign enable = slv_reg0[0];
    assign buffer1_addr = slv_reg1;
    assign buffer2_addr = slv_reg2;
    assign bg_buffer_addr = slv_reg3;
    assign tile_addr = slv_reg4;
    assign sprite_addr = slv_reg5;
    assign bg_mode = slv_reg6[0];

    // I/O Connections assignments
    assign S_AXI_AWREADY= axi_awready;
    assign S_AXI_WREADY = axi_wready;
    assign S_AXI_BRESP  = axi_bresp;
    assign S_AXI_BVALID = axi_bvalid;
    assign S_AXI_ARREADY= axi_arready;
    assign S_AXI_RDATA  = axi_rdata;
    assign S_AXI_RRESP  = axi_rresp;
    assign S_AXI_RVALID = axi_rvalid;
    
    // Different access type enables
    assign reg_wren = slv_reg_wren & (axi_awaddr[15:14] == 2'b00);
    assign reg_rden = slv_reg_rden & (axi_araddr[15:14] == 2'b00);
    assign spr_table_wren = slv_reg_wren & (axi_awaddr[15:14] == 2'b01);
    assign bg_table_wren = slv_reg_wren & (axi_awaddr[15:14] == 2'b10);

    //--------------------
    // Write Address Channel
    //--------------------

    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_awready <= 1'b0;
        else begin    
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
                axi_awready <= 1'b1;
            else           
                axi_awready <= 1'b0;
        end 
    end       

    // Latch the write address for later use
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_awaddr <= '0;
        else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            axi_awaddr <= S_AXI_AWADDR;
        else
            axi_awaddr <= axi_awaddr;
    end       

    //--------------------
    // Write Data Channel
    //--------------------

    always_ff @( posedge S_AXI_ACLK )
    begin
        if (!S_AXI_ARESETN)
            axi_wready <= 1'b0;
        else if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end       

    // Write the data to the appropriate memory
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    /** REGISTER WRITE INTERFACE **/
    always_ff @(posedge S_AXI_ACLK)
    begin
      if (!S_AXI_ARESETN) begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
          slv_reg4 <= 0;
          slv_reg5 <= 0;
          slv_reg6 <= 0;
          slv_reg7 <= 0;
        end else if (reg_wren) begin
            // Respective byte enables are asserted as per write strobes 
            case (axi_awaddr[4:2])
              3'h0:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h1:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h2:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h3:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h4:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h5:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h6:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              3'h7:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  

              default : begin
                  slv_reg0 <= slv_reg0;
                  slv_reg1 <= slv_reg1;
                  slv_reg2 <= slv_reg2;
                  slv_reg3 <= slv_reg3;
                  slv_reg4 <= slv_reg4;
                  slv_reg5 <= slv_reg5;
                  slv_reg6 <= slv_reg6;
                  slv_reg7 <= slv_reg7;
                end
            endcase
        end
    end    

    /** SPRITE TABLE WRITE INTERFACE **/
    assign spr_table_wraddr = axi_awaddr[12:5];

    // Sprite table address decoding
    always_comb begin
        spr_table_wdata = '0;
        spr_table_we = '0;

        // Single attribute write
        if(!axi_awaddr[13]) begin
            case(axi_awaddr[4:2])
                // X coord
                3'd0 : begin 
                    spr_table_we = 8'h03;
                    spr_table_wdata[15:0] = S_AXI_WDATA[15:0];
                end

                // Y coord
                3'd1 : begin 
                    spr_table_we = 8'h0C;
                    spr_table_wdata[31:16] = S_AXI_WDATA[15:0];
                end

                // Memory Slot
                3'd2 : begin 
                    spr_table_we = 8'h10;
                    spr_table_wdata[39:32] = S_AXI_WDATA[7:0];
                end

                // Width
                3'd3 : begin 
                    spr_table_we = 8'h20;
                    spr_table_wdata[47:40] = {S_AXI_WDATA[7:1], 1'b0};
                end

                // Height
                3'd4 : begin 
                    spr_table_we = 8'h40;
                    spr_table_wdata[55:48] = S_AXI_WDATA[7:0];
                end

                // Control
                3'd5 : begin 
                    spr_table_we = 8'h80;
                    spr_table_wdata[63:56] = S_AXI_WDATA[7:0];
                end
            endcase
        // Combo attribute write
        end else begin
            case(axi_awaddr[2])
                // X/Y write
                1'b0 : begin
                    spr_table_we = 8'h0F;
                    spr_table_wdata[15:0] = S_AXI_WDATA[15:0];
                    spr_table_wdata[31:16] = S_AXI_WDATA[31:16];
                end

                // Control/Memory Slot/Width/Height write
                1'b1 : begin
                    spr_table_we = 8'hF0;
                    spr_table_wdata[39:32] = S_AXI_WDATA[7:0];
                    spr_table_wdata[47:40] = {S_AXI_WDATA[15:9], 1'b0};
                    spr_table_wdata[55:48] = S_AXI_WDATA[23:16];
                    spr_table_wdata[63:56] = S_AXI_WDATA[31:24];
                end
            endcase
        end
    end

    /** BACKGROUND TABLE WRITE INTERFACE **/
    assign bg_table_wraddr = axi_awaddr[13:5];
    assign bg_table_wdata = S_AXI_WDATA;
    assign bg_table_we = '1;

    //----------------------------
    // Write Response (B) Channel
    //----------------------------

    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN) begin
            axi_bvalid <= '0;
            axi_bresp <= '0;
        end else if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
            // indicates a valid write response is available
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b0; // 'OKAY' response 
        end else if (S_AXI_BREADY && axi_bvalid) begin
            axi_bvalid <= 1'b0; 
        end
    end

    //----------------------------
    // Read Address Channel
    //----------------------------

    // Read address latching
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN) begin
            axi_arready <= '0;
            axi_araddr  <= '0;
        end else if (~axi_arready && S_AXI_ARVALID) begin
            axi_arready <= 1'b1;
            axi_araddr  <= S_AXI_ARADDR;
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
            axi_rresp  <= 0;
        end  else if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
            // Valid read data is available at the read data bus
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b0; // 'OKAY' response
        end else if (axi_rvalid && S_AXI_RREADY) begin
            // Read data is accepted by the master
            axi_rvalid <= 1'b0;
        end                
    end    

    // Register read address decoding
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    always_comb begin
        case (axi_araddr[4:2])
            4'h0 : reg_data_out <= slv_reg0;
            4'h1 : reg_data_out <= slv_reg1;
            4'h2 : reg_data_out <= slv_reg2;
            4'h3 : reg_data_out <= slv_reg3;
            4'h4 : reg_data_out <= slv_reg4;
            4'h5 : reg_data_out <= slv_reg5;
            4'h6 : reg_data_out <= slv_reg6;
            4'h7 : reg_data_out <= slv_reg7;
            default : reg_data_out <= 0;
        endcase
    end

    // Latch in register data for reading
    always_ff @(posedge S_AXI_ACLK)
    begin
        if (!S_AXI_ARESETN)
            axi_rdata  <= '0;
        else if (reg_rden)
            axi_rdata <= reg_data_out;
        else
            axi_rdata <= axi_rdata;
    end    

endmodule
