module risc_v_project(input clk);
reg[3:0] test_instruction_bits;
wire[3:0] alu_opcodes;
reg[15:0] a;
reg[15:0] b;
wire[15:0] result;
reg [22:0] cnt;
alu_control alu_control_dut(.instruction_bits(test_instruction_bits), .alu_opcodes(alu_opcodes));
alu alu_dut(.a(a), .b(b), .alu_opcodes(alu_opcodes), .result(result));
initial
	begin
		 a = 2'b01; b = 2'b10; test_instruction_bits = 4'b0000;//add
		 cnt <= 32'h00000000;
	end
always @ (posedge clk) begin
cnt <= cnt + 1;
end
endmodule