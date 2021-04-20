module CONVERT_BIT(
	input wire clk,
//	input wire reset,
	input wire in_bit,
	
	output reg [7:0]OUT_RGB
	
	);
	
parameter[7:0] RGB1 = 8'd255;
parameter[7:0] RGB2 = 8'd0;
	
always @ (posedge clk)
	begin
		if (in_bit == 1)
			OUT_RGB = RGB1;
		else
			OUT_RGB = RGB2;
	end
endmodule