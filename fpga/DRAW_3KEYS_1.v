module DRAW_3KEYS_1(
	input wire clk,
//	input wire reset,
	
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_op_cl,
	output reg out_pl_pa,
	output reg out_clear
	
	);
	
parameter[10:0] x1 = 11'd11;
parameter[10:0] x2 = 11'd100;
parameter[9:0] y1 = 11'd11;
parameter[9:0] y2 = 11'd90;

parameter[10:0] x3 = 11'd121;
parameter[10:0] x4 = 11'd210;

parameter[10:0] x5 = 11'd231;
parameter[10:0] x6 = 11'd320;

always @ (posedge clk)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_op_cl = 1;
			end
			else
				out_op_cl = 0;
		if ((gr_x[10:0]>=x3[10:0])&&(gr_x[10:0]<=x4)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_pl_pa = 1;
			end
			else
				out_pl_pa = 0;
		if ((gr_x[10:0]>=x5[10:0])&&(gr_x[10:0]<=x6)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_clear = 1;
			end
			else
				out_clear = 0;
	end
endmodule