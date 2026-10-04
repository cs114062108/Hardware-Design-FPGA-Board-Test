`timescale 1ns/1ps

module SSExMod0 (
    input logic clk,
    input logic rst,
    input logic [7:0] switch_input,
    input logic [1:0] switch_inputtype,
    input logic valid,
    input logic preview,
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
    // Display Values on Seven Segments: val_1 val_2 val_3 val_4
    // ------------------------------------------------------------
    localparam VAL12 = 2'b00; // Show the four values in hex and place dots when  on val_1 and val_2
    localparam VAL34 = 2'b01; // Show the four values in hex and place dots on val_3 and val_4
    localparam TGT   = 2'b10; // Show the target value in hex with val_3 and val_4, val_1 and val_2 be 0, show dots on val_3 and val_4
    localparam MASK  = 2'b11; // Show the masked with the four displays and dots

    logic [3:0] dis_val1, dis_val2, dis_val3, dis_val4;
    logic       dis_dot1, dis_dot2, dis_dot3, dis_dot4;

    logic [3:0] in_val1, in_val2;
    assign in_val1 = switch_input[7:4];
    assign in_val2 = switch_input[3:0];
    logic [5:0] in_tgt;
    assign in_tgt = switch_input[5:0];

    always_comb begin
        case (switch_inputtype)
            VAL12: begin
                if (preview) begin
                    dis_val1 = in_val1;
                    dis_val2 = in_val2;
                end else begin
                    dis_val1 = val_1;
                    dis_val2 = val_2;
                end
                dis_val3 = val_3;
                dis_val4 = val_4;

                dis_dot1 = 1'b1;
                dis_dot2 = 1'b1;
                dis_dot3 = 1'b0;
                dis_dot4 = 1'b0;
            end

            VAL34: begin
                dis_val1 = val_1;
                dis_val2 = val_2;
                if (preview) begin
                    dis_val3 = in_val1;
                    dis_val4 = in_val2;
                end else begin
                    dis_val3 = val_3;
                    dis_val4 = val_4;
                end

                dis_dot1 = 1'b0;
                dis_dot2 = 1'b0;
                dis_dot3 = 1'b1;
                dis_dot4 = 1'b1;
            end

            TGT: begin
                dis_val1 = 4'd0;
                dis_val2 = 4'd0;
                if (preview) begin
                    dis_val3 = {2'b00, in_tgt[5:4]};
                    dis_val4 = in_tgt[3:0];
                end else begin
                    dis_val3 = {2'b00, target[5:4]};
                    dis_val4 = target[3:0];
                end

                dis_dot1 = 1'b0;
                dis_dot2 = 1'b0;
                dis_dot3 = 1'b1;
                dis_dot4 = 1'b1;
            end

            MASK: begin
                dis_val1 = {3'b000, mask[3]};
                dis_val2 = {3'b000, mask[2]};
                dis_val3 = {3'b000, mask[1]};
                dis_val4 = {3'b000, mask[0]};

                dis_dot1 = mask[3];
                dis_dot2 = mask[2];
                dis_dot3 = mask[1];
                dis_dot4 = mask[0];
            end

            default: begin
                dis_val1 = 4'd0;
                dis_val2 = 4'd0;
                dis_val3 = 4'd0;
                dis_val4 = 4'd0;

                dis_dot1 = 1'b0;
                dis_dot2 = 1'b0;
                dis_dot3 = 1'b0;
                dis_dot4 = 1'b0;
            end

        endcase
    end

    SSDecHandler0 ss_handler (
        .clk(clk), .rst(rst),
        .val1(dis_val1), .val2(dis_val2), .val3(dis_val3), .val4(dis_val4),
        .dot1(dis_dot1), .dot2(dis_dot2), .dot3(dis_dot3), .dot4(dis_dot4),
        .digit(digit), .display(display), .dp(dp)
    );

endmodule
