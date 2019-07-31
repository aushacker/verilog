`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Aushacker
// 
// Create Date:    31.07.2019 10:35:21
// Design Name:    matrix_8x8
// Module Name:    top
// Project Name:   Driver for MAX7219 SPI display
// Target Devices: Artix-7
// Tool Versions:  Vivado 2017.2
// Description:    Implements an SPI output port and hardcoded command ROM.
//                 ROM data is shifted out to SPI in a 16 command loop.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    output [4:0] bcount,
    output [3:0] a,
    output cs_n,
    output d
    );

    parameter FRAME_SIZE = 16;              // number of bits in SPI frame
    parameter CYCLE_WIDTH = FRAME_SIZE + 1; // allow one additional clock cycle for CS to transition
    
    reg [4:0] bit_count = 0;
    reg [3:0] frame_count = 0;
    wire bit_count_max;
    wire frame_tick;
    wire cs;

    // Count clock cycles to establish basic timing controls
    always @(negedge clk) begin
        if (bit_count_max)
            bit_count <= 0;
        else
            bit_count = bit_count + 1;     
    end

    // bit_count counts from 0 up to CYCLE_WIDTH - 1    
    assign bit_count_max = (bit_count == (CYCLE_WIDTH - 1)) ? 1'b1 : 1'b0;
    // increment frame_count one cycle early to allow ROM settle time
    assign frame_tick = (bit_count == (CYCLE_WIDTH - 2)) ? 1'b1 : 1'b0;
    assign cs = (bit_count < (CYCLE_WIDTH - 1)) ? 1'b1 : 1'b0;
    
    always @(negedge clk) begin
        if (frame_tick)
            frame_count <= frame_count + 1;
    end

    wire [15:0] rom_out;
    
    rom u1 (.a(frame_count), .d(rom_out));
        
    reg [FRAME_SIZE-2:0] shift = {FRAME_SIZE-1{1'b0}};
    reg                  dout = 1'b0;
 
    always @(negedge clk) begin
       if (bit_count_max) begin
          shift <= rom_out[FRAME_SIZE-2:0];
          dout    <= rom_out[FRAME_SIZE-1];
       end
       else begin
          shift <= {shift[FRAME_SIZE-3:0], 1'b0};
          dout   <= shift[FRAME_SIZE-2];
       end
    end
    
    assign bcount = bit_count;
    assign a = frame_count;
    assign cs_n = ~cs;
    assign d = dout;

endmodule
