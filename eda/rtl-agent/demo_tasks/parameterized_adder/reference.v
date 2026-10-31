// Extend both operands so the carry-out is part of the exact result.
module parameterized_adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] sum,
    output logic             carry
);
    assign {carry, sum} = {1'b0, a} + {1'b0, b};
endmodule
