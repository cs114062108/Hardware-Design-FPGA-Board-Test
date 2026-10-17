module DISPLAY_MUX (
    input  logic [3:0] digit,
    input  logic [6:0] dis_1, dis_2, dis_3, dis_4,
    input  logic dp_1, dp_2, dp_3, dp_4,
    output logic [6:0] display,
    output logic dp
);

    localparam FISRT  = 4'b0111;
    localparam SECOND = 4'b1011;
    localparam THIRD  = 4'b1101;
    localparam FOURTH = 4'b1110;

    always_comb begin
        case (digit)
            FISRT: begin
               display = dis_1;
               dp = dp_1;
            end

            SECOND: begin
                display = dis_2;
                dp = dp_2;
            end

            THIRD: begin
                display = dis_3;
                dp = dp_3;
            end

            FOURTH: begin
                display = dis_4;
                dp = dp_4;
            end

            default: begin
                display = 7'b111_1111;
                dp = 1'b1;
            end
        endcase
    end

endmodule
