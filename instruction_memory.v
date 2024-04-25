module instruction_memory(
 input[15:0] pc,
 output[31:0] instruction
);

reg [31:0] memory [63:0];
wire [5:0] rom_addr = pc[7:2];
initial
begin
	$readmemb("instructions.txt", memory);
end
assign instruction =  memory[rom_addr]; 

endmodule