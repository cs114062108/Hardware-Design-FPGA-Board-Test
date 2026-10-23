`timescale 1ns/1ps

module KeyLock (
    input  logic clk,
    input  logic rst,
    input  logic enable,
    input  logic [511:0] key_down,
    input  logic [8:0] last_change,
    input  logic accepted,
    output logic locked
);

    logic is_locked;
    logic [8:0] locked_code;

    logic key_accepted;
    assign key_accepted = accepted && !is_locked;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            is_locked   <= 1'b0;
            locked_code <= 9'd0;
        end else if (key_accepted) begin
            is_locked   <= 1'b1;
            locked_code <= last_change;
        end else if (is_locked && !key_down[locked_code]) begin
            is_locked   <= 1'b0;    // the accepted key has been released
        end
    end

    assign locked = enable && is_locked;

endmodule
