`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2020 07:05:47 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk, reset, button, button1, button2, button3,switch,
    output [15:0]led,
	output [11:0] rgb,
	output hsync, vsync,
	output [3:0] Anode_Activate,
	output  [6:0] LED_out
    );
    wire [9:0] x,y;
	wire video_on;
	wire clk_1ms;
	wire p1_win, p2_win;
	wire [11:0] rgb_paddle1, rgb_paddle2, rgb_ball;
	wire ball_on, paddle1_on, paddle2_on;
	wire [3:0] p1_score, p2_score;
	wire [9:0] x_paddle1, x_paddle2, y_paddle1, y_paddle2;
	wire[2:0] state;
	wire overflow1, overflow2;
	wire game_end;
	
    vga_sync v1 (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .x(x), .y(y), .video_on(video_on));
    
    paddle p1(.switch(switch), .clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y), .rgb_paddle1(rgb_paddle1), .button(button), .button1(button1), .button2(button2),
     .button3(button3), .rgb_paddle2(rgb_paddle2), .paddle1_on(paddle1_on), .paddle2_on(paddle2_on), .x_paddle1(x_paddle1), .x_paddle2(x_paddle2), 
        .y_paddle1(y_paddle1), .y_paddle2(y_paddle2));
        

	ball b1 	(.game_end(game_end), .clk(clk), .clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y),  .ball_on(ball_on), .rgb_ball(rgb_ball),
				.x_paddle1(x_paddle1), .x_paddle2(x_paddle2), .y_paddle1(y_paddle1), .y_paddle2(y_paddle2), .state(state), .p1_win(p1_win), .p2_win(p2_win),
				.led(led)
				);
				
    render r1	(.clk(clk), .reset(reset), .x(x), .y(y), .video_on(video_on), .rgb(rgb), .clk_1ms(clk_1ms),
					.paddle1_on(paddle1_on), .paddle2_on(paddle2_on), .ball_on(ball_on), 
					.rgb_paddle1(rgb_paddle1), .rgb_paddle2(rgb_paddle2), .rgb_ball(rgb_ball));
				
    
    clock_divider(.clk(clk), .clk_1ms(clk_1ms));
    
    game_control gc1(.switch(switch), .led(led), .reset(~reset), .clk_1ms(clk_1ms), .B(button||button1||button2||button3), .overflow1(overflow1), .overflow2(overflow2), .state(state) , .set_over(p1_win|p2_win) , .game_end(game_end));
    
    game_over go1(.clk_1ms(clk_1ms), .game_end(game_end), .led(led), .reset(~reset), .p1_win(p1_win),  .p2_win(p2_win), .p1_score(p1_score), .p2_score(p2_score), .overflow1(overflow1), .overflow2(overflow2));
    
    Seven_segment_LED_Display_Controller(.clk(clk), .reset(reset), .p1_score(p1_score), .p2_score(p2_score), .Anode_Activate(Anode_Activate) , .LED_out(LED_out)); 
   
endmodule
