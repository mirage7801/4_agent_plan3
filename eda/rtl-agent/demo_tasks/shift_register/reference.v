// Serial input enters bit 0; existing bits shift toward the MSB.
module shift_register #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             enable,
    input  logic             serial_in,
    output logic [WIDTH-1:0] parallel_out
);
    always_ff @(posedge clk) begin
        if (rst) begin
            parallel_out <= '0;
        end else if (enable) begin
            parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
        end
    end
endmodule
