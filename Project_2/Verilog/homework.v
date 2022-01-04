module input_selector (
    ports
);
    
endmodule

module project_2 (
    input[15:0] Pin_1,
    input PB_1,
    input[15:0] Pin_2,
    input PB_2,
);

//CPU Components
wire     [15:0] DATA_OUT;
wire     [15:0] DATA_IN;
wire     [15:0] ADDR_OUT;
wire     MEMLD;


reg[15:0] 7-segment_register;
reg [15:0] MEM [0:65535]; 

assign CS = |ADDR_OUT[15:2];
assign ADDR_0 = ADDR_OUT[0];
assign ADDR_1 = ADDR_OUT[1];
assign seven_seg_ld = |ADDR_OUT[15:3] & ADDR_OUT[2] & ADDR_OUT[1:0] //düzgün mü testi




bird_extended(.DATA_OUT(DATA_OUT),.DATA_IN(DATA_IN),.ADDR_OUT(ADDR_OUT),.MEMLD(MEMLD))
seven_segent_display()

assign IN_1_OUT = 
assign IN_2_OUT = 

assign DATA_IN = CS ? (ADDR_1 ? (IN_1_OUT): (IN_2_OUT) ) : (MEM[ADDR_OUT]);

always @(posedge clk)
	if (MEMLD)
		MEM[ADDR_OUT]<=DATA_OUT;

initial begin
		$readmemh("ram.dat", MEM);
end
endmodule