// 8-bit enabled counter with a synchronous, active-high reset.
module counter (
    input  logic       clk,
    input  logic       rst,
    input  logic       enable,
    output logic [7:0] count
);
    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (enable) begin
            count <= count + 8'd1;
        end
    end
endmodule
