module main (
			input clk,
			input button,
			output wire [3:0] rowwrite,
			input [3:0] colread,
			output wire [3:0] grounds,
			output wire [6:0] display
			);
		
localparam	KEYPAD_CHK = 16'h0000,
				KEYPAD_DAT = 16'h0000,
				SEVENSEG	  = 16'h0000,
				BUTTON	  = 16'h0000;

reg [15:0] memory [0:255];
				
		
reg [15:0] seven_seg_data;

//Keypads inputs and outputs
wire [15:0] keypad_out;
reg keypad_ack;
reg statusordata;

//Timers inputs and outputs
wire [15:0] timer_out;
reg timer_ack;
reg timeorready;

sevensegment ss1 (.datain(seven_seg_data), .grounds(grounds), .display(display), .clk(clk));

keypad  kp1(.rowwrite(rowwrite), .colread(colread), .clk(clk), .ack(keypad_ack), .statusordata(statusordata), .keyout(keypad_out));

timer tm1(.clk(clk), .ack(timer_ack), .button(button), .timeorready(timeorready), .out(timer_out));

bird_extended br1 (.clk(clk), .data_in(data_in), .data_out(data_out), .address(address), .memld(memld));

initial 
	begin
		seven_seg_data=0;
		keypad_ack=0;
		statusordata=0;
		$readmemh("ram.dat", memory);
	end
 
endmodule