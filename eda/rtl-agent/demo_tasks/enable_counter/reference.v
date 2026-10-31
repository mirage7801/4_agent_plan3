// Parameterized counter; tick marks an enabled wrap on the current edge.
module enable_counter #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             enable,
    output logic [WIDTH-1:0] count,
    output logic             tick
);
    always_ff @(posedge clk) begin
        if (rst) begin
            count <= '0;
            tick  <= 1'b0;
        end else begin
            tick <= enable && (&count);

            if (enable) begin
                count <= count + 1'b1;
            end
        end
    end
endmodule
