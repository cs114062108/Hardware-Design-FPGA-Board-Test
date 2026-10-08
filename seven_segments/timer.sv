`timescale 1ns/1ps

module timer #(
    parameter integer COUNT = 100_000_000
)(
    input logic clk,
    input logic rst,
    input logic enable,
    output logic tick
);

    logic [31:0] num;
    logic [31:0] next_num;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            num <= 32'd0;
        end else begin
            num <= next_num;
        end
    end

    assign next_num = (enable == 1'b0) ? 32'd0 :
                      (num == COUNT - 1) ? 32'd0 :
                      num + 1'b1;
    assign tick = enable && (num == COUNT - 1);
endmodule
