// Single-clock, 8-entry FIFO with registered read data.
module synchronous_fifo (
    input  logic       clk,
    input  logic       rst,
    input  logic       write_enable,
    input  logic       read_enable,
    input  logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic       full,
    output logic       empty
);
    logic [7:0] mem [0:7];
    logic [2:0] write_ptr, read_ptr;
    logic [3:0] occupancy;
    logic       do_read, do_write;

    assign full     = (occupancy == 4'd8);
    assign empty    = (occupancy == 4'd0);
    assign do_read  = read_enable && !empty;
    assign do_write = write_enable && (!full || do_read);

    always_ff @(posedge clk) begin
        if (rst) begin
            write_ptr <= 3'd0;
            read_ptr  <= 3'd0;
            occupancy <= 4'd0;
            data_out  <= 8'd0;
        end else begin
            if (do_write) begin
                mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1'b1;
            end

            if (do_read) begin
                // A simultaneous write does not bypass the old head value.
                data_out <= mem[read_ptr];
                read_ptr <= read_ptr + 1'b1;
            end

            if (do_write && !do_read) begin
                occupancy <= occupancy + 1'b1;
            end else if (do_read && !do_write) begin
                occupancy <= occupancy - 1'b1;
            end
        end
    end
endmodule
