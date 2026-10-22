`timescale 1ns/1ps

module SingleRegister (
    input  logic clk,
    input  logic rst,
    input  logic enable,
    input  logic [511:0] key_down,
    input  logic [8:0] last_change,
    output logic new_press
);

    logic [511:0] key_down_prev;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            key_down_prev <= 512'd0;
        end else begin
            key_down_prev <= key_down;
        end
    end

    // One-cycle pulse only when this key goes from up to down.
    // Typematic repeats leave key_down unchanged, so they never trigger it.
    always_comb begin
        if (enable) begin
            new_press = key_down[last_change] && !key_down_prev[last_change];
        end else begin
            new_press = 1'b1;
        end
    end

endmodule
