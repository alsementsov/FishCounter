module draw_point(
input wire clk,
input wire [10:0] x,
input wire [9:0] y,
input wire [10:0]countx,
input wire [9:0]county,
output reg out_point);

	parameter[10:0]ffx = 11'd3;
	parameter[10:0]xfx = 11'd6;
	parameter[9:0]ffy = 10'd40;
	parameter[9:0]yfy = 10'd43;

always @ (posedge clk)
	begin					
	if  (((countx >= x)&&(countx <= (x+ffx)))&&((county >= (y+ffy))&&(county <= (y+yfy)))) 	
		begin
			out_point = 1;
		end
		else 
			out_point = 0;				
	end
endmodule