 /**
 * This module drives the shfit register in the NES controller and grabs the button state.
 *
 * One register is used to hold the data as it's being shifted in while another contains the 
 * previously shifted in button state. That register is used by the AXI wrapper logic when it 
 * receives a request from the processor. This way partial button data doesn't get placed onto
 * the data bus.
 */

 module nes_driver(
    input logic clk,
    input logic data,
    output logic latch, pulse,
    output logic [7:0] btns
);

    // State machine variables
    typedef enum logic[3:0] {
        LATCH, A, PULSE1, B, PULSE2, SEL, PULSE3, START, PULSE4, 
        UP, PULSE5, DOWN, PULSE6, LEFT, PULSE7, RIGHT
    } nes_state;

    nes_state current_state, next_state;

    logic [7:0] partial_btns;
    logic shift;

    // Update the partial button state while polling the controller
    always_ff @(posedge clk) begin
        if(shift)
            partial_btns <= {partial_btns[6:0], data};
        else
            partial_btns <= partial_btns;
    end

    // Update the final button state once everything has been shifted in
    always_ff @(posedge clk) begin
        if(current_state == LATCH)
            btns <= partial_btns;
        else
            btns <= btns;
    end

    // State changing logic
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    // Next state and output-forming logic
    always_comb begin
        next_state = current_state;
        latch = '0;
        pulse = '0;
        shift = '0;

        case(current_state)
            
            LATCH : begin
                latch = 1'b1;
                next_state = A;
            end

            A : begin
                shift = 1'b1;
                next_state = PULSE1;
            end

            PULSE1 : begin
                pulse = 1'b1;
                next_state = B;
            end

            B : begin
                shift = 1'b1;
                next_state = PULSE2;
            end

            PULSE2 : begin
                pulse = 1'b1;
                next_state = SEL;
            end

            SEL : begin
                shift = 1'b1;
                next_state = PULSE3;
            end

            PULSE3 : begin
                pulse = 1'b1;
                next_state = START;
            end

            START : begin
                shift = 1'b1;
                next_state = PULSE4;
            end

            PULSE4 : begin
                pulse = 1'b1;
                next_state = UP;
            end

            UP : begin
                shift = 1'b1;
                next_state = PULSE5;
            end

            PULSE5 : begin
                pulse = 1'b1;
                next_state = DOWN;
            end

            DOWN : begin
                shift = 1'b1;
                next_state = PULSE6;
            end

            PULSE6 : begin
                pulse = 1'b1;
                next_state = LEFT;
            end

            LEFT : begin
                shift = 1'b1;
                next_state = PULSE7;
            end

            PULSE7 : begin
                pulse = 1'b1;
                next_state = RIGHT;
            end

            RIGHT : begin
                shift = 1'b1;
                next_state = LATCH;
            end

        endcase // current_state
    end

endmodule // nes_driver