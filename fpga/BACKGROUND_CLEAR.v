module BACKGROUND_CLEAR(
	input wire clk,
//	input wire reset,
	input wire enable,
	
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,

	
	output reg outbgcl,
	output reg outgcl	
	);
	
parameter[10:0] x1 = 11'd161;
parameter[10:0] x2 = 11'd560;
parameter[9:0] y1 = 11'd140;
parameter[9:0] y2 = 11'd390;
parameter[10:0] x3 = 11'd163;
parameter[10:0] x4 = 11'd558;
parameter[9:0] y3 = 11'd142;
parameter[9:0] y4 = 11'd388;


always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				outbgcl = 1;
			end
			else
				outbgcl = 0;
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y3)||
			(gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x3[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y4)||
			(gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y4)&&(gr_y[9:0]<=y2)||
			(gr_x[10:0]>=x4[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				outgcl = 1;
			end
			else
				outgcl = 0;		
	end
	else
	begin
		outbgcl = 0;
		outgcl = 0;
	end
	end
endmodule