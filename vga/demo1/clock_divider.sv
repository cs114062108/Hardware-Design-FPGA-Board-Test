module clock_divider(clk1, clk);
  input clk;
  output clk1;

  logic [1:0] num;
  logic [1:0] next_num;

  always_ff @(posedge clk) begin
    num <= next_num;
  end

  assign next_num = num + 1'b1;
  assign clk1 = num[1];

endmodule
