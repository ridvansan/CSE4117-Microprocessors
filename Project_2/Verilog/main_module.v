//Main module
 
 
module main_module (
			output wire [3:0] rowwrite,
			input [3:0] colread,
			input clk,
			output wire [3:0] grounds,
			output wire [6:0] display,
			input pushbutton //may be used as clock
			);
 
reg [15:0] seven_seg_data;
wire [3:0] keyout;
reg [25:0] clk1;
reg [1:0] ready_buffer;
reg ack;
reg statusordata;
 
//memory map is defined here
localparam	BEGINMEM=	16'h0000,	//start of memory
			ENDMEM= 	16'hffff,	
			KEYPAD_CHK= 16'hfff0,
			KEYPAD_DAT= 16'hfff1,
			SEVENSEG=	16'hfff4;

//  memory chip
reg [15:0] memory [0:65535]; //0 to 0xffff
 
// cpu's input-output pins
wire [15:0] data_out;
reg [15:0] data_in;
wire [11:0] address;
wire memld;
 
 
sevensegment ss1 (.datain(seven_seg_data), .grounds(grounds), .display(display), .clk(clk));
 
keypad  kp1(.rowwrite(rowwrite), .colread(colread), .clk(clk), .ack(ack), .statusordata(statusordata), .keyout(keyout));
 
bird_extended br1 (.clk(clk), .data_in(data_in), .data_out(data_out), .address(address), .memld(memld));
 
//multiplexer for cpu input
always @*
	if ( (BEGINMEM<=address) && (address<=ENDMEM) )
		begin
			if (address==KEYPAD_CHK)
				begin
					//to be added 
					statusordata=0;
					data_in=rowwrite; //emin degilim sadece guess
					ack=1;
				end
			else if (address==KEYPAD_DAT)
				begin
					statusordata=1;
					data_in=keyout;
					ack=0;
				end
			else
				begin
					data_in=memory[address];
					ack=0;
					statusordata=0;
				end
		end
 
//multiplexer for cpu output 
always @(posedge clk) //data output port of the cpu
	if (memld)
		if ( (BEGINMEM<=address) && (address<=ENDMEM) )
			begin
				if (SEVENSEG==address)
					begin
						seven_seg_data<=data_out;
					end 
				else
					begin
						memory[address]<=data_out;
					end
			end
		

initial 
	begin
		seven_seg_data=0;
		ack=0;
		statusordata=0;
		$readmemh("ram.dat", memory);
	end
 
endmodule