module TopModule(input clk,in,reset,output [7:0] out_byte,output done);
localparam IDLE=0,DATA=1,STOP=2,GOOD=3,RECOVER=4;
reg [2:0] state;
reg [2:0] bitno;
reg [7:0] saved;
always @(posedge clk) begin
 if(reset) begin state<=IDLE;bitno<=0;end
 else case(state)
 IDLE: if(!in) begin state<=DATA;bitno<=0;end
 DATA: begin saved[bitno]<=in; if(bitno==7)state<=STOP;else bitno<=bitno+1'b1;end
 STOP: if(in)state<=GOOD;else state<=RECOVER;
 GOOD: if(!in)begin state<=DATA;bitno<=0;end else state<=IDLE;
 RECOVER: if(in)state<=IDLE;
 default:state<=IDLE;
 endcase
end
assign out_byte=saved;
assign done=state==GOOD;
endmodule
