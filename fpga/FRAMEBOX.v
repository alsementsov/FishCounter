module FRAMEBOX(
	input wire clk,
//	input wire reset,
//	input wire enable,
	
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,

	output reg outbl
	);
	
parameter[10:0] x1 = 11'd0;
parameter[10:0] x2 = 11'd720;
parameter[9:0] y1 = 11'd0;
parameter[9:0] y2 = 11'd100;

parameter[9:0] y3 = 11'd390;
parameter[9:0] y4 = 11'd480;

always @ (posedge clk)
	begin
		if (((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))||
			((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y3)&&(gr_y[9:0]<=y4)))
			begin
				outbl = 1;
			end
			else
				outbl = 0;
	end
endmodule