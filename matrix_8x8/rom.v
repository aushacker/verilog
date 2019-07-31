`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Aushacker
// 
// Create Date:    31.07.2019 11:23:29
// Design Name: 
// Module Name:    rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:    Various commands for MAX7219 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom(
    input [3:0] a,
    output reg [15:0] d
    );

    always @(a) begin
        case (a)
            4'b0001: d = 16'h09FF;
            4'b0010: d = 16'h0A0F;
            4'b0011: d = 16'h0B07;
            4'b0100: d = 16'h0F00;
            4'b0101: d = 16'h0101;
            4'b0110: d = 16'h0202;
            4'b0111: d = 16'h0303;
            4'b1000: d = 16'h0404;
            4'b1001: d = 16'h0505;
            4'b1010: d = 16'h0606;
            4'b1011: d = 16'h0707;
            4'b1100: d = 16'h0808;
            default: d = 16'h0C01;
        endcase
    end
    
endmodule
