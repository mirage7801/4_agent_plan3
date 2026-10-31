module TopModule(input clk,ar,d,output reg q);
always @(posedge clk or posedge ar) if(ar)q<=0;else q<=d;
endmodule
