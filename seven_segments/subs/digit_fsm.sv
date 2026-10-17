module DIGIT_FSM (
    input  logic div_clk,
    output logic [3:0] digit
);

    localparam FISRT  = 4'b0111;
    localparam SECOND = 4'b1011;
    localparam THIRD  = 4'b1101;
    localparam FOURTH = 4'b1110;

    logic [3:0] next_digit;

    always_ff @(posedge div_clk) begin
        digit <= next_digit;
    end

    always_comb begin
        case (digit)
            FISRT: begin
                next_digit = SECOND;
            end

            SECOND: begin
                next_digit = THIRD;
            end

            THIRD: begin
                next_digit = FOURTH;
            end

            FOURTH: begin
                next_digit = FISRT;
            end

            default: begin
                next_digit = FISRT;
            end
        endcase
    end

endmodule