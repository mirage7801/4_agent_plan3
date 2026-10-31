module TopModule(input clk,reset,w,output z);
reg [2:0] state,next;
always @* case(state)
0:next=w?0:1;
1:next=w?3:2;
2:next=w?3:4;
3:next=w?0:5;
4:next=w?3:4;
5:next=w?3:2;
default:next=0;
endcase
always @(posedge clk) if(reset)state<=0;else state<=next;
assign z=(state==4)||(state==5);
endmodule
