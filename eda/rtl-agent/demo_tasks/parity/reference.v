// Even parity: the generated bit makes the total number of ones even.
module parity (
    input  logic [7:0] data_in,
    input  logic       parity_in,
    output logic       parity_bit,
    output logic       error
);
    assign parity_bit = ^data_in;
    assign error      = parity_in ^ parity_bit;
endmodule
