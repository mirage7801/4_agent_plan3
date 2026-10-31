`timescale 1ns/1ps
module tb_synchronous_fifo;
    logic clk=0,rst=0,write_enable=0,read_enable=0;
    logic [7:0] data_in=0;
    wire [7:0] data_out;
    wire full,empty;
    logic [7:0] model[0:7];
    logic [7:0] expected_data=0;
    integer head=0,tail=0,items=0,cycle=0,i;
    bit reading,writing;
    synchronous_fifo dut(.*);
    always #2.5 clk=~clk;
    initial begin #10000; $fatal(1,"TEST_FAIL timeout cycle=%0d inputs rst=%b wr=%b rd=%b data=%h expected=%h/%b/%b actual=%h/%b/%b",cycle,rst,write_enable,read_enable,data_in,expected_data,items==8,items==0,data_out,full,empty); end
    task automatic step(input bit r,input bit w,input bit rd,input logic [7:0] value);
        @(negedge clk); rst=r;write_enable=w;read_enable=rd;data_in=value;
        if(r) begin head=0;tail=0;items=0;expected_data=0;end
        else begin
            reading=rd && items>0; writing=w && (items<8 || reading);
            if(reading) begin expected_data=model[head];head=(head+1)%8;end
            if(writing) begin model[tail]=value;tail=(tail+1)%8;end
            if(writing && !reading) items++;else if(reading && !writing) items--;
        end
        @(posedge clk);#0.1;cycle++;
        if(data_out !== expected_data || full !== (items==8) || empty !== (items==0))
            $fatal(1,"TEST_FAIL cycle=%0d inputs rst=%b wr=%b rd=%b data=%h expected=%h/%b/%b actual=%h/%b/%b",cycle,rst,write_enable,read_enable,data_in,expected_data,items==8,items==0,data_out,full,empty);
    endtask
    initial begin
        step(1,0,0,0);step(0,0,1,0);
        for(i=0;i<8;i=i+1) step(0,1,0,i+8'h10);
        step(0,1,0,8'hff);step(0,1,1,8'haa);
        for(i=0;i<7;i=i+1) step(0,1,1,i+8'h20);
        for(i=0;i<8;i=i+1) step(0,0,1,0);
        step(0,0,1,0);step(0,1,1,8'h55);step(0,0,1,0);
        step(0,1,0,8'h33);step(1,1,1,8'h44);
        $display("TEST_PASS synchronous_fifo cycles=%0d",cycle);$finish;
    end
endmodule
