module TOUCH_3KEYS_INVIS(
	input wire clk,
//	input wire reset,	
//	input wire switch,
	input wire [1:0]clcount,
	input wire enable,

	input wire [9:0]tor_x,
	input wire [8:0]tor_y,

	
	output reg t_five,
	output reg t_ten,
	output reg t_f_teen
	);
	
parameter[9:0] x1 = 11'd60;
parameter[9:0] x2 = 11'd138;
parameter[8:0] y1 = 11'd149;
parameter[8:0] y2 = 11'd228;

parameter[9:0] x3 = 11'd260;
parameter[9:0] x4 = 11'd338;

parameter[9:0] x5 = 11'd460;
parameter[9:0] x6 = 11'd538;

always @ (posedge clk)
	begin
		if (enable == 1)
		begin
			if (clcount == 1) 
			begin
				if ((tor_x[9:0]>=x1)&&(tor_x[9:0]<=x2)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_five = 1;
					else
						t_five = 0;
				if ((tor_x[9:0]>=x3)&&(tor_x[9:0]<=x4)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_ten = 1;
					else
						t_ten = 0;
				if ((tor_x[9:0]>=x5)&&(tor_x[9:0]<=x6)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
						t_f_teen = 1;
					else
						t_f_teen = 0;
			end
				else
				begin
					t_five = 0;
					t_ten = 0;
					t_f_teen = 0;
				end
		end
			else
			begin
				t_five = t_five;
				t_ten = t_ten;
				t_f_teen = t_f_teen;
			end
	end	
endmodule