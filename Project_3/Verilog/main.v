module main (
			input clk,
			input button,
			output wire [3:0] rowwrite,
			input [3:0] colread,
			output wire [3:0] grounds,
			output wire [6:0] display
			);
		
localparam	KEYPAD_CHK = 16'h00fc,
				KEYPAD_DAT = 16'h00fd,
				SEVENSEG	  = 16'h00fe,
				TIMER_CHK  = 16'h00ff,
				TIMER_DAT  = 16'h00fb;

reg [15:0] memory [0:255];
				
		
reg [15:0] seven_seg_data;

//Cpu variables
wire [15:0] data_out;
reg [15:0] data_in;
wire [15:0] address;
wire memld;

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

always @* begin
	if(address == KEYPAD_CHK)
		begin
			statusordata<=1;
			data_in<=keypad_out;
			keypad_ack<=0;
		end
	else if(address == KEYPAD_DAT)
		begin
			statusordata<=0;
			data_in<=keypad_out;
			keypad_ack<=1;
		end
	else if(address == TIMER_CHK)
		begin
			timeorready<=1;
			data_in<=timer_out;
			timer_ack<=0;
		end
	else if(address == TIMER_DAT)
		begin
			timeorready<=0;
			data_in<=timer_out;
			timer_ack<=1;
		end
	else
		begin
			data_in<=memory[address];
			timer_ack=0;
			keypad_ack=0;
			statusordata=0;
			timeorready<=0;
		end
end

//multiplexer for cpu output 
always @(posedge clk) //data output port of the cpu
	if (memld)
		if (SEVENSEG==address)
			begin
				seven_seg_data<=data_out;
			end 
		else
			begin
				memory[address]<=data_out;
			end

initial 
	begin
		seven_seg_data=0;
		keypad_ack=0;
		timer_ack=0;
		statusordata=0;
		timeorready=0;
		$readmemh("ram.dat", memory);
	end
 
endmodule