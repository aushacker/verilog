`timescale 1ns / 1ps

module top(
    input reset,
    input rd_n,
    input wr_n,
    input cs_n,
    input [1:0] a,
    input [7:0] d,
    inout [7:0] pa,
    inout [7:0] pb,
    inout [7:0] pc
    );

    wire en_mode_wr, en_pa_wr, en_pb_wr, en_pc_wr;
    wire [7:0] pa_out, pa_in;
    wire pa_oe;
    wire [7:0] pb_out, pb_in;
    wire pb_oe;
    wire [7:0] pc_out, pc_in;
    wire pc_low_oe, pc_high_oe;
    wire [7:0] mode;

    // Control signal decodes
    assign en_pa_wr = !reset & !a[1] & !a[0] & rd_n & !wr_n;
    assign en_pb_wr = !reset & !a[1] & a[0] & rd_n & !wr_n;
    assign en_pc_wr = !reset & a[1] & !a[0] & rd_n & !wr_n;
    assign en_mode_wr = !reset & a[1] & a[0] & rd_n & !wr_n & d[7];

    // Mode latch bit names
    assign pa_oe = !mode[4];
    assign pc_high_oe = !mode[3];
    assign pb_oe = !mode[1];
    assign pc_low_oe = !mode[0];

    breg pa_latch (.reset(reset), .en(en_pa_wr), .d(d), .q(pa_out));
    breg pb_latch (.reset(reset), .en(en_pb_wr), .d(d), .q(pb_out));
    breg pc_latch (.reset(reset), .en(en_pc_wr), .d(d), .q(pc_out));
    breg #(.INIT(8'b00011011)) mode_latch (.reset(reset), .en(en_mode_wr), .d(d), .q(mode));

    assign pa = pa_oe ? pa_out : 8'hzz;
    assign pa_in = pa;
    assign pb = pb_oe ? pb_out : 8'hzz;
    assign pb_in = pb;
    assign pc[3:0] = pc_low_oe ? pc_out[3:0] : 4'hz;
    assign pc[7:4] = pc_high_oe ? pc_out[7:4] : 4'hz;
    assign pc_in = pc;
      
endmodule
