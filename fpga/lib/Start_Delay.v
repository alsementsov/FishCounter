module	Start_Delay(CLK,RST,reset_n);
input		CLK;
input		RST;
output reg	reset_n;


reg	[9:0]	Cont;

always@(posedge CLK or posedge RST)
begin
	if(RST)
	begin
		Cont	<=	0;
		reset_n	<=	0;
	end
	else
	begin
		if(Cont!=10'h3FF)
			Cont	<=	Cont+1;
			
		if(Cont==10'h3FE)
			reset_n	<=	1;

	end
end

endmodule