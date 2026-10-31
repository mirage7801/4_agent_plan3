module TopModule(input [2:0] y,input w,output reg Y1);
always @* case(y)
3'd0:Y1=w?1'b0:1'b0;
3'd1:Y1=w?1'b1:1'b1;
3'd2:Y1=w?1'b1:1'b0;
3'd3:Y1=w?1'b0:1'b0;
3'd4:Y1=w?1'b1:1'b0;
3'd5:Y1=w?1'b1:1'b1;
default:Y1=1'b0;
endcase
endmodule
