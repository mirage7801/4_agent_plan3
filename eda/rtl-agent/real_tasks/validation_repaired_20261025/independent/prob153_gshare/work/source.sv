module TopModule(input clk,areset,predict_valid,input [6:0] predict_pc,
 output predict_taken,output reg [6:0] predict_history,
 input train_valid,train_taken,train_mispredicted,input [6:0] train_history,train_pc);
reg [1:0] pht[0:127];
wire [6:0] pi=predict_pc^predict_history;
wire [6:0] ti=train_pc^train_history;
assign predict_taken=pht[pi][1];
integer i;
always @(posedge clk or posedge areset) begin
 if(areset) begin
 predict_history<=0;
 for(i=0;i<128;i=i+1)pht[i]<=2'b01;
 end else begin
 if(train_valid) begin
 if(train_taken) begin if(pht[ti]!=3)pht[ti]<=pht[ti]+2'd1;end
 else begin if(pht[ti]!=0)pht[ti]<=pht[ti]-2'd1;end
 end
 if(train_valid && train_mispredicted)predict_history<={train_history[5:0],train_taken};
 else if(predict_valid)predict_history<={predict_history[5:0],predict_taken};
 end
end
endmodule
