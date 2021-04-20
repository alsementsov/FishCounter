module GREEN_DRAW2(
	input wire clk,
//	input wire reset,	
	input wire en,
	
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	input wire [10:0]T_x,
	input wire [9:0]T_y,
	
	output reg outg
	
	);
	
parameter[10:0] x1 = 11'd181;
parameter[10:0] x2 = 11'd331;
parameter[9:0] y1 = 11'd11;
parameter[9:0] y2 = 11'd109;


always @ (posedge clk)
	begin
		if (en == 1) 
		begin
			if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=T_x)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=T_y))
				begin
					outg = 1;
				end
				else
					outg = 0;
		end
		else
			outg = 0;
	end	
endmodule