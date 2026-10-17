`timescale 1ns/1ps

module SSDec_tb0;
    
    // Inputs
    logic clk;
    logic rst;
    logic [3:0] val1;
    logic [3:0] val2;
    logic [3:0] val3;
    logic [3:0] val4;
    logic dot1;
    logic dot2;
    logic dot3;
    logic dot4;

    // Outputs
    logic [3:0] digit;
    logic [6:0] display;
    logic dp;

    // ---------------
    // Testcases
    // ---------------
    logic [3:0] val1s [2:0];
    logic [3:0] val2s [2:0];
    logic [3:0] val3s [2:0];
    logic [3:0] val4s [2:0];
    logic dot1s       [2:0];
    logic dot2s       [2:0];
    logic dot3s       [2:0];
    logic dot4s       [2:0];

    int unsigned test_index;
    int test_cnt = 3;
    int wait_clk = 4;

    // ------------------------------------
    // Instantiate the design under test
    // ------------------------------------
    SSDecHandler0 #(.n(1)) dut(
        .clk(clk), .rst(rst),
        .val1(val1), .val2(val2), .val3(val3), .val4(val4),
        .dot1(dot1), .dot2(dot2), .dot3(dot3), .dot4(dot4),
        .digit(digit), .display(display), .dp(dp)
    );

    // Dump for GTKwave
    initial begin
        $dumpfile("waves/ss_dec0.vcd");
        $dumpvars(0, SSDec_tb0);
    end

    // Starting high places falling edges at 5, 15, 25, ... ns and rising
    // edges at 10, 20, 30, ... ns.
    initial begin
        clk = 1'b1;
        forever #5ns clk = ~clk;
    end

    // Resets
    initial begin
        rst = 1'b1;
        #2ns rst = 1'b0; // At 2 ns
    end

    // ---------------------
    // Testcases
    // ---------------------
    initial begin
        // 1. 2  3. 4
        val1s[0] = 4'd1;
        val2s[0] = 4'd2;
        val3s[0] = 4'd3;
        val4s[0] = 4'd4;

        dot1s[0] = 1'b1;
        dot2s[0] = 1'b0;
        dot3s[0] = 1'b1;
        dot4s[0] = 1'b1;

        // 5  6. 7  8.
        val1s[1] = 4'd5;
        val2s[1] = 4'd6;
        val3s[1] = 4'd7;
        val4s[1] = 4'd8;

        dot1s[1] = 1'b0;
        dot2s[1] = 1'b1;
        dot3s[1] = 1'b0;
        dot4s[1] = 1'b1;

        // 9. 10 11 12.
        val1s[2] = 4'd9;
        val2s[2] = 4'd10;
        val3s[2] = 4'd11;
        val4s[2] = 4'd12;

        dot1s[2] = 1'b1;
        dot2s[2] = 1'b0;
        dot3s[2] = 1'b0;
        dot4s[2] = 1'b1;
    end

    initial begin
        #15;
        for (test_index = 0; test_index < test_cnt; test_index++) begin
            val1 = val1s[test_index];
            val2 = val2s[test_index];
            val3 = val3s[test_index];
            val4 = val4s[test_index];

            dot1 = dot1s[test_index];
            dot2 = dot2s[test_index];
            dot3 = dot3s[test_index];
            dot4 = dot4s[test_index];

            @(posedge clk);

            if (test_index < test_cnt-1) begin
                @(negedge clk);
                for (int i = 0; i < wait_clk; i++) begin
                    @(negedge clk);
                    @(negedge clk);
                    @(negedge clk);
                    @(negedge clk);
                end
            end
        end

        $display("-------------------------------------------------------");

        @(negedge clk);
        for (int i = 0; i < wait_clk; i++) begin
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
        end
        #20;
        $finish;
    end

endmodule
