module TOUCH_3KEYSLARGE_INVIS(
	input wire clk,
//	input wire reset,	
//	input wire switch,
	input wire [1:0]clcount,
	input wire enable,

	input wire [9:0]tor_x,
	input wire [8:0]tor_y,

	
	output reg t_twfi,
	output reg t_fiei,
	output reg t_eion
	);
	
parameter[9:0] x1 = 11'd15;
parameter[9:0] x2 = 11'd183;
parameter[8:0] y1 = 11'd294;
parameter[8:0] y2 = 11'd373;

parameter[9:0] x3 = 11'd215;
parameter[9:0] x4 = 11'd383;

parameter[9:0] x5 = 11'd415;
parameter[9:0] x6 = 11'd583;

always @ (posedge clk)
	begin
		if (enable == 1)
		begin
			if (clcount == 1) 
			begin
				if ((tor_x[9:0]>=x1)&&(tor_x[9:0]<=x2)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_twfi = 1;
					else
						t_twfi = 0;
				if ((tor_x[9:0]>=x3)&&(tor_x[9:0]<=x4)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_fiei = 1;
					else
						t_fiei = 0;
				if ((tor_x[9:0]>=x5)&&(tor_x[9:0]<=x6)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_eion = 1;
					else
						t_eion = 0;
			end
				else
				begin
					t_twfi = 0;
					t_fiei = 0;
					t_eion = 0;
				end
		end
			else
			begin
				t_twfi = t_twfi;
				t_fiei = t_fiei;
				t_eion = t_eion;
			end
	end	
endmodule