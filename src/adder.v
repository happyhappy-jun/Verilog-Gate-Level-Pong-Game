`timescale 1ns / 1ps

module halfAdder(input A, input B, output S, output C);
    assign S = A^B;
    assign C = A&B;
endmodule

module fullAdder(input A, input B, input C_IN, output S, output C_OUT);
    assign C_OUT = A&B | (A^B)&C_IN;
    assign S = A^B^C_IN;
endmodule

//three bit Adder for score check
module threebitAdder(input [2:0]A, output [2:0]OUT, output C_OUT);
    wire [1:0]C;
    halfAdder one(A[0], 1'b1, OUT[0], C[0]);
    fullAdder two(A[1], 1'b0, C[0], OUT[1], C[1]);
    fullAdder four(A[2], 1'b0, C[1], OUT[2], C_OUT);
endmodule

module score_calculator(input [2:0]A, output [2:0]OUT, input win, output C_OUT);
    wire [1:0]C;
    halfAdder one(A[0], win, OUT[0], C[0]);
    fullAdder two(A[1], 1'b0, C[0], OUT[1], C[1]);
    fullAdder four(A[2], 1'b0, C[1], OUT[2], C_OUT);
endmodule
//ten bit adder for location change
module tenbitAdder(input EN, input [9:0]loc, input sub, output [9:0]OUT);
    wire [9:0]C;
    fullAdder f0(loc[0], 1'b1&EN, 1'b0, OUT[0], C[0]);
    fullAdder f1(loc[1], (~sub)&EN, C[0], OUT[1], C[1]);
    fullAdder f2(loc[2], (~sub)&EN, C[1], OUT[2], C[2]);
    fullAdder f3(loc[3], (~sub)&EN, C[2], OUT[3], C[3]);
    fullAdder f4(loc[4], (~sub)&EN, C[3], OUT[4], C[4]);
    fullAdder f5(loc[5], (~sub)&EN, C[4], OUT[5], C[5]);
    fullAdder f6(loc[6], (~sub)&EN, C[5], OUT[6], C[6]);
    fullAdder f7(loc[7], (~sub)&EN, C[6], OUT[7], C[7]);
    fullAdder f8(loc[8], (~sub)&EN, C[7], OUT[8], C[8]);
    fullAdder f9(loc[9], (~sub)&EN, C[8], OUT[9], C[9]);
endmodule

`timescale 1ns / 1ps

module ten_up_down(
    input [9:0]loc,
    output [9:0] rest, output [9:0]down, [9:0]up
    );
    wire [9:0]c_down;
    wire [9:0]c_up;
    assign rest = loc;
    fullAdder u0(loc[0], 1'b1, 1'b0, up[0], c_up[0]);
    fullAdder u1(loc[1], 1'b1, c_up[0], up[1], c_up[1]);
    fullAdder u2(loc[2], 1'b1, c_up[1], up[2], c_up[2]);
    fullAdder u3(loc[3], 1'b1, c_up[2], up[3], c_up[3]);
    fullAdder u4(loc[4], 1'b1, c_up[3], up[4], c_up[4]);
    fullAdder u5(loc[5], 1'b1, c_up[4], up[5], c_up[5]);
    fullAdder u6(loc[6], 1'b1, c_up[5], up[6], c_up[6]);
    fullAdder u7(loc[7], 1'b1, c_up[6], up[7], c_up[7]);
    fullAdder u8(loc[8], 1'b1, c_up[7], up[8], c_up[8]);
    fullAdder u9(loc[9], 1'b1, c_up[8], up[9], c_up[9]);
    
    fullAdder d0(loc[0], 1'b1, 1'b0, down[0], c_down[0]);
    fullAdder d1(loc[1], 1'b0, c_down[0], down[1], c_down[1]);
    fullAdder d2(loc[2], 1'b0, c_down[1], down[2], c_down[2]);
    fullAdder d3(loc[3], 1'b0, c_down[2], down[3], c_down[3]);
    fullAdder d4(loc[4], 1'b0, c_down[3], down[4], c_down[4]);
    fullAdder d5(loc[5], 1'b0, c_down[4], down[5], c_down[5]);
    fullAdder d6(loc[6], 1'b0, c_down[5], down[6], c_down[6]);
    fullAdder d7(loc[7], 1'b0, c_down[6], down[7], c_down[7]);
    fullAdder d8(loc[8], 1'b0, c_down[7], down[8], c_down[8]);
    fullAdder d9(loc[9], 1'b0, c_down[8], down[9], c_down[9]);
endmodule