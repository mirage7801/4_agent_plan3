`timescale 1ns/1ps
module tb_parameterized_adder;
    localparam WIDTH=5;
    logic [WIDTH-1:0] a=0,b=0;
    wire [WIDTH-1:0] sum;
    wire carry;
    logic [WIDTH:0] expected;
    integer cycle=0,i,j;
    parameterized_adder #(.WIDTH(WIDTH)) dut(.*);
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs a=%h b=%h expected=%h actual=%b_%h",cycle,a,b,expected,carry,sum); end
    initial begin
        for(i=0;i<32;i=i+1) for(j=0;j<32;j=j+1) begin
            a=i[WIDTH-1:0];b=j[WIDTH-1:0];expected={1'b0,a}+{1'b0,b};#1;cycle++;
            if({carry,sum} !== expected) $fatal(1,"TEST_FAIL cycle=%0d inputs a=%h b=%h expected=%h actual=%b_%h",cycle,a,b,expected,carry,sum);
        end
        $display("TEST_PASS parameterized_adder cycles=%0d",cycle);$finish;
    end
endmodule
