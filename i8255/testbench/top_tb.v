`timescale 1ns / 1ps

module top_tb(
);

    parameter TCQ = 10;

    reg reset;
    reg rd_n, wr_n, cs_n;
    reg [1:0] a;
    reg [7:0] d;
    wire [7:0] porta, portb, portc;

    top uut (
        .reset(reset),
        .cs_n(cs_n),
        .rd_n(rd_n),
        .wr_n(wr_n),
        .a(a),
        .d(d),
        .pa(porta),
        .pb(portb),
        .pc(portc)
    );

    initial begin
        reset = 1;
        cs_n = 1; rd_n = 1; wr_n = 1;
        a = 0;
        d = 0;
        #TCQ
            reset = 0;
        // Write mode reg, all ports as outputs
        #(TCQ*2)
            cs_n = 0;
            wr_n = 0;
            a = 3;
            d = 8'h80;
        #TCQ
            cs_n = 1;
            wr_n = 1;
        // Write mode reg, PA and PC(high) as outputs
        #(TCQ*2)
            cs_n = 0;
            wr_n = 0;
            a = 3;
            d = 8'h83;
        #TCQ
            cs_n = 1;
            wr_n = 1;
        // Write PA
        #(TCQ*2)
            cs_n = 0;
            wr_n = 0;
            a = 0;
            d = 8'hff;
        #TCQ
            cs_n = 1;
            wr_n = 1;
    end

endmodule
