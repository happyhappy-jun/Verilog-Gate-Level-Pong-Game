`timescale 1ns / 1ps

module game_control(
    input reset, input clk_1ms, input set_over, input switch,
    input B, input overflow1, input overflow2,
    output [2:0] state, reg [15:0] led,
    output game_end
    );
    wire [2:0]trash;
    always @(posedge clk_1ms)
    begin
        led[14] <= switch;
    end
    edgeTriggeredTFF X_state(reset, ~state[1]&~state[0]&B | state[1]&state[0]&overflow1&(~overflow2) | state[0]&state[1]&(~overflow1)&(~overflow2)&set_over |state[1]&~state[0]&~reset, clk_1ms, state[1], trash[0]);
    edgeTriggeredTFF Y_state(reset, (~state[0]&~state[1]&B | (state[0]&state[1]&(~overflow1)&overflow2) | (state[0]&state[1]&(~overflow1)&(~overflow2)&set_over)| state[1]&state[0]&~reset), clk_1ms, state[0], trash[1]);
    edgeTriggeredTFF Z_state(reset, state[1]&state[0]&(state[2]^switch), clk_1ms, state[2], trash[2]);
    
endmodule

module game_over(
    input clk_1ms, input reset, input p1_win, input p2_win,input game_end,
    output [2:0] p1_score, p2_score,
    output [10:0] led,
    output overflow1, overflow2
    );
    assign led[3] = p1_score[0];
    assign led[4] = p1_score[1];
    assign led[5] = p1_score[2];
    
    wire [2:0] p1_temp, p2_temp;
    assign p1_temp = p1_score;
    assign p2_temp = p2_score;
    wire of1, of2;
    score_cal s1 (.reset(reset), .adder(p1_win), .out(p1_temp), .overflow(of1));
    score_cal s2 (.reset(reset), .adder(p2_win), .out(p2_temp), .overflow(of2));


    assign overflow1 = of1 & reset | 1'b0&(~reset);
    assign overflow2 = of2 & reset | 1'b0&(~reset);
//    always @(posedge clk_1ms)
//        if(of1|of2)
//        begin
//            p1_score <= 0;
//            p2_score <= 0;
//            overflow1 <= 0;
//            overflow2 <=0;
//        end
//        else
//        begin
//            p1_score <= p1_temp;
//            p2_score <= p2_temp;
//            overflow1 <= of1;
//            overflow2 <= of2;
//        end
//    assign p1_score = (~(of1|of2))&p1_temp;
//    assign p2_score = (~(of1|of2))&p2_temp;
//    assign overflow1 = (of1|of2)&of1;
//    assign overflow2 = (of1|of2)&of2;
    
endmodule    

module score_cal(
    input reset, input adder,input clk_1ms,
    output [2:0] out, output overflow
    );
    wire [2:0] OUT;
    wire [1:0] C;
    //edgeTriggeredTFF(input RESET_N, input T, input CK, output Q, output Q_);
    wire [2:0]out_temp;
    edgeTriggeredTFF one(reset, 1'b1, adder, out_temp[0], OUT[0]);
    edgeTriggeredTFF two(reset, out_temp[0], adder, out_temp[1], OUT[1]);
    edgeTriggeredTFF four(reset, out_temp[1]&out_temp[0], adder, out_temp[2], OUT[2]);
    edgeTriggeredTFF eight(reset, out_temp[3] | out_temp[2]&out_temp[1]&out_temp[0], adder, out_temp[3], OUT[2]);
    assign overflow = out_temp[3];   
    assign out[2] = out_temp[2];
    assign out[1] = out_temp[1];
    assign out[0] = out_temp[0];
    
endmodule