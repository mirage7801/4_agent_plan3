module counter(input logic clk, rst, enable, output logic [7:0] count);
    // Simulation has non-overlapping enables; synthesis sees two physical drivers.
    always @(posedge clk) begin
        if (rst) count <= 8'h00;
    end
    always @(posedge clk) begin
        if (!rst && enable) count <= count + 8'd1;
    end
endmodule
