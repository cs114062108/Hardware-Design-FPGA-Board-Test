module SampleDisplay(
	output logic [6:0] display,
	output logic [3:0] digit,
	inout  logic PS2_DATA,
	inout  logic PS2_CLK,
	input  logic rst,
	input  logic clk,
	input  logic single_enable,
	input  logic lock_enable,
	output logic [15:0] LED
);
	
	parameter [8:0] LEFT_SHIFT_CODES  = 9'h012; // 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'h059; // 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:19] = '{
		9'h045, 9'h016, 9'h01E, 9'h026, 9'h025, 9'h02E, 9'h036, 9'h03D, 9'h03E, 9'h046, // 0 ~ 9
		9'h070, 9'h069, 9'h072, 9'h07A, 9'h06B, 9'h073, 9'h074, 9'h06C, 9'h075, 9'h07D // right_0 ~ right_9

		// 9'b0_0100_0101,	// 0 => 45
		// 9'b0_0001_0110,	// 1 => 16
		// 9'b0_0001_1110,	// 2 => 1E
		// 9'b0_0010_0110,	// 3 => 26
		// 9'b0_0010_0101,	// 4 => 25
		// 9'b0_0010_1110,	// 5 => 2E
		// 9'b0_0011_0110,	// 6 => 36
		// 9'b0_0011_1101,	// 7 => 3D
		// 9'b0_0011_1110,	// 8 => 3E
		// 9'b0_0100_0110,	// 9 => 46
		
		// 9'b0_0111_0000, // right_0 => 70
		// 9'b0_0110_1001, // right_1 => 69
		// 9'b0_0111_0010, // right_2 => 72
		// 9'b0_0111_1010, // right_3 => 7A
		// 9'b0_0110_1011, // right_4 => 6B
		// 9'b0_0111_0011, // right_5 => 73
		// 9'b0_0111_0100, // right_6 => 74
		// 9'b0_0110_1100, // right_7 => 6C
		// 9'b0_0111_0101, // right_8 => 75
		// 9'b0_0111_1101  // right_9 => 7D
	};
	
	logic [15:0] nums;
	logic [3:0] key_num;
	logic [9:0] last_key;
	
	logic shift_down;
	logic [511:0] key_down;
	logic [8:0] last_change;
	logic key_valid;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] || key_down[RIGHT_SHIFT_CODES]);

	logic init_done;
	
	SevenSegment seven_seg (
		.display(display),
		.digit(digit),
		.nums(nums),
		.rst(rst_op),
		.clk(clk)
	);
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(key_valid),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst_op),
		.clk(clk),
		.init_done(init_done)
	);

	// Single Register
	logic new_press;

	SingleRegister single_click(
		.clk(clk), .rst(rst_op),
		.enable(single_enable),
		.key_down(key_down), .last_change(last_change),
		.new_press(new_press)
	);

	logic accept;   // one-cycle pulse: a press that should be registered
	assign accept = (key_num != 4'b1111) && new_press;

	always_comb begin
		if (rst) begin
			LED = 16'hFFFF;
		end else begin
			LED[15] = single_enable;
			LED[14] = lock_enable;
			
			LED[13:8] = 6'd0;

			LED[11] = new_press;

			LED[7:0] = init_done ? 8'd0 : 8'hFF;
		end
	end

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			nums <= 16'b0;
		end else begin
			nums <= nums;
			if (key_valid && key_down[last_change]) begin
				if (accept) begin
					if (shift_down) begin
						nums <= {key_num, nums[15:4]};
					end else begin
						nums <= {nums[11:0], key_num};
					end
				end
			end
		end
	end
	
	always_comb begin
		// key_num = 4'b1111;
		// for (int i = 0; i < 20; i++) begin
		//     if (last_change == KEY_CODES[i]) key_num = i % 5'd10;
		// end

		case (last_change)
			KEY_CODES[00] : key_num = 4'd0;
			KEY_CODES[01] : key_num = 4'd1;
			KEY_CODES[02] : key_num = 4'd2;
			KEY_CODES[03] : key_num = 4'd3;
			KEY_CODES[04] : key_num = 4'd4;
			KEY_CODES[05] : key_num = 4'd5;
			KEY_CODES[06] : key_num = 4'd6;
			KEY_CODES[07] : key_num = 4'd7;
			KEY_CODES[08] : key_num = 4'd8;
			KEY_CODES[09] : key_num = 4'd9;
			KEY_CODES[10] : key_num = 4'd0;
			KEY_CODES[11] : key_num = 4'd1;
			KEY_CODES[12] : key_num = 4'd2;
			KEY_CODES[13] : key_num = 4'd3;
			KEY_CODES[14] : key_num = 4'd4;
			KEY_CODES[15] : key_num = 4'd5;
			KEY_CODES[16] : key_num = 4'd6;
			KEY_CODES[17] : key_num = 4'd7;
			KEY_CODES[18] : key_num = 4'd8;
			KEY_CODES[19] : key_num = 4'd9;
			default		  : key_num = 4'b1111;
		endcase
	end
endmodule
