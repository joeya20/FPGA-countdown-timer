module top (
	input 			MAX10_CLK1_50,
	input	[9:0]	SW,
	input	[1:0]	KEY,
	output 	[7:0]	HEX0,
	output 	[7:0]	HEX1,
	output 	[7:0]	HEX2,
	output 	[7:0]	HEX3,
	output	[9:0]	LEDR
);

wire
	PB0_read,	//high if PB0 is read successfully in countdown timer
	PB1_read,	//high if PB0 is read successfully in countdown timer
	finish_flag,//high when countdown is finished
	led,		//blinks leds at 50% duty cycle and 1hz freq
	PB0_flag,	//high when PB0 is pushed and low when PB0_read is high
	PB1_flag;	//high when PB0 is pushed and low when PB1_read is high

wire [7:0] tmr_out_min;
wire [7:0] tmr_out_sec;
wire [11:0] tmr_out_min_bcd;
wire [11:0] tmr_out_sec_bcd;

wire rst_n = ~SW[0];	//active low enable

countdown_timer timer(
	.*,
	.clk(MAX10_CLK1_50)
);

bin_to_bcd bcd_encoder_sec(
	.bin(tmr_out_sec),
	.out(tmr_out_sec_bcd)
);

bin_to_bcd bcd_encoder_min(
	.bin(tmr_out_min),
	.out(tmr_out_min_bcd)
);

LED_blinker blinker(
	.*,
	.clk(MAX10_CLK1_50),
	.enable(finish_flag)
);

sev_seg_decoder sec_0(
	.bcd(tmr_out_sec_bcd[3:0]),
	.sev_seg(HEX0),
	.dp(1'b0)
);

sev_seg_decoder sec_1(
	.bcd(tmr_out_sec_bcd[7:4]),
	.sev_seg(HEX1),
	.dp(1'b0)
);

sev_seg_decoder min_0(
	.bcd(tmr_out_min_bcd[3:0]),
	.sev_seg(HEX2),
	.dp(1'b1)
);

sev_seg_decoder min_1(
	.bcd(tmr_out_min_bcd[7:4]),
	.sev_seg(HEX3),
	.dp(1'b0)
);


PB_state read_PBs(
	.*,
	.clk(MAX10_CLK1_50),
	.PB0(KEY[0]),
	.PB1(KEY[1])
);

assign LEDR = {10{led}};

endmodule