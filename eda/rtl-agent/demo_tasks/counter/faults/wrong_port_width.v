module counter(input logic clk, rst, enable, output logic [6:0] count);
    always_ff @(posedge clk) begin
        if (rst) count <= 7'h00;
        else if (enable) count <= count + 7'd1;
    end
endmodule
