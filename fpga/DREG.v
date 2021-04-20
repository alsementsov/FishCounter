module dreg(
	output reg [NBRB-1:0] DIN,
	input wire CE,
	input wire	RST, 
	input wire	CLK,	
	output reg [NBRB-1:0] DOUT
	);
	
parameter NBRB = 8;
	
always @(posedge CLK or posedge RST)
	begin
		if(RST == 1)
			DOUT <= 0;
		else if(CE == 1)
			DOUT <= DIN;
	end
	
endmodule 