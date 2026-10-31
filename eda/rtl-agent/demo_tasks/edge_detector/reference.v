// Register a one-cycle pulse when the sampled input rises.
module edge_detector (
    input  logic clk,
    input  logic rst,
    input  logic signal_in,
    output logic pulse
);
    logic previous;

    always_ff @(posedge clk) begin
        if (rst) begin
            previous <= 1'b0;
            pulse    <= 1'b0;
        end else begin
            previous <= signal_in;
            pulse    <= signal_in & ~previous;
        end
    end
endmodule
