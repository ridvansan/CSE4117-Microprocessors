module sevensegment(datain, grounds, display, clk);

	input wire [15:0] datain;
	output reg [3:0] grounds;
	output reg [6:0] display;
	input clk;
	
	reg [3:0] data [3:0];
	reg [1:0] count;
	reg [25:0] clk1;
	
	always @(posedge clk1[15])
		begin
			grounds <= {grounds[2:0],grounds[3]};
			count <= count + 2'h1;
		end
	
	always @(posedge clk)
		clk1 <= clk1 + 16'h1;
	
	always @(*)
		case(data[count])	
			0:display=7'b0111111;
			1:display=7'b0000110;
			2:display=7'b1011011;
			3:display=7'b1001111;
			4:display=7'b1100110;
			5:display=7'b1101101;
			6:display=7'b1111101;
			7:display=7'b0000111;
			8:display=7'b1111111;
			9:display=7'b1101111;
			'ha:display=7'b1110111;
			'hb:display=7'b1111100;
			'hc:display=7'b0111001;
			'hd:display=7'b1011110;
			'he:display=7'b1111001;
			'hf:display=7'b1110001;
			default display=7'b1111111;
		endcase
	
	always @*
		begin
			data[0] = datain[15:12];
			data[1] = datain[11:8];
			data[2] = datain[7:4];
			data[3] = datain[3:0];
		end
	
	initial begin		
		count = 2'b0;
		grounds = 4'b1110;
		clk1 = 0;
	end
endmodule