module DRAW_3TITLES(
	input wire clk,
//	input wire reset,	

	input wire [10:0]clk_x,
	input wire [9:0]clk_y,
	
	output reg ti_count,
	output reg ti_sr_mass,
	output reg ti_com_mass
	
	);
	
parameter[10:0] x1 = 11'd0;
parameter[10:0] x2 = 11'd244;
parameter[9:0] y1 = 11'd390;
parameter[9:0] y2 = 11'd430;

parameter[10:0] x3 = 11'd241;
parameter[10:0] x4 = 11'd485;

parameter[10:0] x5 = 11'd490;
parameter[10:0] x6 = 11'd734;

always @ (posedge clk)
	begin
		//if (((enable[7:0] > 8'd0) || (clcount[1:0] > 2'b0))&&(valid == 1)) 
			if ((clk_x[10:0]>=x1)&&(clk_x[10:0]<=x2)&&(clk_y[9:0]>=y1)&&(clk_y[9:0]<=y2))
					ti_count = 1;
				else
					ti_count = 0;
			if ((clk_x[10:0]>=x3)&&(clk_x[10:0]<=x4)&&(clk_y[9:0]>=y1)&&(clk_y[9:0]<=y2))
					ti_sr_mass = 1;
				else
					ti_sr_mass = 0;	
			if ((clk_x[10:0]>=x5)&&(clk_x[10:0]<=x6)&&(clk_y[9:0]>=y1)&&(clk_y[9:0]<=y2))
					ti_com_mass = 1;
				else
					ti_com_mass = 0;	
	end	
endmodule