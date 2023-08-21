`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     none
// Engineer:    aushacker
// 
// Create Date: 19.07.2023 17:11:07
// Design Name: i8255
// Module Name: i8255_top_tb
// Project Name: 
// Target Devices: Artix 7
// Tool Versions: Vivado 2023.1
// Description: Implements the Intel 8255.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - Mode 0 implemented
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module i8255_top_tb( );

    parameter PERIOD = 20;  // 50 MHz

    logic clk;
    logic reset = '0;
    logic rd = '0;
    logic wr = '0;
    logic cs = '0;
    logic [1:0] a = 2'b0;
    logic [7:0] d = 8'b0;
    wire [7:0] dbidir;
    wire [7:0] pa;
    wire [7:0] pb;
    wire [7:0] pc;
    
    always begin
        clk = 1'b1;
        #(PERIOD/2) clk = 1'b0;
        #(PERIOD/2);
    end

    i8255_top uut (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .rd(rd),
        .wr(wr),
        .a(a),
        .d(dbidir),
        .pa(pa),
        .pb(pb),
        .pc(pc)
    );

    assign dbidir = d;

    initial begin
        #(PERIOD) reset = '1;
        #(PERIOD * 4) reset = '0;

        //
        // Mode 0 configuration tests
        //
        
        // Mode 0 - control word #0 - all outputs (A, B & C)
        #(PERIOD/2); // ensure transitions are on the falling edge of clk
        a = 2'b11;
        d = 8'b10000000;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #1 - A, B & CH as outputs, CL as input
        #PERIOD;
        d = 8'b10000001;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #2 - A, CH & CL as outputs, B as input
        #PERIOD;
        d = 8'b10000010;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #3 - A & CH as outputs, B & CL as inputs
        #PERIOD;
        d = 8'b10000011;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #4 - A, B & CL as outputs, CH as input
        #PERIOD;
        d = 8'b10001000;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #5 - A, B as outputs, C as input
        #PERIOD;
        d = 8'b10001001;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #6 - A & CL as outputs, B & CH as inputs
        #PERIOD;
        d = 8'b10001010;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #7 - A as output, B & C as inputs
        #PERIOD;
        d = 8'b10001011;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #8 - B & C as outputs, A as input
        #PERIOD;
        d = 8'b10010000;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #9 - B & CH as outputs, A & CL as inputs
        #PERIOD;
        d = 8'b10010001;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #10 - B & CL as outputs, A & CH as inputs
        #PERIOD;
        d = 8'b10010010;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #11 - B as output, A & C as inputs
        #PERIOD;
        d = 8'b10010011;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #12 - B & CL as outputs, A & CH as inputs
        #PERIOD;
        d = 8'b10011000;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #13 - B as output, A & C as inputs
        #PERIOD;
        d = 8'b10011001;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #14 - CL as output, A, B & CH as inputs
        #PERIOD;
        d = 8'b10011010;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - control word #15 - A, B & C as inputs
        #PERIOD;
        d = 8'b10011011;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Mode 0 - write tests
        #PERIOD;
        d = 8'b10000000; // all outputs
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // PA = 0xA5
        #PERIOD;
        a = 2'b00;
        d = 8'ha5;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // PB = 0x5A
        #PERIOD;
        a = 2'b01;
        d = 8'h5a;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // PC = 0x96
        #PERIOD;
        a = 2'b10;
        d = 8'h96;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

        // Reset PC[7] using bit reset command, PC = 0x16
        #PERIOD;
        a = 2'b11;
        d = 8'h0e;
        cs = '1;
        wr = '1;

        #PERIOD cs = '0;
        wr = '0;

    end

endmodule
