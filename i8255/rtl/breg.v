`timescale 1ns / 1ps

module breg #(parameter INIT = 0) (
    input reset,
    input en,
    input [7:0] d,
    output reg [7:0] q
    );

    always @(*) begin
        if (reset)
            q <= INIT;
        else if (en)
            q <= d;
    end

endmodule
