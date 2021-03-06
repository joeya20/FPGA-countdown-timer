module sev_seg_decoder (
	input		 	dp,
	input 	[3:0]	bcd,
	output	[7:0]	sev_seg
);

logic [6:0] val;

always_comb begin
	case(bcd)
		4'b0000 : val = 7'b1000000;
		4'b0001 : val = 7'b1111001;
		4'b0010 : val = 7'b0100100;			//active low
		4'b0011 : val = 7'b0110000;			// --0--    
		4'b0100 : val = 7'b0011001;			//|     |
		4'b0101 : val = 7'b0010010;			//5     1  
		4'b0110 : val = 7'b0000010;			//|     |   
		4'b0111 : val = 7'b1111000;			// --6--   
		4'b1000 : val = 7'b0000000;			//|     |  
		4'b1001 : val = 7'b0010000;			//4     2
		4'b1010 : val = 7'b0001000;			//|     |
		4'b1011 : val = 7'b0000000;			// --3--  .7
		4'b1100 : val = 7'b1000110;			
		4'b1101 : val = 7'b1000000;
		4'b1110 : val = 7'b0000110;
		4'b1111 : val = 7'b0001110;
	endcase
end

assign sev_seg = {~dp, val};
	
endmodule