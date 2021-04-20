module BACKGROUND_MENU(
	input wire clk,
//	input wire reset,
	input wire enable,
	
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,

	
	output reg outbgme,
	output reg outgme	
	);
	
parameter[10:0] x1 = 11'd5;
parameter[10:0] x2 = 11'd596;
parameter[9:0] y1 = 11'd96;
parameter[9:0] y2 = 11'd381;
parameter[10:0] x3 = 11'd7;
parameter[10:0] x4 = 11'd594;
parameter[9:0] y3 = 11'd98;
parameter[9:0] y4 = 11'd379;


always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				outbgme = 1;
			end
			else
				outbgme = 0;
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y3)||
			(gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x3[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y4)||
			(gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y4)&&(gr_y[9:0]<=y2)||
			(gr_x[10:0]>=x4[10:0])&&(gr_x[10:0]<=x2[10:0])&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				outgme = 1;
			end
			else
				outgme = 0;		
	end
	else
	begin
		outbgme = 0;
		outgme = 0;
	end
	end
endmodule