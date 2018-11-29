`timescale 1ns / 1ps

module breg_tb(
    );

    parameter TCQ = 10;

    reg reset;
    reg en;
    reg [7:0] d;
    wire [7:0] q;

    breg uut (
        .reset(reset),
        .en(en),
        .d(d),
        .q(q)
    );

    initial begin
        reset = 1'b1;
        en = 1'b0;
        d = 8'b0;
        #TCQ
            reset = 1'b0;
        #TCQ
            d = 8'ha5;
            en = 1'b1;
        #TCQ
            ;
    end

endmodule
