`timescale 1ns/1ps
module tb_edge_detector;
    logic clk=0,rst=0,signal_in=0;
    wire pulse;
    bit previous=0,expected=0;
    integer cycle=0;
    edge_detector dut(.*);
    always #2.5 clk=~clk;
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs rst=%b signal=%b expected=%b actual=%b",cycle,rst,signal_in,expected,pulse); end
    task automatic step(input bit r,input bit s);
        @(negedge clk); rst=r; signal_in=s;
        expected=!r && s && !previous; previous=r?0:s;
        @(posedge clk); #0.1; cycle++;
        if(pulse !== expected) $fatal(1,"TEST_FAIL cycle=%0d inputs rst=%b signal=%b expected=%b actual=%b",cycle,rst,signal_in,expected,pulse);
    endtask
    initial begin step(1,0); repeat(3) step(0,0); repeat(4) step(0,1); step(0,0); step(0,1); step(1,1); step(0,1); repeat(2) step(0,1); $display("TEST_PASS edge_detector cycles=%0d",cycle); $finish; end
endmodule
