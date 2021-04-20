module draw_num_com_mass_2(
input wire clk,
input wire reset,
input wire [29:0] mark,
input wire [10:0] x,
input wire [9:0] y,
input wire [10:0]countx,
input wire [9:0]county,
output reg check);

	parameter[10:0]ffx = 11'd3;
	parameter[10:0]xfx = 11'd10;
	parameter[10:0]fxx = 11'd13;
	parameter[9:0]ffy = 10'd3;
	parameter[9:0]yfy = 10'd20;
	parameter[9:0]fyy = 10'd23;
	parameter[9:0]yyf = 10'd40;
	parameter[9:0]yyy = 10'd43;

reg box1 = 0;	
reg box2 = 0;
reg box3 = 0;
reg box4 = 0;
reg box5 = 0;
reg box6 = 0;
reg box7 = 0;

reg choise = 0;





always @ (posedge clk)
	begin
				
			begin						

				if  (((countx >= x)&&(countx <= (x+ffx)))&&((county >= y)&&(county <= (y+fyy)))) 	
						begin
							box1 = 1;
						end
						else box1 = 0;
					
					
				if  ((countx >= (x)&&(countx <= (x+fxx)))&&((county >= (y))&&(county <= (y+ffy)))) 	
					begin
						box2 = 1;
					end
					else box2 = 0;	
					
					
					if  (((countx >= (x+xfx))&&(countx <= (x+fxx)))&&((county >= (y))&&(county <= (y+fyy)))) 	
					begin
						box3 = 1;
					end
					else box3 = 0;	
					
					
					if  (((countx >= (x))&&(countx <= (x+ffx)))&&((county >= (y+yfy))&&(county <= (y+yyy)))) 	
					begin
						box4 = 1;
					end
					else box4 = 0;	
					
					
					if  (((countx >= (x+xfx))&&(countx <= (x+fxx)))&&((county >= (y+yfy))&&(county <= (y+yyy)))) 	
					begin
						box5 = 1;
					end
					else box5 = 0;	
					
					
					if  (((countx >= (x))&&(countx <= (x+fxx)))&&((county >= (y+yyf))&&(county <= (y+yyy)))) 	
					begin
						box6 = 1;
					end
					else box6 = 0;	
					
					
					if  (((countx >= (x))&&(countx <= (x+fxx)))&&((county >= (y+yfy))&&(county <= (y+fyy)))) 	
					begin
						box7 = 1;
					end
					else box7 = 0;	
					
					// Settings of Drawing
					
					if (mark == 0)
						begin
							box7 = 0;
							
						end;
					
					if (mark == 1)
						begin
							box1 = 0;
							box2 = 0;
							box4 = 0;
							box6 = 0;
							box7 = 0;
							
						end;
						
						if (mark == 2)
						begin
							box1 = 0;
					
							box5 = 0;
							
						end;
						
						if (mark == 3)
						begin
							box1 = 0;
							
							box4 = 0;
							
						end;
						
						if (mark == 4)
						begin
							
							box2 = 0;
							
							box4 = 0;
							
							box6 = 0;
						end;
						
						if (mark == 5)
						begin
							
							box3 = 0;
							box4 = 0;
							
						end;
						
						if (mark == 6) 
						begin
							
							box3 = 0;
							
						end;
						
						if (mark == 7) 
						begin
							box1 = 0;
							
							box4 = 0;
							
							box6 = 0;
							box7 = 0;
						end;
						
						
						if (mark == 9) 
						begin
							
							box4 = 0;
							
						end;
					
					if(box1 || box2 || box3 || box4 || box5 || box6 || box7)
						begin
							check <= 1;
						end
					else
						begin
							check <= 0;
						end;	
											
					
			end;
	end
endmodule