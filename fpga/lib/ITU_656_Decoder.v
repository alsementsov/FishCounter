module	ITU_656_Decoder(	//	TV Decoder Input
							iTD_DATA,
							//	Position Output
							oTV_X,
							oTV_Y,
							oTV_Cont,
							//	YUV 4:2:2 Output
							oYCbCr,
							oDVAL,
							oField,
							oTV_Cont_Lin,
							oTV_Y_Lin,
							//	Control Signals
							iSwap_CbCr,
							iSkip,
							iRST_N,
							iCLK_27	);
input	[7:0]	iTD_DATA;
input			iSwap_CbCr;
input			iSkip;

input			iRST_N;
input			iCLK_27;
output	[15:0]	oYCbCr;
output	[9:0]	oTV_X;
output	[9:0]	oTV_Y;
output	[10:0] oTV_Y_Lin;
output	[31:0]	oTV_Cont;
output	[20:0]	oTV_Cont_Lin;
output			oDVAL;
output			oField;

//	For detection
reg		[23:0]	Window;		//	Sliding window register
reg		[17:0]	Cont;		//	Counter
reg				Active_Video;
reg				Start;
reg				Data_Valid;
reg				Pre_Field;
reg				Field;
wire			SAV;
reg				FVAL;
reg		[9:0]	TV_Y;
wire		[10:0]	TV_Y_1;
wire		[10:0]	TV_Y_2;
reg		[31:0]	Data_Cont;
reg		[20:0]	Data_Cont_Lin;

//	For ITU-R 656 to ITU-R 601
reg		[7:0]	Cb;
reg		[7:0]	Cr;
reg		[15:0]	YCbCr;

assign	oTV_X	=	Cont>>1;
assign	oTV_Y	=	TV_Y;
assign	oYCbCr	=	YCbCr;
assign	oDVAL	=	Data_Valid;
assign	oField	=	Field;
assign	SAV		=	(Window==24'hFF0000)&(iTD_DATA[4]==1'b0);
assign	oTV_Cont=	Data_Cont;

assign	TV_Y_1 = 2*TV_Y;
assign	TV_Y_2 = TV_Y_1 + Field;
assign	oTV_Y_Lin = (TV_Y_2 - 2);

assign	oTV_Cont_Lin = Data_Cont_Lin;
		
always@(posedge iCLK_27 or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		//	Register initial
		Active_Video<=	1'b0;
		Start		<=	1'b0;
		Data_Valid	<=	1'b0;
		Pre_Field	<=	1'b0;
		Field		<=	1'b0;
		Window		<=	24'h0;
		Cont		<=	18'h0;
		Cb			<=	8'h0;
		Cr			<=	8'h0;
		YCbCr		<=	16'h0;
		FVAL		<=	1'b0;
		TV_Y		<=	10'h0;
		Data_Cont	<=	32'h0;
	end
	else
	begin
		//	Sliding window
		Window	<=	{Window[15:0],iTD_DATA};
		//	Active data counter
		if(SAV)
		Cont	<=	18'h0;
		else if(Cont<1440)
		Cont	<=	Cont+1'b1;
		//	Check the video data is active?
		if(SAV)
		Active_Video<=	1'b1;
		else if(Cont==1440)
		Active_Video<=	1'b0;
		
		//	Is frame start?
		Pre_Field	<=	Field;
		if({Pre_Field,Field}==2'b10)
		begin
			Start		<=	1'b1;
			Data_Cont	<=	0;
		end
		//	Field and frame valid check
		if(Window==24'hFF0000)
		begin
			FVAL	<=	!iTD_DATA[5];
			Field	<=	iTD_DATA[6];
		end
		//	ITU-R 656 to ITU-R 601
		if(iSwap_CbCr)
		begin
			case(Cont[1:0])		//	Swap
			0:	Cb		<=	 iTD_DATA;
			1:	YCbCr	<=	{iTD_DATA,Cr};
			2:	Cr		<=	 iTD_DATA;
			3:	YCbCr	<=	{iTD_DATA,Cb};
			endcase
		end
		else
		begin
			case(Cont[1:0])		//	Normal
			0:	Cb		<=	 iTD_DATA;
			1:	YCbCr	<=	{iTD_DATA,Cb};
			2:	Cr		<=	 iTD_DATA;
			3:	YCbCr	<=	{iTD_DATA,Cr};
			endcase
		end
		//	Check data valid
		if(		Start				//	Frame Start?
			&& 	FVAL				//	Frame valid?
			&& 	Active_Video		//	Active video?
			&& 	Cont[0]				//	Complete ITU-R 601?
			&& 	!iSkip	)			//	Is non-skip pixel?
		Data_Valid	<=	1'b1;
		else
		Data_Valid	<=	1'b0;
		//	TV decoder line counter for one field
		if(FVAL && SAV) //Frame valid
		TV_Y<=	TV_Y+1;
		if(!FVAL)
		TV_Y<=	0;
		
		//	Data counter for one field
//		if(!FVAL) //Frame valid
//		Data_Cont	<=	0;

		Data_Cont_Lin <= ((TV_Y_2-2'd2)*11'd720) + oTV_X;
		
		if(Data_Valid)
		begin
			Data_Cont	<=	Data_Cont+1'b1;
		end
		
	end
end

endmodule