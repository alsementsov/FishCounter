module YES_NO(
	input wire clk,
//	input wire reset,
	
	input wire enable,
	input wire [10:0]gr_x,
	input wire [9:0]gr_y,
	
	output reg out_yes,
	output reg out_no	
	);
	
parameter[10:0] x1 = 11'd206;
parameter[10:0] x2 = 11'd295;
parameter[9:0] y1 = 11'd301;
parameter[9:0] y2 = 11'd380;

parameter[10:0] x3 = 11'd406;
parameter[10:0] x4 = 11'd495;
parameter[9:0] y3 = 11'd301;
parameter[9:0] y4 = 11'd380;


always @ (posedge clk)
	begin
	if (enable == 1)
	begin
		if ((gr_x[10:0]>=x1[10:0])&&(gr_x[10:0]<=x2)&&(gr_y[9:0]>=y1)&&(gr_y[9:0]<=y2))
			begin
				out_yes = 1;
			end
			else
				out_yes = 0;
		if ((gr_x[10:0]>=x3[10:0])&&(gr_x[10:0]<=x4)&&(gr_y[9:0]>=y3)&&(gr_y[9:0]<=y4))
			begin
				out_no = 1;
			end
			else
				out_no = 0;		
	end
	else
	begin
		out_yes = 0;
		out_no = 0;	
	end
	end
endmodule