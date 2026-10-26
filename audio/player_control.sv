module player_control (
	input logic clk, 
	input logic reset, 
	input logic _play, 
	input logic _slow, 
	input logic _mode, 
	output logic [11:0] ibeat
);
	
	parameter logic [11:0] LEN = 12'd4095;
    logic [11:0] next_ibeat;

	// 60 BPM, 1 beat = 1 sec
	logic beat60_timer;	// 1/16 beat = 1/16 sec (100_000_000 / 16 = 6_250_000)
	timer #(.COUNT(6_250_000)) beat_60(.clk(clk), .rst(reset), .enable(1'b1), .tick(beat60_timer));

	logic beat_timer;
	assign beat_timer = beat60_timer;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			ibeat <= 12'd0;
		end else if (beat_timer) begin
            ibeat <= next_ibeat;
		end
	end

    always_comb begin
        next_ibeat = (ibeat + 12'd1 < LEN) ? (ibeat + 12'd1) : 12'd1;
    end

endmodule
