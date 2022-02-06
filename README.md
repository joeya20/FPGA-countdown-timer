# FPGA-countdown-timer

Project completed using SystemVerilog

This project is a countdown timer, completed using the Terasic DE10-Lite FPGA board. The user can select a desired time in minutes and begin a countdown.

The timer uses two pushbuttons, one as start/stop and the other as increment. The timer can only be incremented when it is stopped (not counting down).

The current value of the timer is displayed on 4 seven segment displays, 2 for seconds and 2 for minutes. The display is updated every second when the countdown is active. When the end of the timer is reached, an array of LEDs blinks at a 50% duty cycle and a 1Hz frequency. The pushbuttons can be pressed again to re-increment the timer or go back to idle.

The main timer functionality was implemented using an FSM (my first one, yay!) and has seperate next state, timer and output logic processes.
