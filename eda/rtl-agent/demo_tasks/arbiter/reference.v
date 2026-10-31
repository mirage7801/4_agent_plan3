// Fixed priority: bit 0 wins, and at most one grant is asserted.
module arbiter (
    input  logic [3:0] request,
    output logic [3:0] grant
);
    assign grant[0] = request[0];
    assign grant[1] = request[1] & ~request[0];
    assign grant[2] = request[2] & ~(|request[1:0]);
    assign grant[3] = request[3] & ~(|request[2:0]);
endmodule
