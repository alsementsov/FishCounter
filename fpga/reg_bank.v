module reg_bank(
	input wire [7:0] DIN,
	input wire RG1,RG2,RG3,
	input wire RST,CLK,
	
	output wire [7:0] DREG1,
	output wire [5:0] DREG2,
	output wire [3:0] DREG3	
	);
	
	dreg Reggister_1 (DIN, DREG, RG1, RST, CLK);
	dreg #( 6) Reggister_2 (DIN[5:0], DREG, RG1, RST, CLK);
	dreg #( 4) Reggister_3 (DIN[3:0], DREG, RG1, RST, CLK);
	
//	dreg #( 4) Reggister_3 (.CLK(CLK), .RST(RST), .DIN(DIN[3:0]), DOUT(DREG3), .CE(RG3));
	
endmodule 