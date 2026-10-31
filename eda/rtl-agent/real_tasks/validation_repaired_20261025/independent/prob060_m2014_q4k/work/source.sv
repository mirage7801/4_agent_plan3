module TopModule(input clk,resetn,in,output out);
reg [3:0] q;
always @(posedge clk) if(!resetn)q<=0;else q<={q[2:0],in};
assign out=q[3];
endmodule
