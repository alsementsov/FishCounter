module TOUCH_3KEYS_1(
	input wire clk,
//	input wire reset,	
	input wire [1:0]clcount,
	input wire [7:0]enable,

	input wire [9:0]tor_x,
	input wire [8:0]tor_y,

	
	output reg op_cl,
	output reg pl_pa,
	output reg clear
	
	);
	
parameter[9:0] x1 = 11'd15;
parameter[9:0] x2 = 11'd93;
parameter[8:0] y1 = 11'd11;
parameter[8:0] y2 = 11'd90;

parameter[9:0] x3 = 11'd125;
parameter[9:0] x4 = 11'd203;

parameter[9:0] x5 = 11'd235;
parameter[9:0] x6 = 11'd313;

always @ (posedge clk)
	begin
		//if (((enable[7:0] > 8'd0) || (clcount[1:0] > 2'b0))&&(valid == 1)) 
		if (clcount == 1) 
		begin
			if ((tor_x[9:0]>=x1)&&(tor_x[9:0]<=x2)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
					op_cl = 1;
				else
					op_cl = 0;
			if ((tor_x[9:0]>=x3)&&(tor_x[9:0]<=x4)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
					pl_pa = 1;
				else
					pl_pa = 0;	
			if ((tor_x[9:0]>=x5)&&(tor_x[9:0]<=x6)&&(tor_y[8:0]>=y1)&&(tor_y[8:0]<=y2))
					clear = 1;
				else
					clear = 0;			
		end
		else
		begin
			op_cl = 0;
			pl_pa = 0;
			clear = 0;
		end
	end	
endmodule