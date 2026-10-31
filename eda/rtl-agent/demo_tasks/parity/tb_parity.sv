`timescale 1ns/1ps
module tb_parity;
    logic [7:0] data_in=0;
    logic parity_in=0;
    wire parity_bit,error;
    bit expected_bit,expected_error;
    integer cycle=0,i,p;
    parity dut(.*);
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs data=%h parity_in=%b expected=%b/%b actual=%b/%b",cycle,data_in,parity_in,expected_bit,expected_error,parity_bit,error); end
    initial begin
        for(i=0;i<256;i=i+1) for(p=0;p<2;p=p+1) begin
            data_in=i[7:0]; parity_in=p[0]; expected_bit=^data_in; expected_error=expected_bit^parity_in;
            #1; cycle++;
            if(parity_bit !== expected_bit || error !== expected_error) $fatal(1,"TEST_FAIL cycle=%0d inputs data=%h parity_in=%b expected=%b/%b actual=%b/%b",cycle,data_in,parity_in,expected_bit,expected_error,parity_bit,error);
        end
        $display("TEST_PASS parity cycles=%0d",cycle);$finish;
    end
endmodule
