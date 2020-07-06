`timescale 1ns / 1ps

module game_over(
    input reset, input win_1, input win_2,
    output s_1, output s_2
    );
    score_cal score_p1(.reset(reset), .adder(win_1), .overflow(s_1));
    score_cal score_p2(.reset(reset), .adder(win_2), .overflow(s_2));
     
endmodule    

module score_cal(
    input reset, input adder,
    output [2:0] score, output overflow
    );
    wire [2:0] OUT;
    wire [1:0] C;
    //edgeTriggeredTFF(input RESET_N, input T, input CK, output Q, output Q_);
    edgeTriggeredTFF one(reset, 1'b1, adder, score[0], OUT[0]);
    edgeTriggeredTFF two(reset, score[2], adder, score[1], OUT[1]);
    edgeTriggeredTFF four(reset, score[1]&score[2], adder, score[2], OUT[2]);
    assign overflow = score[0]&score[1]&score[2];   
endmodule

`timescale 1ns / 1ps

module game_control(
    input reset, input clk_1ms,
    input B, input s_1, input s_2,
    output X, output Y
    );
    wire [2:0]trash;
    edgeTriggeredTFF X_state(reset, ( (~Y)&B)| (X&Ys_1&(~s_2) ), clk_1ms, X, trash[0]);
    edgeTriggeredTFF Y_state(reset, ( (~X)&B | (X&Y&(~s_1)&s_2) ), clk_1ms, Y, trash[1]);
endmodule