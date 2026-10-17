`timescale 1ns/1ps

module debounce #(
    parameter n = 4
) (
    input  logic clk,
    output logic pb_db, // output after being debounced
    input  logic pb     // input from a push button
);

    logic [n-1:0] shift_reg;  // use shift_reg to filter the bounce

    always_ff @(posedge clk) begin
        shift_reg <= {shift_reg[n-2:0], pb};
    end

    assign pb_db = (shift_reg == {n{1'b1}}) ? 1'b1 : 1'b0;

endmodule
