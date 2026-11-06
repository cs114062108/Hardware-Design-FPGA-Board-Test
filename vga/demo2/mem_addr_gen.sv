module mem_addr_gen(
    input  logic clk,
    input  logic rst,
    input  logic [9:0] h_cnt,
    input  logic [9:0] v_cnt,
    output logic [16:0] pixel_addr
);

    logic [7:0] position;

    assign pixel_addr = ((h_cnt >> 1) + 320 * (v_cnt >> 1) + position * 320) % 76800;  //640*480 --> 320*240

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            position <= 0;
        else if (position < 239)
            position <= position + 1;
        else
            position <= 0;
    end

endmodule