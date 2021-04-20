



module my_test(
	input wire a,b,
	output reg c
	);

	always @(a or b)
	begin
		c = a && b;
	end
	
endmodule 

