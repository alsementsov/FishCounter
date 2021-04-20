module DRAW_NUMBERS(
	input wire clk,
//	input wire reset,
	
	input wire enable,
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_five,
	output reg out_ten,
	output reg out_f_teen
	
	);
	
parameter[10:0] x1 = 11'd56;
parameter[10:0] x2 = 11'd145;
parameter[9:0] y1 = 10'd149;
parameter[9:0] y2 = 10'd228;

parameter[10:0] x3 = 11'd256;
parameter[10:0] x4 = 11'd345;

parameter[10:0] x5 = 11'd456;
parameter[10:0] x6 = 11'd545;

always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_five = 1;
			end
			else
				out_five = 0;
		if ((gr_x[10:0]>=x3[10:0])&&(gr_x[10:0]<=x4)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_ten = 1;
			end
			else
				out_ten = 0;
		if ((gr_x[10:0]>=x5[10:0])&&(gr_x[10:0]<=x6)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_f_teen = 1;
			end
			else
				out_f_teen = 0;
	end
	else
	begin
		out_five = 0;
		out_ten = 0;
		out_f_teen = 0;
	end
	end
endmodule