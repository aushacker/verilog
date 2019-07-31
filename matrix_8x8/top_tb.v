`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Aushacker
// 
// Create Date:    31.07.2019 10:43:29
// Design Name: 
// Module Name:    top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:     Top level testbench.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();

    parameter PERIOD = 10;
     
    reg clk;
    wire [4:0] bcount;
    wire [3:0] a;
    wire cs_n;
    wire d;

    always begin
        clk = 1'b1;
        #(PERIOD/2) clk = ~clk;
        #(PERIOD/2);
    end

    top dut(.clk(clk), .bcount(bcount), .a(a), .cs_n(cs_n), .d(d));

endmodule
