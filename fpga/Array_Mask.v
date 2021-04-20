module Array_Mask(
	input wire clk,
	input wire [9:0]X,
	input wire Mask,
	input wire [7:0]Sum_in,
	
	output reg [7:0]Sum_out);
	
always @(posedge clk)
	begin
		if (Mask == 1)
			Sum_out = Sum_in + 1;
		else
			Sum_out = Sum_in;
	end
	
endmodule