module Mean_Array(
	input wire EN,
	input wire EN_RES,
	input wire [9:0]X,
	input wire [7:0]Sum_in,
	
	output reg [7:0]Mean);
	
reg [16:0]SUM;
	
always @(X, Sum_in)
	begin
		if (EN == 1)
		begin
			SUM = SUM + Sum_in;
			if ((EN == 1)&&(EN_RES == 1))
			Mean = SUM / X;
		end
	end
	
endmodule