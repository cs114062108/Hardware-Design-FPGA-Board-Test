module pixel_gen(
    input  logic [9:0] h_cnt,
    input  logic valid,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

    logic [11:0] vgaRGB;

    assign vgaRed   = vgaRGB[11:8];
    assign vgaGreen = vgaRGB[7:4];
    assign vgaBlue  = vgaRGB[3:0];

    always_comb begin
        if (!valid) begin
            vgaRGB = 12'h0;
        end else if (h_cnt < 128) begin
            vgaRGB = 12'h000;
        end else if (h_cnt < 256) begin
            vgaRGB = 12'h00f;
        end else if (h_cnt < 384) begin
            vgaRGB = 12'hf00;
        end else if (h_cnt < 512) begin
            vgaRGB = 12'h0f0;
        end else if (h_cnt < 640) begin
            vgaRGB = 12'hfff;
        end else begin
            vgaRGB = 12'h0;
        end
    end

endmodule
