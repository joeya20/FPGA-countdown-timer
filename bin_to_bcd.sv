//This module uses the double dabble algorithm to convert an n-bit binary value into a bcd signal
//process:
// 1. Shift the binary value bit by bit
// 2. After shifting a bit, check every decimal digit in the BCD signal and add 3 if the value exceeds 4

module bin_to_bcd #(
	parameter BIN_WIDTH = 8,
	parameter DEC_DEGITS = 3
)(                                         
	input	[BIN_WIDTH-1:0] 		bin,
	output	[(DEC_DEGITS*4)-1:0]	out
);
	
//reg to store BCD value as bits are shifted from bin value
logic [(DEC_DEGITS*4)-1:0] bcd;

//reg to store bin index; hardcoded to max value of 7
logic [3:0] bin_index;

//reg to store dec index; hardcoded to max value of 3
logic [2:0] dec_index;

//reg to store current decimal value from BCD signal
logic [3:0] dec_val;

//when input bin value changes
always_comb begin

	//reset BCD signal
	bcd = 0;
	
	//loop to shift bits from bin signal to BCD signal
	for(bin_index = 0; bin_index < BIN_WIDTH; bin_index = bin_index + 1) begin
	
		//shift one bit over
		bcd = {bcd[0+:((DEC_DEGITS*4)-1)], bin[BIN_WIDTH-bin_index-1+:1]};
		
		//loop to check each if decimal digit in BCD signal is greater than 4; Don't check after last shift
		if(bin_index < BIN_WIDTH-1) begin
			for(dec_index = 0; dec_index < DEC_DEGITS; dec_index = dec_index + 1) begin
			
				dec_val = bcd[(dec_index*4)+:4];
				
				if(dec_val > 4) begin
					bcd[(dec_index*4)+:4] = dec_val + 3;
				end
			end
		end
	
	end
end

assign out = bcd;
	
endmodule