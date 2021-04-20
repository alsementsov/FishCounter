module TITLE_BIG_INVIS(
	input wire clk,
//	input wire reset,
	input wire enable,
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_title_1
	);
	
parameter[10:0] x1 = 11'd217;
parameter[10:0] x2 = 11'd486;
parameter[9:0] y1 = 11'd181;
parameter[9:0] y2 = 11'd261;


always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1)&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_title_1 = 1;
			end
			else
				out_title_1 = 0;		
	end
	else
		out_title_1 = 0;
	end
endmodule