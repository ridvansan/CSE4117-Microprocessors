module bird_extended (
    input CLK,
    input [15:0] DATA_IN,
    output [15:0] DATA_OUT,
    output reg [15:0] ADDR_OUT,
    output MEMLD
);



reg [15:0] pc;
reg [12:0] ir;
reg [3:0] operation;
reg [15:0]register_bank[7:0];
reg [15:0]stack_pointer;
reg ZF;
assign src1 = ir[2:0];
//devam


localparam  FETCH=4'b0000,
            LDI=4'b0001, 
            LD=4'b0010,
            ST=4'b0011,
            JZ=4'b0100,
            JMP=4'b0101,
            ALU=4'b0111;
            PUSH=4'b1000;
            POP1=4'b1001;
            CALL=4'b1010;
            RET1=4'b1011;
            POP2=4'b1100;
            RET2=4'b1101;

always @(posedge clk ) begin
    case(operation)
        FETCH:
        begin
            if(operation==JZ)
                if(ZF)
                    operation<=JMP
                else
                    operation<=FETCH
            else
                operation <= DATA_IN[15:12]
                pc <= pc+1
                ir <= DATA_IN[11:0]
        end
        LDI:
        begin
            register_bank[ ir[2:0] ] <= data_in;
            pc<=pc+1;
            state <= FETCH;
        end
        LD:
        begin
            state <= FETCH;
        end

        ST:
        begin
            MEMLD <= 1
            DATA_OUT <= register_bank[src1]
            ADDR_OUT <= register_bank[src2]
            state <= FETCH;
        end
        
        JZ:
        begin
            if(ZF)
                state <= JMP;
            else
                state <= FETCH;
        end

        JMP:
        begin
            pc <= pc + DATA_IN
            state <= FETCH;
        end

        ALU:
        begin
            state <= FETCH;
        end

        PUSH:
        begin
            stack_pointer <= stack_pointer - 1;
            state <= FETCH;
        end

        POP1:
        begin
            stack_pointer <= stack_pointer + 1;
            state <= POP2;
        end

        CALL:
        begin
            stack_pointer <= stack_pointer - 1;
            ADDR_OUT <= stack_pointer;
            DATA_OUT <= pc;
            MEMLD = 1
            state <= JMP;
        end

        RET1:
        begin
            stack_pointer <= stack_pointer + 1;
            state <= RET2;
        end

        POP2:
        begin
            state <= FETCH;
        end

        RET2:
        begin
            pc <= DATA_IN
            state <= FETCH;
        end

end

endmodule