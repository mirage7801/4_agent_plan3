module TopModule(input clk,resetn,input [2:0] r,output [2:0] g);
reg [1:0] state,next;
always @* begin
next=state;
case(state)
0: if(r[0])next=1;else if(r[1])next=2;else if(r[2])next=3;
1: if(!r[0])next=0;
2: if(!r[1])next=0;
3: if(!r[2])next=0;
endcase
end
always @(posedge clk) if(!resetn)state<=0;else state<=next;
assign g={(state==3),(state==2),(state==1)};
endmodule
