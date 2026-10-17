`timescale 1ns/1ps

module double_click_detect (
    input  logic clk,
    input  logic rst,
    input  logic click,       // debounced + one-pulse input
    output logic dbl_pulse,   // one-cycle pulse on double-click
    output logic sgl_pulse    // one-cycle pulse on single-click (after window expires)
);

    localparam IDLE = 1'b0;
    localparam WAIT = 1'b1;

    logic state, next_state;
    logic timeout;
    logic dbl_next, sgl_next;

    timer #(.COUNT(50_000_000)) window_timer (
        .clk(clk), .rst(rst), .enable(state == WAIT), .tick(timeout)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            dbl_pulse <= 1'b0;
            sgl_pulse <= 1'b0;
        end else begin
            state     <= next_state;
            dbl_pulse <= dbl_next;
            sgl_pulse <= sgl_next;
        end
    end

    always_comb begin
        next_state = state;
        dbl_next   = 1'b0;
        sgl_next   = 1'b0;

        case (state)
            IDLE: begin
                if (click)
                    next_state = WAIT;
            end

            WAIT: begin
                if (click) begin
                    dbl_next   = 1'b1;   // second click inside window: double
                    next_state = IDLE;
                end else if (timeout) begin
                    sgl_next   = 1'b1;   // no second click: single
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule
