



module my_test3(
	input wire a,b,clk, 
	output reg c
	);

	always @(posedge clk)
	begin
		c <= a && b;
	end
	
endmodule 

