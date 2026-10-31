`timescale 1ns/1ps
module tb_enable_counter;
    localparam WIDTH=4;
    logic clk=0,rst=0,enable=0;
    wire [WIDTH-1:0] count;
    wire tick;
    logic [WIDTH-1:0] expected=0;
    logic expected_tick=0;
    integer cycle=0;
    enable_counter #(.WIDTH(WIDTH)) dut(.*);
    always #2.5 clk=~clk;
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs rst=%b enable=%b expected=%h/%b actual=%h/%b",cycle,rst,enable,expected,expected_tick,count,tick); end
    task automatic step(input bit r,input bit e);
        @(negedge clk); rst=r; enable=e;
        expected_tick = !r && e && (&expected);
        if(r) expected=0; else if(e) expected=expected+1'b1;
        @(posedge clk); #0.1; cycle++;
        if(count !== expected || tick !== expected_tick) $fatal(1,"TEST_FAIL cycle=%0d inputs rst=%b enable=%b expected=%h/%b actual=%h/%b",cycle,rst,enable,expected,expected_tick,count,tick);
    endtask
    initial begin step(1,0); repeat(20) step(0,1); repeat(3) step(0,0); step(1,1); repeat(16) step(0,1); $display("TEST_PASS enable_counter cycles=%0d",cycle); $finish; end
endmodule
