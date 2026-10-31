// Four prefix states detect overlapping instances of the sequence 1011.
module sequence_detector (
    input  logic clk,
    input  logic rst,
    input  logic bit_in,
    output logic detected
);
    typedef enum logic [1:0] {
        IDLE,
        SEEN_1,
        SEEN_10,
        SEEN_101
    } state_t;

    state_t state;

    always_ff @(posedge clk) begin
        if (rst) begin
            state    <= IDLE;
            detected <= 1'b0;
        end else begin
            detected <= 1'b0;

            case (state)
                IDLE:     state <= bit_in ? SEEN_1   : IDLE;
                SEEN_1:   state <= bit_in ? SEEN_1   : SEEN_10;
                SEEN_10:  state <= bit_in ? SEEN_101 : IDLE;
                SEEN_101: begin
                    if (bit_in) begin
                        detected <= 1'b1;
                        state    <= SEEN_1;
                    end else begin
                        state <= SEEN_10;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
