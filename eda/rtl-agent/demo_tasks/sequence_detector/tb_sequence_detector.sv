`timescale 1ns/1ps
module tb_sequence_detector;
    logic clk=0,rst=0,bit_in=0;
    wire detected;
    logic [3:0] history=0;
    bit expected=0;
    integer cycle=0,seen=0;
    sequence_detector dut(.*);
    always #2.5 clk=~clk;
    initial begin #10000; $fatal(1,"TB_FAIL kind=simulation_timeout case=watchdog cycle=%0d rst=%b bit=%b expected=%b actual=%b",cycle,rst,bit_in,expected,detected); end
    task automatic step(input bit r,input bit b,input string test_case);
        @(negedge clk); rst=r; bit_in=b;
        if(r) begin history=0; seen=0; expected=0; end
        else begin history={history[2:0],b}; if(seen<4) seen++; expected=(seen>=4 && history==4'b1011); end
        // Drive on negedge and sample after the DUT NBA update.
        @(posedge clk); #0.1; cycle++;
        if (^detected === 1'bx)
            $fatal(1,"TB_FAIL kind=unknown_value case=%0s cycle=%0d rst=%b bit=%b history=%b expected=%b actual=%b",test_case,cycle,rst,bit_in,history,expected,detected);
        if(detected !== expected)
            $fatal(1,"TB_FAIL kind=%0s case=%0s cycle=%0d rst=%b bit=%b history=%b expected=%b actual=%b",r ? "reset_behavior_error" : "functional_mismatch",test_case,cycle,rst,bit_in,history,expected,detected);
    endtask
    initial begin
        step(1,0,"initial_reset");
        step(0,1,"sequence_prefix"); step(0,0,"sequence_prefix"); step(0,1,"sequence_prefix"); step(0,1,"sequence_detect");
        step(0,0,"overlap_prefix"); step(0,1,"overlap_prefix"); step(0,1,"sequence_detect");
        step(0,1,"overlap_prefix"); step(0,0,"overlap_prefix"); step(0,1,"overlap_prefix"); step(0,1,"sequence_detect");
        step(1,1,"runtime_reset"); step(0,0,"sequence_prefix"); step(0,1,"sequence_prefix"); step(0,1,"sequence_prefix");
        $display("TEST_PASS sequence_detector cycles=%0d",cycle); $finish;
    end
endmodule
