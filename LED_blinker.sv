
module LED_blinker #(parameter MAX_COUNT_1Hz = 25_000_000) (
	input 	clk,
	input 	enable,
	input	rst_n,
	output	led
);

//counter
logic [31:0] count;

//LED toggle signal
logic toggle;

always_ff @( posedge clk or negedge rst_n ) begin		
	//increment counter and toggle LED and roll over if max count is reached
	if(!rst_n) begin
		toggle <= 0;
		count <= 0;
	end else if(count == MAX_COUNT_1Hz-1) begin
		toggle <= !toggle;
		count <= 0;
	end else begin
		count <= count + 1;
	end
end

assign led = toggle & enable;

endmodule