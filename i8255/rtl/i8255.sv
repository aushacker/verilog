`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     none
// Engineer:    aushacker
// 
// Create Date: 19.07.2023 17:11:07
// Design Name: i8255
// Module Name: i8255
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

module i8255(
    input clk,
    input reset,          // positive logic
    input rd,             // positive logic
    input wr,             // positive logic
    input cs,             // positive logic
    input [1:0] a,
    input [7:0] din,
    input [7:0] ain,
    input [7:0] bin,
    input [7:0] cin,
    output ddra,           // 1 = output
    output ddrb,           // 1 = output
    output reg [7:0] ddrc, // 1 = output
    output [7:0] aout,
    output [7:0] bout,
    output [7:0] cout,
    output reg [7:0] dout
    );

    // Control word bits
    parameter CW_FLAG = 7;      // 0 = bit set/reset, 1 = control word write
    parameter CW_GRPA_MODE = 5; // Mode 2 not supported so ignore bit 6
    parameter CW_DIR_A = 4;     // 0 = output, 1 = input
    parameter CW_DIR_CH = 3;    // 0 = output, 1 = input
    parameter CW_GRPB_MODE = 2; // 0 = Mode 0, 1 = Mode 1
    parameter CW_DIR_B = 1;     // 0 = output, 1 = input
    parameter CW_DIR_CL = 0;    // 0 = output, 1 = input

    // Registers
    logic [6:0] control_reg = 7'b0011011;
    logic [7:0] a_reg = 8'b0;
    logic [7:0] b_reg = 8'b0;
    logic [7:0] c_reg = 8'b0;

    // Register enables
    logic control_reg_en;
    logic a_reg_en;
    logic b_reg_en;
    logic c_reg_en;

    // Alias for clarity
    logic group_a_mode;
    logic group_b_mode;

    // Port C register controls
    logic bit_set_reset;
    logic [7:0] bsr;
    logic [7:0] c_data;

    // Control lines
    assign control_reg_en = cs && wr && !rd &&  a[1] &&  a[0] &&  din[CW_FLAG];
    assign a_reg_en       = cs && wr && !rd && !a[1] && !a[0];
    assign b_reg_en       = cs && wr && !rd && !a[1] &&  a[0];
    assign c_reg_en       = cs && wr && !rd &&  a[1] && !a[0];
    assign bit_set_reset  = cs && wr && !rd &&  a[1] &&  a[0] && !din[CW_FLAG];

    // Individual Port C control lines for bit set/reset
    assign bsr[0] = bit_set_reset && !din[3] && !din[2] && !din[1];
    assign bsr[1] = bit_set_reset && !din[3] && !din[2] &&  din[1];
    assign bsr[2] = bit_set_reset && !din[3] &&  din[2] && !din[1];
    assign bsr[3] = bit_set_reset && !din[3] &&  din[2] &&  din[1];
    assign bsr[4] = bit_set_reset &&  din[3] && !din[2] && !din[1];
    assign bsr[5] = bit_set_reset &&  din[3] && !din[2] &&  din[1];
    assign bsr[6] = bit_set_reset &&  din[3] &&  din[2] && !din[1];
    assign bsr[7] = bit_set_reset &&  din[3] &&  din[2] &&  din[1];
     
    // Alias for clarity
    assign group_a_mode = control_reg[CW_GRPA_MODE];
    assign group_b_mode = control_reg[CW_GRPB_MODE];
    
    // Control register
    always_ff @(posedge clk, posedge reset)
        if (reset)
            control_reg <= 7'b0011011;
        else if (control_reg_en)
            control_reg <= din[6:0];
        else control_reg <= control_reg;

    // Port A output latch
    always_ff @(posedge clk, posedge reset)
        if (reset)
            a_reg <= 8'h00;
        else if (a_reg_en)
            a_reg <= din;
        else a_reg <= a_reg;

    // Port B output latch
    always_ff @(posedge clk, posedge reset)
        if (reset)
            b_reg <= 8'h00;
        else if (b_reg_en)
            b_reg <= din;
        else b_reg <= b_reg;

    // Port C output latch
    genvar i;
    for (i = 7; i >= 0; i=i-1) begin
        assign c_data[i] = bit_set_reset ? din[0] : din[i];
        always_ff @(posedge clk, posedge reset)
            if (reset)
                c_reg[i] <= '0;
            else if (c_reg_en || bsr[i])
                c_reg[i] <= c_data[i];
            else c_reg[i] <= c_reg[i];
    end

    // Data out mux
    always_comb begin
        case (a)
            2'b00: dout = ain;
            2'b01: dout = bin;
            2'b10: dout = cin;
            default: dout = { 1'b1, control_reg };
        endcase
    end

    // CH data direction
    always_comb begin
        if (group_a_mode === '0) begin
            // Mode 0
            ddrc[4] = !control_reg[CW_DIR_CH];
            ddrc[5] = !control_reg[CW_DIR_CH];
            ddrc[6] = !control_reg[CW_DIR_CH];
            ddrc[7] = !control_reg[CW_DIR_CH];
        end
        else begin
            ddrc[7:4] = 4'b1111;
        end
    end

    // CL data direction
    always_comb begin
        if (group_b_mode === '0) begin
            // Mode 0
            ddrc[0] = !control_reg[CW_DIR_CL];
            ddrc[1] = !control_reg[CW_DIR_CL];
            ddrc[2] = !control_reg[CW_DIR_CL];
            ddrc[3] = !control_reg[CW_DIR_CL];
        end
        else begin
            ddrc[3:0] = 4'b1111;
        end
    end

    assign aout = a_reg;
    assign bout = b_reg;
    assign cout = c_reg;
    assign ddra = !control_reg[CW_DIR_A];
    assign ddrb = !control_reg[CW_DIR_B];

endmodule
