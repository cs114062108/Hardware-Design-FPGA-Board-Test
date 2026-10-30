module demo_1(
    input  logic clk,
    input  logic rst,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic hsync,
    output logic vsync
);

    wire clk_25MHz;
    wire valid;
    wire [9:0] h_cnt; // 640
    wire [9:0] v_cnt; // 480

    clock_divider #(.n(4)) clk_wiz_0_inst(
        .clk(clk), .rst(rst), .enable(1'b1), .clk_div(clk_25MHz)
    );

    pixel_gen pixel_gen_inst(
        .h_cnt(h_cnt),
        .valid(valid),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );

    vga_controller vga_inst(
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );

endmodule
