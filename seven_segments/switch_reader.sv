`timescale 1ns/1ps

module SwitchReader (
    input logic clk,
    input logic rst,
    input logic [7:0] switch_input,
    input logic [1:0] switch_inputtype,
    input logic valid,
    output logic [3:0] v_1,
    output logic [3:0] v_2,
    output logic [3:0] v_3,
    output logic [3:0] v_4,
    output logic [5:0] tgt,
    output logic [3:0] msk
);

    // --------------------------------
    // Define input types
    // --------------------------------
    localparam VAL12 = 2'b00; // Load val_1 from SW7–SW4 and val_2 from SW3–SW0
    localparam VAL34 = 2'b01; // Load val_3 from SW7–SW4 and val_4 from SW3–SW0
    localparam TGT   = 2'b10; // Load target from SW5–SW0
    localparam MASK  = 2'b11; // Load mask from SW3–SW0

    // ----------------------------------------------------------------------
    // Registers: Stores the inputs
    //            Loaded from switches when valid=1 at rising edge
    //            rst is asynchronous here, must be in the sensitivity list
    // ----------------------------------------------------------------------
    reg [3:0] val_1;  // 2'b00 (VAL12) : SW7-SW4
    reg [3:0] val_2;  // 2'b00 (VAL12) : SW3-SW0
    reg [3:0] val_3;  // 2'b01 (VAL34) : SW7-SW4
    reg [3:0] val_4;  // 2'b01 (VAL34) : SW3-SW0
    reg [5:0] target; // 2'b01 (TGT)   : SW5-SW0
    reg [3:0] mask;   // 2'b11 (MASK)  : SW3-SW0

    always_ff @(posedge clk or posedge rst) begin : InputRegister
        if (rst) begin
            val_1  <= 4'd0;
            val_2  <= 4'd0;
            val_3  <= 4'd0;
            val_4  <= 4'd0;
            target <= 6'd0;
            mask   <= 4'd0;
        end else if (valid) begin
            case (switch_inputtype)
                VAL12: begin
                    val_1 <= switch_input[7:4];
                    val_2 <= switch_input[3:0];
                end

                VAL34: begin
                    val_3 <= switch_input[7:4];
                    val_4 <= switch_input[3:0];
                end

                TGT: begin
                    target <= switch_input[5:0];
                end

                MASK: begin
                    mask <= switch_input[3:0];
                end

                default: ;  // Default: Latch everthing
            endcase
        end
    end

    // ----------------------
    // Mirror the outputs
    // ----------------------
    assign v_1 = val_1;
    assign v_2 = val_2;
    assign v_3 = val_3;
    assign v_4 = val_4;
    assign tgt = target;
    assign msk = mask;

endmodule
