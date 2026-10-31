`timescale 1ns/1ps
module tb_arbiter;
    logic [3:0] request=0;
    wire [3:0] grant;
    logic [3:0] expected;
    integer cycle=0,i,j;
    bit found;
    arbiter dut(.*);
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs request=%b expected=%b actual=%b",cycle,request,expected,grant); end
    initial begin
        for(i=0;i<16;i=i+1) begin
            request=i[3:0];expected=0;found=0;
            for(j=0;j<4;j=j+1) if(request[j] && !found) begin expected[j]=1;found=1;end
            #1;cycle++;
            if(grant !== expected) $fatal(1,"TEST_FAIL cycle=%0d inputs request=%b expected=%b actual=%b",cycle,request,expected,grant);
        end
        $display("TEST_PASS arbiter cycles=%0d",cycle);$finish;
    end
endmodule
