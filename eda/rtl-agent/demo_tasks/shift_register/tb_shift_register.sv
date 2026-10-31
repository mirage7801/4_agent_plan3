`timescale 1ns/1ps
module tb_shift_register;
    localparam WIDTH=5;
    logic clk=0,rst=0,enable=0,serial_in=0;
    wire [WIDTH-1:0] parallel_out;
    logic [WIDTH-1:0] expected=0;
    integer cycle=0;
    shift_register #(.WIDTH(WIDTH)) dut(.*);
    always #2.5 clk=~clk;
    initial begin #10000; $fatal(1,"TB_FAIL kind=simulation_timeout case=watchdog cycle=%0d rst=%b enable=%b serial=%b expected=%h actual=%h",cycle,rst,enable,serial_in,expected,parallel_out); end
    task automatic step(input bit r,input bit e,input bit s,input string test_case);
        @(negedge clk); rst=r; enable=e; serial_in=s;
        if(r) expected=0; else if(e) expected=(expected<<1)|s;
        // Drive on negedge and sample after the DUT NBA update.
        @(posedge clk); #0.1; cycle++;
        if (^parallel_out === 1'bx)
            $fatal(1,"TB_FAIL kind=unknown_value case=%0s cycle=%0d rst=%b enable=%b serial=%b expected=%h actual=%h",test_case,cycle,rst,enable,serial_in,expected,parallel_out);
        if(parallel_out !== expected)
            $fatal(1,"TB_FAIL kind=%0s case=%0s cycle=%0d rst=%b enable=%b serial=%b expected=%h actual=%h",r ? "reset_behavior_error" : "functional_mismatch",test_case,cycle,rst,enable,serial_in,expected,parallel_out);
    endtask
    initial begin
        step(1,0,0,"initial_reset"); step(0,1,1,"shift_bit"); step(0,1,0,"shift_bit"); step(0,1,1,"shift_bit");
        repeat(3) step(0,0,1,"hold_disabled"); repeat(6) step(0,1,1,"shift_bit");
        step(1,1,1,"runtime_reset"); step(0,1,1,"shift_bit");
        $display("TEST_PASS shift_register cycles=%0d",cycle); $finish;
    end
endmodule
