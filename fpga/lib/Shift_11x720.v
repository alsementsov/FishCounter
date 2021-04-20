module shift_11x720 				(clk, 
				sr_in_1,
				sr_in_0,	
				sel,				
				shift,				
				sr_out_720
		 		);
  
	input clk, shift, sel;
	input [10:0] sr_in_0, sr_in_1;
	
	output [10:0]  sr_out_720;

	reg [10:0] sr [720:0];
	integer n;

 	always@(posedge clk)
	begin
		if (shift == 1'b1)
		begin
			for (n = 720; n>0; n = n-1)
			begin
				sr[n] <= sr[n-1];
			end 
			
			if(sel == 0)
				sr[0] <= sr_in_0;
			else
				sr[0] <= sr_in_1;
				
		end 
	end 


	assign sr_out_720 = sr[720];
	
endmodule
