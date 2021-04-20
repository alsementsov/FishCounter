module SW_MASS(
	input wire clk,
//	input wire reset,
	
	input wire twfi,
	input wire fiei,
	input wire eion,
	
	output reg [1:0]sw_mass_out
	
	);

always @ (posedge clk)
	begin
		if (twfi == 1)
				sw_mass_out = 1;
		else
		begin
			if (fiei == 1)
				sw_mass_out = 2;
			else
			begin
				if (eion == 1)
					sw_mass_out= 3;
				else
					sw_mass_out = 0;
			end
		end
	end
endmodule