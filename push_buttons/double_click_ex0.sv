`timescale 1ns/1ps

module double_click_ex0 (
    input  logic clk,
    input  logic btnC,  // button rst
    input  logic btnU,  // button 1
    input  logic btnD,  // button 2
    input  logic btnL,  // button 3
    input  logic btnR,  // button 4
    output logic [3:0] digit,
    output logic [6:0] display,
    output logic dp
);

    // --------------------------------------------------------------
    // Debounce the rst Button (btnC)
    // --------------------------------------------------------------
    logic rst;
    debounce rst_debounce(.clk(clk), .pb(btnC), .pb_db(rst));

    // --------------------------------------------------------------
    // Debounce & One Pulse the Push Buttons
    // --------------------------------------------------------------
    logic btnU_db;
    debounce U_db(.clk(clk), .pb(btnU), .pb_db(btnU_db));
    logic btnU_pulse;
    one_pulse U_op(.clk(clk), .pb_in(btnU_db), .pb_out(btnU_pulse));

    logic btnD_db;
    debounce D_db(.clk(clk), .pb(btnD), .pb_db(btnD_db));
    logic btnD_pulse;
    one_pulse D_op(.clk(clk), .pb_in(btnD_db), .pb_out(btnD_pulse));
    
    logic btnL_db;
    debounce L_db(.clk(clk), .pb(btnL), .pb_db(btnL_db));
    logic btnL_pulse;
    one_pulse L_op(.clk(clk), .pb_in(btnL_db), .pb_out(btnL_pulse));

    logic btnR_db;
    debounce R_db(.clk(clk), .pb(btnR), .pb_db(btnR_db));
    logic btnR_pulse;
    one_pulse R_op(.clk(clk), .pb_in(btnR_db), .pb_out(btnR_pulse));

    // --------------------------------------------------------------
    // Double Click Detectors
    // --------------------------------------------------------------
    logic btnU_sgl, btnU_dbl;
    logic btnD_sgl, btnD_dbl;
    logic btnL_sgl, btnL_dbl;
    logic btnR_sgl, btnR_dbl;

    double_click_detect U_dbc(.clk(clk), .rst(rst), .click(btnU_pulse), .sgl_pulse(btnU_sgl), .dbl_pulse(btnU_dbl));
    double_click_detect D_dbc(.clk(clk), .rst(rst), .click(btnD_pulse), .sgl_pulse(btnD_sgl), .dbl_pulse(btnD_dbl));
    double_click_detect L_dbc(.clk(clk), .rst(rst), .click(btnL_pulse), .sgl_pulse(btnL_sgl), .dbl_pulse(btnL_dbl));
    double_click_detect R_dbc(.clk(clk), .rst(rst), .click(btnR_pulse), .sgl_pulse(btnR_sgl), .dbl_pulse(btnR_dbl));

    // --------------------------------------------------------------
    // Double Click Detect to Display
    // --------------------------------------------------------------
    logic [1:0] U_cnt, D_cnt, L_cnt, R_cnt;
    logic [1:0] next_U_cnt, next_D_cnt, next_L_cnt, next_R_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            U_cnt <= 2'd0;
            D_cnt <= 2'd0;
            L_cnt <= 2'd0;
            R_cnt <= 2'd0;
        end else begin
            U_cnt <= next_U_cnt;
            D_cnt <= next_D_cnt;
            L_cnt <= next_L_cnt;
            R_cnt <= next_R_cnt;
        end
    end

    always_comb begin
        next_U_cnt = U_cnt;
        next_D_cnt = D_cnt;
        next_L_cnt = L_cnt;
        next_R_cnt = R_cnt;

        if (btnU_dbl) begin
            next_U_cnt = 2'd2;
        end else if (btnU_sgl) begin
            next_U_cnt = 2'd1;
        end

        if (btnD_dbl) begin
            next_D_cnt = 2'd2;
        end else if (btnD_sgl) begin
            next_D_cnt = 2'd1;
        end

        if (btnL_dbl) begin
            next_L_cnt = 2'd2;
        end else if (btnL_sgl) begin
            next_L_cnt = 2'd1;
        end

        if (btnR_dbl) begin
            next_R_cnt = 2'd2;
        end else if (btnR_sgl) begin
            next_R_cnt = 2'd1;
        end
    end

    // --------------------------------------------------------------
    // Display Values on Seven Segments: val_1 val_2 val_3 val_4
    // --------------------------------------------------------------
    logic [3:0] dis_val1, dis_val2, dis_val3, dis_val4;
    logic       dis_dot1, dis_dot2, dis_dot3, dis_dot4;
    logic       show1, show2, show3, show4;

    SSDecHandler0 ss_handler (
        .clk(clk), .rst(rst),
        .val1(dis_val1), .val2(dis_val2), .val3(dis_val3), .val4(dis_val4),
        .dot1(dis_dot1), .dot2(dis_dot2), .dot3(dis_dot3), .dot4(dis_dot4),
        .show1(show1), .show2(show2), .show3(show3), .show4(show4),
        .digit(digit), .display(display), .dp(dp)
    );

    always_comb begin
        dis_val1 = U_cnt;
        dis_val2 = D_cnt;
        dis_val3 = L_cnt;
        dis_val4 = R_cnt;

        dis_dot1 = 1'b0;
        dis_dot2 = 1'b0;
        dis_dot3 = 1'b0;
        dis_dot4 = 1'b0;

        show1 = 1'b1;
        show2 = 1'b1;
        show3 = 1'b1;
        show4 = 1'b1;
    end

endmodule