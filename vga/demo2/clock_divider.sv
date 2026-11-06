module clock_divider(clk1, clk, clk22);
  input clk;
  output clk1;
  output clk22;
  logic [21:0] num;
  logic [21:0] next_num;

  always_ff @(posedge clk) begin
    num <= next_num;
  end

  assign next_num = num + 1'b1;
  assign clk1 = num[1];
  assign clk22 = num[21];

endmodule
