module test_bench_cu();
reg[6:0] test_opcode;
reg alu_src, mem_reg, reg_write, mem_read, mem_write, branch;
reg[1:0] alu_op;
control_unit cu_dut(.opcode(test_opcode), .alu_src(alu_src), .mem_reg(mem_reg),
.reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch), .alu_op(alu_op));
endmodule

module test_bench_alu();
reg[3:0] test_instruction_bits;
wire[3:0] alu_opcodes;
reg[15:0] a;
reg[15:0] b;
wire[15:0] result;
alu_control alu_control_dut(.instruction_bits(test_instruction_bits), .alu_opcodes(alu_opcodes));
alu alu_dut(.a(a), .b(b), .alu_opcodes(alu_opcodes), .result(result));
initial
	begin
			a  = 2'b01;b = 2'b10; test_instruction_bits = 4'b0000;//add
	#20	test_instruction_bits = 4'b1000;//sub
	#20	test_instruction_bits = 4'b0111;//and
	#20	test_instruction_bits = 4'b0110;//or
	#40
	$stop;
	$finish;
	end
endmodule