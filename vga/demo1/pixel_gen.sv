module pixel_gen(
     input  logic [9:0] h_cnt,
     input  logic [9:0] v_cnt,
     input  logic valid,
     input  logic mode,
     output logic [3:0] vgaRed,
     output logic [3:0] vgaGreen,
     output logic [3:0] vgaBlue
);
     
     localparam SCREEN_W = 640;
     localparam SCREEN_H = 480;

     // ----------------------------------------------------
     // MODE 1
     // ----------------------------------------------------
     localparam AREA_W = 480;
     localparam AREA_H = 480;
     localparam START_X = (SCREEN_W - AREA_W) / 2;
     localparam START_Y = 0;

     logic [9:0] h_cnt1, v_cnt1;
     assign h_cnt1 = (h_cnt > START_X) ? (h_cnt - START_X) : 9'd0;
     assign v_cnt1 = v_cnt - START_Y;
     
     always_comb begin
          if (valid) begin
               {vgaRed, vgaGreen, vgaBlue} = 12'h000;
               if (mode == 1'b0) begin
                    if (h_cnt < 128) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    end else if (h_cnt < 256) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'h00f;
                    end else if (h_cnt < 384) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                    end else if (h_cnt < 512) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;              
                    end else if (h_cnt < 640) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end else begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                    end
               end else if (mode == 1'b1) begin
                    if (h_cnt < START_X) begin
                         {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    end else begin
                         if (h_cnt1 < 160) begin
                              if (v_cnt1 < 160) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                              end else if (v_cnt1 < 320) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'hFFF;
                              end else begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                              end
                         end else if (h_cnt1 < 320) begin
                              if (v_cnt1 < 160) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'hFFF;
                              end else if (v_cnt1 < 320) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                              end else begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'hFFF;
                              end
                         end else if (h_cnt1 < 480) begin
                              if (v_cnt1 < 160) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                              end else if (v_cnt1 < 320) begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'hFFF;
                              end else begin
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                              end
                         end else begin
                              {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         end
                    end
               end
          end else begin
               {vgaRed, vgaGreen, vgaBlue} = 12'h0;
          end
     end
     
endmodule
