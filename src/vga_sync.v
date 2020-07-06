module vga_sync

	(
		input wire clk, reset,
		output wire hsync, vsync, video_on, p_tick,
		output wire [9:0] x, y
	);
	
	// constant declarations for VGA sync parameters
	localparam H_DISPLAY       = 640; // horizontal display area
	localparam H_L_BORDER      =  48; // horizontal left border
	localparam H_R_BORDER      =  16; // horizontal right border
	localparam H_SYNC       =  96; // horizontal retrace
	localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_SYNC - 1;
	localparam START_H_SYNC = H_DISPLAY + H_R_BORDER;
	localparam END_H_SYNC   = H_DISPLAY + H_R_BORDER + H_SYNC - 1;
	
	localparam V_DISPLAY       = 480; // vertical display area
	localparam V_T_BORDER      =  11; // vertical top border
	localparam V_B_BORDER      =  31; // vertical bottom border
	localparam V_SYNC       =   2; // vertical retrace
	localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_SYNC - 1;
    localparam START_V_SYNC = V_DISPLAY + V_B_BORDER;
	localparam END_V_SYNC   = V_DISPLAY + V_B_BORDER + V_SYNC - 1;
	
	// mod-4 counter to generate 25 MHz pixel tick
	reg [1:0] pixel_reg;
	wire [1:0] pixel_next;
	wire pixel_tick;
	
	always @(posedge clk, posedge reset)
		if(reset)
		  pixel_reg <= 0;
		else
		  pixel_reg <= pixel_next;
	
	assign pixel_next = pixel_reg + 1; // increment pixel_reg 
	
	assign pixel_tick = (pixel_reg == 0); // assert tick 1/4 of the time
	
	// registers to keep track of current pixel location
	reg [9:0] h_count_reg, h_count_next, v_count_reg, v_count_next;
	
	// register to keep track of vsync and hsync signal states
	reg vsync_reg, hsync_reg;
	wire vsync_next, hsync_next;
 
	// infer registers
	always @(posedge clk, posedge reset)
		if(reset)
		    begin
                    v_count_reg <= 0;
                    h_count_reg <= 0;
                    vsync_reg   <= 0;
                    hsync_reg   <= 0;
		    end
		else
		    begin
                    v_count_reg <= v_count_next;
                    h_count_reg <= h_count_next;
                    vsync_reg   <= vsync_next;
                    hsync_reg   <= hsync_next;
		    end
			
	always @*
		begin
		h_count_next = pixel_tick ?  h_count_reg == H_MAX ? 0 : h_count_reg + 1 : h_count_reg;
		
		v_count_next = pixel_tick && h_count_reg == H_MAX ? (v_count_reg == V_MAX ? 0 : v_count_reg + 1)  : v_count_reg;
		end
		
        assign hsync_next = h_count_reg >= START_H_SYNC && h_count_reg <= END_H_SYNC;
   
        assign vsync_next = v_count_reg >= START_V_SYNC  && v_count_reg <= END_V_SYNC;

        assign video_on = (h_count_reg < H_DISPLAY)  && (v_count_reg < V_DISPLAY);

        // output signals
        assign hsync  = hsync_reg;
        assign vsync  = vsync_reg;
        assign x      = h_count_reg;
        assign y      = v_count_reg;
        assign p_tick = pixel_tick;
endmodule