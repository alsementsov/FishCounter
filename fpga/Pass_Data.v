module Pass_Data(
	input wire field,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	
	input wire [9:0]x1_0,
	input wire [9:0]y1_0,
	input wire [9:0]x2_0,
	input wire [9:0]y2_0,		
	
	output reg pass,
	output reg [9:0]pass_x,
	output reg [9:0]pass_y,
	output reg end_field
	);


always @(tv_x,tv_y)
	begin
		if (field == 1)
		begin
			if ((tv_x >= x1_0)&&(tv_x <= x2_0)&&(tv_y >= y1_0)&&(tv_y <= y2_0))
			begin
				pass_x = tv_x - x1_0;
				pass_y = tv_y;
				pass = 1;	
			end
			else
			begin
				pass_x = 0;
				pass_y = 0;
				pass = 0;
			end
			if (tv_y > (y2_0 + 4))
				end_field = 1;
			else
				end_field = 0;
		end
	end 
endmodule