module countdown_timer #(parameter CLK_FREQ = 50_000_000) (
    input           clk,
    input           rst_n,  //active low reset
    input           PB0_flag,
    input           PB1_flag,
    output          PB0_read,   //gets asserted when PB0 is read high to drive PB0 low
    output          PB1_read,   //gets asserted when PB1 is read high to drive PB1 low
    output  [7:0]   tmr_out_sec,
    output  [7:0]   tmr_out_min,
    output          finish_flag
);

//state encoding
enum logic [3:0] {
    IDLE,
    INCREMENT,
    ACTIVE,
    DECREMENT,
    FINISH
} current_state, next_state;

// main countdown timers
logic [7:0] tmr_sec;
logic [7:0] tmr_min;

//counter
logic [31:0] counter;

//flag is asserted when tmr needs to be decremented
logic decrement_flag;

always_ff @( posedge clk or negedge rst_n ) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// next state logic
always_comb begin : next_state_logic
    PB0_read = 0;
    PB1_read = 0;
    next_state = current_state;
    unique case (current_state)
        IDLE : begin
            if (PB0_flag) begin
                next_state = INCREMENT;
                PB0_read = 1;
            end else if (PB1_flag) begin
                next_state = ACTIVE;
                PB1_read = 1;
            end else begin
                next_state = IDLE;
            end
        end
        INCREMENT : next_state = IDLE;
        ACTIVE : begin
            if (PB1_flag) begin
                next_state = IDLE;
                PB1_read = 1;
            end else if (tmr_out_min == 0 && tmr_out_sec == 0) begin
                next_state = FINISH;
            end else if (decrement_flag) begin
                next_state = DECREMENT;
            end else begin
                next_state = ACTIVE;
            end
        end
        DECREMENT : next_state = ACTIVE;
        FINISH : begin
            if (PB0_flag) begin
                next_state = INCREMENT;
                PB0_read = 1;
            end else if (PB1_flag) begin
                next_state = IDLE;
                PB1_read = 1;
            end else begin
                next_state = FINISH;
            end
        end
    endcase
end : next_state_logic

// timer logic
always_ff @( posedge clk ) begin : timer_logic
    unique case (current_state)
        IDLE : begin
            finish_flag <= 0;
            counter <= 0;
        end
        INCREMENT : begin
            finish_flag <= 0;
            if(tmr_min == 99) begin
                tmr_min <= 0;
            end else begin
                tmr_min <= tmr_min + 1;
            end
        end
        ACTIVE : begin
            if(counter == (CLK_FREQ-2)) begin  //minus 2 instead of 1 because 1 clk cycle is need to go DECREMENT state
                decrement_flag <= 1;
                counter <= 1;   //set to 1 because it will take 1 clk cycle to come back to active after decrement
            end else begin
                counter <= counter + 1;
            end
        end
        DECREMENT : begin
            if(tmr_sec == 0) begin  //if sec = 0, decrement min and roll over to 59
                tmr_sec <= 59;
                tmr_min <= tmr_min - 1;
            end else begin
                tmr_sec <= tmr_sec - 1;
            end
            decrement_flag <= 0;
        end
        FINISH : begin
            finish_flag <= 1;
        end
    endcase
end : timer_logic

//output logic
assign tmr_out_min = tmr_min;
assign tmr_out_sec = tmr_sec;

endmodule