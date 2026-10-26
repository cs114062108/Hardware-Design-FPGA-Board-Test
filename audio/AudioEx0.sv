module AudioEx0 (
    input  logic clk,
    input  logic rst,
    output logic audio_mclk,
    output logic audio_lrck,
    output logic audio_sck,
    output logic audio_sdin
);

    logic rst_op;
	one_pulse r_op (
		.pb_out(rst_op),
		.pb_in(rst),
		.clk(clk)
	);

    // ---------------------------------------------------------------------
    // Frequency Handle
    // ---------------------------------------------------------------------
    logic [11:0] ibeatNum;
    logic [21:0] freq_div;

    player_control pc(
        .clk(clk), .reset(rst_op), 
        ._play(1'b0), ._slow(1'b0), ._mode(1'b0), 
        .ibeat(ibeatNum)
    );

    logic [31:0] toneL, toneR;

    music_example mus_ex(
        .ibeatNum(ibeatNum),
        .en(1'b1),
        .toneL(toneL), .toneR(toneR)
    );

    function automatic logic [21:0] calc_freq(input logic [31:0] tone);
        calc_freq = 32'd50_000_000 / tone;
    endfunction

    logic [21:0] freq_div_left, freq_div_right;

    always_comb begin
        freq_div_left = calc_freq(toneL);
        freq_div_right = calc_freq(toneR);
    end

    // ---------------------------------------------------------------------
    // Audio Generate
    // ---------------------------------------------------------------------
    logic signed [15:0] audio_raw_left, audio_raw_right;

    note_gen ng (
        .clk(clk), .rst(rst_op),
        .volume(3'd0),   // unused inside note_gen, harmless to tie off
        .note_div_left(freq_div_left), .note_div_right(freq_div_right),
        .audio_left(audio_raw_left), .audio_right(audio_raw_right)
    );

    logic signed [15:0] audio_out_left, audio_out_right;

    always_comb begin
        audio_out_left = audio_raw_left;
        audio_out_right = audio_raw_right;
    end

    speaker_control sc (
        .clk(clk), .rst(rst_op),
        .audio_in_left(audio_out_left), .audio_in_right(audio_out_right),
        .audio_mclk(audio_mclk), .audio_lrck(audio_lrck),
        .audio_sck(audio_sck), .audio_sdin(audio_sdin)
    );

endmodule
