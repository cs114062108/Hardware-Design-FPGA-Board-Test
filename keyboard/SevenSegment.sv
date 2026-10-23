module SevenSegment(
	input  logic rst,
	input  logic clk,
	input  logic [15:0] nums,
	input  logic [3:0] dots,
	output logic [3:0] digit,
	output logic [6:0] display,
	output logic dp
);
    
    logic [15:0] clk_divider;
    logic [3:0]  display_num;
	logic        display_dot;
    
    always_ff @(posedge clk or posedge rst) begin
    	if (rst) begin
    		clk_divider <= 16'd0;
    	end else begin
    		clk_divider <= clk_divider + 16'd1;
    	end
    end
    
    always_ff @(posedge clk_divider[15] or posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
			display_dot <= 1'b0;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
					display_num <= nums[7:4];
					display_dot <= dots[1];
					digit <= 4'b1101;
    			end
    			4'b1101 : begin
					display_num <= nums[11:8];
					display_dot <= dots[2];
					digit <= 4'b1011;
				end
    			4'b1011 : begin
					display_num <= nums[15:12];
					display_dot <= dots[3];
					digit <= 4'b0111;
				end
    			4'b0111 : begin
					display_num <= nums[3:0];
					display_dot <= dots[0];
					digit <= 4'b1110;
				end
    			default : begin
					display_num <= nums[3:0];
					display_dot <= dots[0];
					digit <= 4'b1110;
				end				
    		endcase
    	end
    end
    
    always_comb begin
    	case (display_num)
    		4'd0: display = 7'b1000000;
            4'd1: display = 7'b1111001;
            4'd2: display = 7'b0100100;
            4'd3: display = 7'b0110000;
            4'd4: display = 7'b0011001;
            4'd5: display = 7'b0010010;
            4'd6: display = 7'b0000010;
            4'd7: display = 7'b1111000;
            4'd8: display = 7'b0000000;
            4'd9: display = 7'b0010000;
			default : display = 7'b1111111;
    	endcase

		dp = ~display_dot;
    end

endmodule
