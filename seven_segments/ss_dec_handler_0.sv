`timescale 1ns/1ps

module SSDecHandler0 #(
    parameter divide = 16
) (
    input logic clk,
    input logic rst,
    input logic [3:0] val1,
    input logic [3:0] val2,
    input logic [3:0] val3,
    input logic [3:0] val4,
    input logic dot1,
    input logic dot2,
    input logic dot3,
    input logic dot4,
    output logic [3:0] digit,
    output logic [6:0] display,
    output logic dp
);

    logic div_clk;

    clock_divider #(.n(divide)) clk_divide(
        .clk(clk), .rst(rst), .enable(1'b1), .clk_div(div_clk)
    );

    logic [7:0] dis_1;
    logic [7:0] dis_2;
    logic [7:0] dis_3;
    logic [7:0] dis_4;

    logic dp_1;
    logic dp_2;
    logic dp_3;
    logic dp_4;

    SevenSegDec SS1(.value(val1), .dot(dot1), .display(dis_1), .dp(dp_1));
    SevenSegDec SS2(.value(val2), .dot(dot2), .display(dis_2), .dp(dp_2));
    SevenSegDec SS3(.value(val3), .dot(dot3), .display(dis_3), .dp(dp_3));
    SevenSegDec SS4(.value(val4), .dot(dot4), .display(dis_4), .dp(dp_4));
    
    
    localparam FISRT  = 4'b0111;
    localparam SECOND = 4'b1011;
    localparam THIRD  = 4'b1101;
    localparam FOURTH = 4'b1110;

    logic [3:0] val;
    logic [3:0] next_digit;

    always_ff @(posedge div_clk) begin
        digit <= next_digit;
    end

    always_comb begin
        case (digit)
            FISRT: begin
               display = dis_1;
               dp = dp_1;
               val = 4'd1;
               next_digit = SECOND;
            end

            SECOND: begin
                display = dis_2;
                dp = dp_2;
                val = 4'd2;
                next_digit = THIRD;
            end

            THIRD: begin
                display = dis_3;
                dp = dp_3;
                val = 4'd3;
                next_digit = FOURTH;
            end

            FOURTH: begin
                display = dis_4;
                dp = dp_4;
                val = 4'd4;
                next_digit = FISRT;
            end

            default: begin
                display = 7'b111_1111;
                dp = 1'b1;
                val = 4'd0;
                next_digit = FISRT;
            end
        endcase
    end

endmodule
