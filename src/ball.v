`timescale 1ns / 1ps
    
module ball(
    input reset, input clk_1ms, input clk,
    input [9:0]x_paddle1, input [9:0]y_paddle1,
    input [9:0]x_paddle2, input [9:0]y_paddle2,
    input [9:0] x, y,
    input ball_move_en,
    input [2:0] state,
    input game_end,
    output ball_on,
    output [11:0] rgb_ball,
    output reg [3:0] p1_score, p2_score, 
    output reg [10:0] led,
    output reg  p1_win, p2_win,
    output reg dir_x, dir_y,
    output reg [9:0]x_ball, output reg [9:0]y_ball
    );
    localparam ball_width = 4; //horizontal
	localparam ball_height = 4;//vertica
	
	localparam H_ACTIVE = 640;
	localparam V_ACTIVE = 480;
	
	localparam paddlewidth = 60;
	localparam paddleheight = 60;
	
	localparam L_position = 16;
	localparam R_position = 16;
    //move bal
    always @(posedge clk_1ms) 
    begin
        led[0] <= ~state[0];
        led[1] <= ~state[1];
        led[2] <= ~state[2];
       
        if( reset)
            begin
                p1_score <= 0;
                p2_score <= 0;
                x_ball <= 10'b0101000000;
                y_ball <= 10'b0011110000;
                dir_x <= 1'b1;
                dir_y <= 1'b1;
                p1_win <= 0;
                p2_win <= 0;
            end
        else
        begin
            if(state == 3'b000)
            begin
                x_ball <= 10'b0101000000;
                y_ball <= 10'b0011110000;
                dir_x <= ~dir_x;
                dir_y <= ~dir_y;
                p1_win <= 0;
                p2_win <= 0;
                x_ball <= x_ball;
                y_ball <= y_ball;
                
            end
            else if (state == 3'b010)
            begin
                x_ball <= 10'b0101000000;
                y_ball <= 10'b0011110000;
                dir_x <= ~dir_x;
                dir_y <= ~dir_y;
                p1_win <= 0;
                p2_win <= 0;
                x_ball <= x_ball;
                y_ball <= y_ball;
                led[8] <= 1'b1;
            end
            else if(state == 3'b001)
            begin
                x_ball <= 10'b0101000000;
                y_ball <= 10'b0011110000;
                dir_x <= ~dir_x;
                dir_y <= ~dir_y;
                p1_win <= 0;
                p2_win <= 0;
                x_ball <= x_ball;
                y_ball <= y_ball;
                led[9] <= 1'b1;
            end
            else if (state == 3'b111)
            begin
                x_ball <= x_ball;
                y_ball <= y_ball;
            end
            else if(state == 3'b011)
            begin
                if(x_ball == 0)
                    begin
                        x_ball <= 10'b0101000000;
                        y_ball <= 10'b0011110000;
                        dir_x <= ~dir_x;
                        dir_y <= ~dir_y;
                        p2_win <= 1;
                        p1_win <= 0;
                    end
                else if(x_ball == (H_ACTIVE -ball_width/2))
                    begin
                        x_ball <= 10'b0101000000;
                        y_ball <= 10'b0011110000;
                        dir_x <= ~dir_x;
                        dir_y <= ~dir_y;
                        p2_win <= 0;
                        p1_win <= 1;
                   end 
                else if (x_ball > (x_paddle2-ball_width/2) && y_ball > (y_paddle2 - paddleheight/2) && y_ball < (y_paddle2 + paddleheight/2))
                    begin
                        x_ball <= x_ball-1;
                        dir_x <= ~dir_x;
                    end
                
                else if(x_ball < (x_paddle1+ball_width/2) && y_ball > (y_paddle1 - paddleheight/2) && y_ball < (y_paddle1 + paddleheight/2))
                begin
                    x_ball <= x_ball+1;
                    dir_x <= ~dir_x;
                end
                
                //wall col
                else if (y_ball == 10'b0000000000 ) 
                begin
                    y_ball <= y_ball+1;
                    dir_y <= ~dir_y;
                end
                
                else if(y_ball == 10'b0111100000)
                begin
                    y_ball <=y_ball-1;
                    dir_y <= ~dir_y; 
                end
                else
                begin
                    if(dir_x)
                    begin
                        x_ball <= x_ball + 1;
                    end
                    else
                    begin
                        x_ball <= x_ball-1;
                    end
                    if(dir_y)
                    begin
                        y_ball <= y_ball-1;
                    end
                    else
                    begin
                        y_ball <= y_ball+1;
                    end
                end 
            end      
        end
    end

    assign ball_on = (x >= x_ball-(ball_width/2) && x <= x_ball+(ball_width/2) && y >= y_ball-(ball_height/2) && y <= y_ball+(ball_height/2))?1:0;
    assign rgb_ball = 12'b111111111111;
endmodule

