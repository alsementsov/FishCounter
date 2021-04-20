module	Reset_Delay(iCLK,iRST,RST_0,RST_1,RST_2,RST_3);
input		iCLK;
input		iRST;
output reg	RST_0;
output reg	RST_1;
output reg	RST_2;
output reg	RST_3;

reg	[22:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Cont	<=	0;
		RST_0	<=	0;
		RST_1	<=	0;
		RST_2	<=	0;
		RST_3	<=	0;
	end
	else
	begin
		if(Cont!=23'h4FFFFF)
			Cont	<=	Cont+1;
			
		if(Cont>=23'h1FFFFF)
			RST_0	<=	1;
		if(Cont>=23'h2FFFFF)
			RST_1	<=	1;
		if(Cont>=23'h3FFFFF)
			RST_2	<=	1;
		if(Cont>=23'h4FFFFF)
			RST_3	<=	1;			
			
	end
end

endmodule