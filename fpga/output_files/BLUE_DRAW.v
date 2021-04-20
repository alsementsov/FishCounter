module BLUE_DRAW(
	input wire clk,

	input wire [10:0]in_x,
	input wire [9:0]in_y,

	
	output reg blue_en
	
	);
	
parameter[10:0] x1 = 11'd340;
parameter[10:0] x2 = 11'd400;
parameter[9:0] y1 = 10'd10;
parameter[9:0] y2 = 10'd110;


always @ (posedge clk)
	begin
		if ((in_x[10:0]>=x1)&&(in_x[10:0]<=x2)&&(in_y[9:0]>=y1)&&(in_y[9:0]<=y2))
				blue_en = 1;
		else
				blue_en = 0;
	end	
endmodule