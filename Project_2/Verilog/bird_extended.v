module bird_extended (
		input clk,
		input [15:0] data_in,
		output reg [15:0] data_out,
		output reg [15:0] address,
		output memld
		);
 
reg [15:0] pc; //program counter
reg [11:0] ir; //instruction register
 
reg [4:0] state; //FSM
reg [15:0] regbank [7:0];//registers 
reg zeroflag; //zero flag register
reg [15:0] result; //output for result
 
 
localparam	FETCH=4'b0000,
			LDI=4'b0001, 
			LD=4'b0010,
			ST=4'b0011,
			JZ=4'b0100,
			JMP=4'b0101,
			ALU=4'b0111,
			PUSH=4'b1000,
			POP1=4'b1001,
			POP2=4'b1100,
			CALL=4'b1010,
			RET1=4'b1011,
			RET2=4'b1101;
 
 
wire zeroresult;
assign sp = regbank[7]

always @(posedge clk)
	case(state) 
		FETCH: 
			begin
				if ( data_in[15:12]==JZ) // if instruction is jz  
					if (zeroflag)  //and if last bit of 7th register is 0 then jump to jump instruction state
						state <= JMP;
					else
						state <= FETCH; //stay here to catch next instruction
			else
				state <= data_in[15:12]; //read instruction opcode and jump the state of the instruction to be read
				ir<=data_in[11:0]; //read instruction details into instruction register
				pc<=pc+1; //increment program counter
			end
 
		LDI:
			begin
				regbank[ir[2:0]] <= data_in; //if inst is LDI get the destination register number from ir and move the data in it.
				pc<=pc+1; //for next instruction (32 bit instruction)  
				state <= FETCH;
			end
 
		LD:
			begin
				regbank[ir[2:0]] <= data_in;
				state <= FETCH;  
				end 
 
		ST:
			begin
				state <= FETCH;  
			end
 
		JMP:
			begin
				pc <= pc + data_in;
				state <= FETCH;  
			end
 
		ALU:
			begin
				regbank[ir[2:0]]<=result;
				zeroflag<=zeroresult;
				state <= FETCH;
			end
 
		PUSH:
			begin
				 sp <= sp - 1;
				 state <= FETCH;
			end
 
		POP1:
			begin
				sp <= sp + 1;
				state <= POP2;
			end
 
		POP2: 
			begin
				regbank[ir[2:0]] <= data_in;
				state <= FETCH;
			end
 
		CALL: 
			begin
			    sp <= sp - 1;
				state <= JMP;
			end
 
		RET1:
			begin
				sp <= sp + 1;
				state <= RET2;
			end
 
		RET2:
			begin
				state <= FETCH;
			end
	endcase

//Determining the ADDR_OUT (ARMUX in logisim)
always @* //ADDR_OUT
	case (state)
		LD:     address=regbank[ir[5:3]][15:0];
		ST:	    address=regbank[ir[5:3]][15:0];
		PUSH:	address=sp;
		CALL:	address=sp;
		POP2:	address=sp;
		RET2:	address=sp;
		default: address=pc;
	endcase
 
//Memory load operands
assign memld = (state==ST) || (state == CALL) || (state == PUSH)

//Determining the DATA_OUT (DATAMUX in logisim)
always @*
	case (state)
		CALL: data_out = pc;
		default: data_out = regbank[ir[8:6]];
	endcase

//Determining the PC input (PCMUX in logisim)
always @*
	case (state)
		RET2: pc = data_in;
		default: pc = pc + 1; //Can cause error.
	endcase


always @* //ALU Operation
	case (ir[11:9])
		3'h0: result = regbank[ir[8:6]]+regbank[ir[5:3]]; //000
		3'h1: result = regbank[ir[8:6]]-regbank[ir[5:3]]; //001
		3'h2: result = regbank[ir[8:6]]&regbank[ir[5:3]]; //010
		3'h3: result = regbank[ir[8:6]]|regbank[ir[5:3]]; //011
		3'h4: result = regbank[ir[8:6]]^regbank[ir[5:3]]; //100
		3'h7: case (ir[8:6])
			3'h0: result = !regbank[ir[5:3]];
			3'h1: result = regbank[ir[5:3]];
			3'h2: result = regbank[ir[5:3]]+1;
			3'h3: result = regbank[ir[5:3]]-1;
			default: result=16'h0000;
		     endcase
		default: result=16'h0000;
	endcase

assign zeroresult = ~|result;
 
initial begin;
	state=FETCH;
	zeroflag=0;
	pc=0;
end
 
endmodule