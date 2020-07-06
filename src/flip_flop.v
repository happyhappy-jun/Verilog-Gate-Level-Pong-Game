`timescale 1ns / 1ps

// Negative Edge triggered J-K Flip Flop
module edgeTriggeredJKFF(input RESET_N, input J, input K, input CK, output reg Q, output reg Q_);    
    initial begin
      Q = 0;
      Q_ = ~Q;
    end
    always @(posedge CK) begin
        Q = RESET_N & (J&~Q | ~K&Q);
        Q_ = ~RESET_N | ~Q;
    end
endmodule

////Negative Edge triggered D Flip Flop
//module edgeTriggeredDFF(input RESET_N, input D, input CK, output Q, output Q_);
//        edgeTriggeredJKFF D_FF(RESET_N, D, ~D, CK, Q, Q_);
//endmodule

//Negative Edge triggered T Flip Flop
module edgeTriggeredTFF(input RESET_N, input T, input CK, output Q, output Q_);
        edgeTriggeredJKFF T_FF(RESET_N, T, T, CK, Q, Q_);
endmodule