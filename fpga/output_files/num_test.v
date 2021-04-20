module num_test(
	input wire clk,	

	input wire [10:0]tv_x,
	input wire [9:0]tv_y,
	output reg out 
	);


always @(posedge clk )

	if((tv_x == 100)&&(tv_y == 10)) 
	begin		
		out <= 1;
	end 
	else begin
		out <= 0;
	end
	
endmodule	