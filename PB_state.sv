module PB_state (
	input clk,
	input rst_n,
	input PB0,
	input PB1,
	input PB0_read,
	input PB1_read,
	output PB0_flag,
	output PB1_flag
);

logic PB0_old, PB1_old;

always_ff @( posedge clk or negedge rst_n ) begin

	if (!rst_n) begin
		PB0_old <= 0;
		PB1_old <= 0;
		PB0_flag <= 0;
		PB1_flag <= 0;
	end else begin
		PB0_old <= PB0;
		PB1_old <= PB1;

		if(PB0_old == 1 && PB0 == 0) begin
			PB0_flag <= 1;
		end else if (PB0_read == 1) begin
			PB0_flag <= 0;
		end

		if(PB1_old == 1 && PB1 == 0) begin
			PB1_flag <= 1;
		end else if (PB1_read == 1) begin
			PB1_flag <= 0;
		end
	end
end
	
endmodule