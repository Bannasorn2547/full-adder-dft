/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module tt_um_full_adder_dft (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire A, B, Cin, tmode, tin1;
    wire Sum, Cout;

    assign A     = ui_in[0];
    assign B     = ui_in[1];
    assign Cin   = ui_in[2];
    assign tmode = ui_in[3];
    assign tin1  = ui_in[4];

    FA_DFT fa (
        .A(A),
        .B(B),
        .Cin(Cin),
        .tmode(tmode),
        .tin1(tin1),
        .Sum(Sum),
        .Cout(Cout)
    );

    assign uo_out = {6'b0, Cout, Sum};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

module FA_DFT (
    input wire A, B, Cin, tmode, tin1,
    output wire Sum, Cout
);
    wire w0, w1, w2, w3, z1;

    assign w0 = A ^ B;
    assign z1 = tmode ? tin1 : w0;
    assign w3 = z1 ^ Cin;
    assign Sum = tmode ? w2 : w3;

    assign w1 = A & B;
    assign w2 = z1 & Cin;
    assign Cout = w2 | w1;
endmodule

