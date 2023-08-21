`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     none
// Engineer:    aushacker
// 
// Create Date: 19.07.2023 17:11:07
// Design Name: i8255
// Module Name: i8255_top
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

module i8255_top(
    input clk,
    input reset,    // positive logic
    input rd,       // positive logic
    input wr,       // positive logic
    input cs,       // positive logic
    input [1:0] a,
    inout [7:0] d, 
    inout [7:0] pa,
    inout [7:0] pb,
    inout [7:0] pc
    );

    wire oe;
    wire [7:0] din, dout;
    wire ddra, ddrb;
    wire [7:0] ddrc;
    wire [7:0] ain, aout, bin, bout, cin, cout;

    i8255 i8255 (
        .clk(clk),
        .reset(reset),
        .cs(cs),
        .rd(rd),
        .wr(wr),
        .a(a),
        .din(din),
        .dout(dout),
        .ddra(ddra),
        .ddrb(ddrb),
        .ddrc(ddrc),
        .ain(ain),
        .aout(aout),
        .bin(bin),
        .bout(bout),
        .cin(cin),
        .cout(cout)
    );

    // tri-state control for d (data)
    assign oe = cs && rd && !wr;

    // bidirectional ports
    assign din = d;
    assign d = oe ? dout : 8'bZZZZZZZZ;
    assign ain = pa;
    assign pa = ddra ? aout : 8'bZZZZZZZZ;
    assign bin = pb;
    assign pb = ddrb ? bout : 8'bZZZZZZZZ;
    assign cin = pc;

    genvar i;
    for (i = 7; i >= 0; i=i-1) begin
        assign pc[i] = ddrc[i] ? cout[i] : 1'bZ;
    end

endmodule
