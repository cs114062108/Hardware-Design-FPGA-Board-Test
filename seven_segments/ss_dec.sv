`timescale 1ns/1ps

module SevenSegDec (
    input  logic [3:0] value,
    input  logic dot,
    input  logic show,
    output logic [7:0] display,
    output logic dp
);
    
    always_comb begin
        if (show) begin
            case (value)
                // Zero means on:  ABC_DEFG
                4'd0: display = 7'b000_0001;
                4'd1: display = 7'b100_1111;
                4'd2: display = 7'b001_0010;
                4'd3: display = 7'b000_0110;
                4'd4: display = 7'b100_1100;
                4'd5: display = 7'b010_0100;
                4'd6: display = 7'b010_0000;
                4'd7: display = 7'b000_1111;
                4'd8: display = 7'b000_0000;
                4'd9: display = 7'b000_0100;

                // I'm just gonna write the hex part here,
                // cause I don't wanna write a new module 
                // with almost the save logic except these mappings
                // Zero means on:  ABC_DEFG
                4'ha: display = 7'b000_1000;
                4'hb: display = 7'b110_0000;
                4'hc: display = 7'b011_0001;
                4'hd: display = 7'b100_0010;
                4'he: display = 7'b011_0000;
                4'hf: display = 7'b011_1000;

                default: display = 7'b111_1110;
            endcase
        end else begin
            display = 7'b111_1111;
        end
    end

    assign dp = ~dot;

endmodule
