module TopModule(input clk,reset,output [2:0] ena,output reg [15:0] q);
assign ena[0]=(q[3:0]==9);
assign ena[1]=(q[7:0]==8'h99);
assign ena[2]=(q[11:0]==12'h999);
integer j;
always @(posedge clk) begin
if(reset)q<=0;
else begin
q[3:0]<=q[3:0]==9?4'd0:q[3:0]+4'd1;
for(j=1;j<4;j=j+1)if(ena[j-1])q[j*4+:4]<=q[j*4+:4]==9?4'd0:q[j*4+:4]+4'd1;
end
end
endmodule
