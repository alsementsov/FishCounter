module DRAW_LARGE_NUMBERS(
	input wire clk,
//	input wire reset,
	input wire enable,
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_twfi,
	output reg out_fiei,
	output reg out_eion
	);
	
parameter[10:0] x1 = 11'd11;
parameter[10:0] x2 = 11'd190;
parameter[9:0] y1 = 11'd294;
parameter[9:0] y2 = 11'd373;

parameter[10:0] x3 = 11'd211;
parameter[10:0] x4 = 11'd390;

parameter[10:0] x5 = 11'd411;
parameter[10:0] x6 = 11'd590;

always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_twfi = 1;
			end
			else
				out_twfi = 0;	
		if ((gr_x[10:0]>=x3[10:0])&&(gr_x[10:0]<=x4)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_fiei = 1;
			end
			else
				out_fiei = 0;	
		if ((gr_x[10:0]>=x5[10:0])&&(gr_x[10:0]<=x6)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_eion = 1;
			end
			else
				out_eion = 0;	
	end
	else
	begin
		out_twfi = 0;
		out_fiei = 0;
		out_eion = 0;
	end
	end
endmodule