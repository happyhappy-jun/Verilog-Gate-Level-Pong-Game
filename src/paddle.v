`timescale 1ns / 1ps

module paddle(
	input clk_1ms,reset,
	input button, button1, button2, button3,
	input switch,
	input [9:0] x, y,
	output paddle1_on,paddle2_on,
	output [11:0] rgb_paddle1, rgb_paddle2,
	output reg [9:0] x_paddle1,
	output reg [9:0] y_paddle1,
	output reg [9:0] x_paddle2,
	output reg [9:0] y_paddle2,
	output reg [10:0] led
	);
	
	localparam H_active = 640;
	localparam V_active = 480;
	
	localparam paddlewidth = 6;
	localparam paddleheight = 60;
	
	localparam L_position = 16;
	localparam R_position = 16;


    wire [9:0] paddle1_rest;
    wire [9:0] paddle1_down;
    wire [9:0] paddle1_up;
    wire [9:0] paddle2_rest;
    wire [9:0] paddle2_down;
    wire [9:0] paddle2_up;
   
    
    always @ (posedge clk_1ms)
        begin
            if(reset)
            begin	
                x_paddle1 <= L_position + (paddlewidth/2);
                y_paddle1 <= V_active/2;
               
            end
            else if (switch)
                y_paddle1 <= y_paddle1;
            else if (button && y_paddle1-(paddleheight/2) > 0)
                y_paddle1 <= y_paddle1-1 ;
            else if (button1 && y_paddle1+(paddleheight/2) < V_active)
                y_paddle1 <= y_paddle1+1;
            else y_paddle1 <= y_paddle1;
            
        end
	
	always @ (posedge clk_1ms)
	begin
		if(reset)
		begin	
			x_paddle2 <= H_active-(R_position + (paddlewidth/2));
			y_paddle2 <= V_active/2;
		end
		else if (switch)
                y_paddle2 <= y_paddle2;
		else if (button2 && y_paddle2-(paddleheight/2) > 0)
			y_paddle2 <= y_paddle2 -1;
		else if (button3 && y_paddle2+(paddleheight/2) < V_active )
			y_paddle2 <= y_paddle2 +1;
		else y_paddle2 <= y_paddle2;
	end
	
	assign paddle1_on = (x >= x_paddle1-(paddlewidth/2) && x <= x_paddle1+(paddlewidth/2) && y >= y_paddle1-(paddleheight/2) && y < y_paddle1+(paddleheight/2));
	assign rgb_paddle1 = 12'b111111111111; 
	
	assign paddle2_on = (x >= x_paddle2-(paddlewidth/2) && x <= x_paddle2+(paddlewidth/2) && y >= y_paddle2-(paddleheight/2) && y < y_paddle2+(paddleheight/2));
	assign rgb_paddle2 = 12'b111111111111; // 12'b111101110000;
endmodule

