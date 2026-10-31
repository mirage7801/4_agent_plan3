module TopModule(input clk,load,input [9:0] data,output tc);
reg [9:0] count;
always @(posedge clk) if(load) count<=data; else if(count!=0) count<=count-10'd1;
assign tc=(count==0);
endmodule
