`timescale 1ns/1ps
module tb_counter;
    logic clk = 0, rst = 0, enable = 0;
    wire [7:0] count;
    integer cycle = 0;
    logic [7:0] expected = 0;
    counter dut(.clk(clk), .rst(rst), .enable(enable), .count(count));
    always #2.5 clk = ~clk;
    initial begin #10000; $fatal(1, "TB_FAIL kind=simulation_timeout case=watchdog cycle=%0d rst=%b enable=%b expected=%h actual=%h", cycle, rst, enable, expected, count); end
    task automatic tick(input bit r, input bit e, input string test_case);
        @(negedge clk); rst = r; enable = e;
        if (r) expected = 0;
        else if (e) expected = expected + 8'd1;
        // Drive on negedge and sample after the DUT NBA update.
        @(posedge clk); #0.1; cycle++;
        if (^count === 1'bx)
            $fatal(1, "TB_FAIL kind=unknown_value case=%0s cycle=%0d rst=%b enable=%b expected=%h actual=%h", test_case, cycle, rst, enable, expected, count);
        if (count !== expected)
            $fatal(1, "TB_FAIL kind=%0s case=%0s cycle=%0d rst=%b enable=%b expected=%h actual=%h",
                   r ? "reset_behavior_error" : "functional_mismatch", test_case, cycle, rst, enable, expected, count);
    endtask
    initial begin
        tick(1, 0, "initial_reset");
        repeat (12) tick(0, 1, "count_increment");
        repeat (4) tick(0, 0, "hold_disabled");
        repeat (3) tick(0, 1, "count_increment");
        tick(1, 1, "runtime_reset");
        repeat (255) tick(0, 1, "count_increment");
        tick(0, 1, "counter_wrap");
        repeat (3) tick(0, 0, "hold_disabled");
        $display("TEST_PASS counter cycles=%0d", cycle);
        $finish;
    end
endmodule
