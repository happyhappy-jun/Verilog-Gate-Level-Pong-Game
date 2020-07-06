`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/01/2020 07:25:53 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk,
    output reg clk_1ms = 0
    );
    
    reg [27:0] i = 0;
    
	always @ (posedge clk)
        begin
            if (i == 124999)// not 1ms
            begin
                i <= 0;
                clk_1ms = ~clk_1ms;
            end
            else i <= i+1;
        end
    
endmodule
