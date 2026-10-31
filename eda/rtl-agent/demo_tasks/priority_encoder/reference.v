// Encode the highest asserted request bit; bit 7 has top priority.
module priority_encoder (
    input  logic [7:0] request,
    output logic [2:0] index,
    output logic       valid
);
    assign valid = |request;

    always_comb begin
        casez (request)
            8'b1???????: index = 3'd7;
            8'b01??????: index = 3'd6;
            8'b001?????: index = 3'd5;
            8'b0001????: index = 3'd4;
            8'b00001???: index = 3'd3;
            8'b000001??: index = 3'd2;
            8'b0000001?: index = 3'd1;
            default:     index = 3'd0;
        endcase
    end
endmodule
