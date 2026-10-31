module counter(input logic clk, rst, enable, output logic [7:0] count);
    always_ff @(posedge clk) begin
        if (rst) count <= 8'h00
        else if (enable) count <= count + 8'd1;
    end
endmodule
