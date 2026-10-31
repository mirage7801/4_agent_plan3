`timescale 1ns/1ps
module tb_priority_encoder;
    logic [7:0] request=0;
    wire [2:0] index;
    wire valid;
    logic [2:0] expected_index;
    bit expected_valid;
    integer cycle=0,i,j;
    priority_encoder dut(.*);
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs request=%h expected=%b/%d actual=%b/%d",cycle,request,expected_valid,expected_index,valid,index); end
    initial begin
        for(i=0;i<256;i=i+1) begin
            request=i[7:0]; expected_index=0;expected_valid=0;
            for(j=0;j<8;j=j+1) if(request[j]) begin expected_index=j[2:0]; expected_valid=1; end
            #1; cycle++;
            if(valid !== expected_valid || index !== expected_index) $fatal(1,"TEST_FAIL cycle=%0d inputs request=%h expected=%b/%d actual=%b/%d",cycle,request,expected_valid,expected_index,valid,index);
        end
        $display("TEST_PASS priority_encoder cycles=%0d",cycle); $finish;
    end
endmodule
