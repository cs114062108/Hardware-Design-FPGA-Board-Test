`timescale 1ns/1ps

module SSExMod0 (
    input logic clk,
    input logic rst,
    input logic [7:0] switch_input,
    input logic [1:0] switch_inputtype,
    input logic valid,
    output logic [3:0] digit,
    output logic [6:0] display,
    output logic dp
);  

    // ---------------------------------------------------------
    // Read Switches: Synchronous read and asynchronous reset
    // ---------------------------------------------------------
    logic [3:0] val_1;  // 2'b00 (VAL12) : SW7-SW4
    logic [3:0] val_2;  // 2'b00 (VAL12) : SW3-SW0
    logic [3:0] val_3;  // 2'b01 (VAL34) : SW7-SW4
    logic [3:0] val_4;  // 2'b01 (VAL34) : SW3-SW0
    logic [5:0] target; // 2'b01 (TGT)   : SW5-SW0
    logic [3:0] mask;   // 2'b11 (MASK)  : SW3-SW0

    SwitchReader switch_read(
        .clk(clk), .rst(rst),
        .switch_input(switch_input), .switch_inputtype(switch_inputtype),
        .valid(valid),
        .v_1(val_1), .v_2(val_2), .v_3(val_3), .v_4(val_4), .tgt(target), .msk(mask)
    );

    // ------------------------------------------------------------
    // Display Values on Seven Segments: val_4 val_3 val_2 val_1
    // ------------------------------------------------------------
    localparam VAL12 = 2'b00; // Show the four values in hex and place dots on val_2 and val_1
    localparam VAL34 = 2'b01; // Show the four values in hex and place dots on val_4 and val_3
    localparam TGT   = 2'b10; // Show the target value in hex with val_2 and val_1, val_4 and val_3 be x, show dots on val_2 and val_1 when valid
    localparam MASK  = 2'b11; // Show the masked with the four displays and dots

    logic [3:0] dis_val1, dis_val2, dis_val3, dis_val4;
    logic       dis_dot1, dis_dot2, dis_dot3, dis_dot4;

    always_comb begin
        case (switch_inputtype)
            VAL12: begin
                dis_val4 = val_4;
                dis_val3 = val_3;
                dis_val2 = val_2;
                dis_val1 = val_1;

                dis_dot4 = 1'b0;
                dis_dot3 = 1'b0;
                dis_dot2 = 1'b1;
                dis_dot1 = 1'b1;
            end

            VAL34: begin
                dis_val4 = val_4;
                dis_val3 = val_3;
                dis_val2 = val_2;
                dis_val1 = val_1;

                dis_dot4 = 1'b1;
                dis_dot3 = 1'b1;
                dis_dot2 = 1'b0;
                dis_dot1 = 1'b0;
            end

            TGT: begin
                dis_val4 = 4'd0;
                dis_val3 = 4'd0;
                dis_val2 = {2'b00, target[5:4]};
                dis_val1 = target[3:0];

                dis_dot4 = 1'b0;
                dis_dot3 = 1'b0;
                dis_dot2 = 1'b1;
                dis_dot1 = 1'b1;
            end

            MASK: begin
                dis_val4 = {3'b000, mask[3]};
                dis_val3 = {3'b000, mask[2]};
                dis_val2 = {3'b000, mask[1]};
                dis_val1 = {3'b000, mask[0]};

                dis_dot4 = mask[3];
                dis_dot3 = mask[2];
                dis_dot2 = mask[1];
                dis_dot1 = mask[0];
            end

            default: begin
                dis_val4 = 4'd0;
                dis_val3 = 4'd0;
                dis_val2 = 4'd0;
                dis_val1 = 4'd0;

                dis_dot4 = 1'b0;
                dis_dot3 = 1'b0;
                dis_dot2 = 1'b0;
                dis_dot1 = 1'b0;
            end

        endcase
    end

    SSDecHandler0 ss_handler (
        .clk(clk), .rst(rst),
        .val1(dis_val4), .val2(dis_val3), .val3(dis_val2), .val4(dis_val1),
        .dot1(dis_dot4), .dot2(dis_dot3), .dot3(dis_dot2), .dot4(dis_dot1),
        .digit(digit), .display(display), .dp(dp)
    );

endmodule
