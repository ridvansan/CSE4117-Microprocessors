module timer (
                input clk,
					 input ack,
					 input button,
					 input timeorready,
					 output reg [15:0] out
             );

localparam tickrate = 32'h2FAF080; //tickrate for 50mhz.
reg [32:0] tick;
reg [15:0] time_dat;
reg [15:0] timee;
reg ready;

always @(posedge clk) begin
    tick = tick + 1;
	 if(tick == tickrate)
		begin
			time_dat = time_dat + 1;
			tick = 0;
		end
end

always @(posedge clk) begin
	if((button == 0) && (ready == 0))
		begin
			timee <= time_dat;
			ready <= 1;
		end
	else if (ack == 1)
		begin
			ready <= 0;
		end
end


always @* begin
	if(timeorready == 0)
		begin
			out = time_dat;
		end
	else
		begin
			out = {15'b0,ready};
		end
end

initial
	begin
		tick = 0;
		time_dat = 0;
		timee = 0;
	end

endmodule