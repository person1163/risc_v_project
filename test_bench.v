
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

module test_bench_instructions(input clk);
reg[63:0] pc;
wire[31:0] instruction;
reg [22:0] cnt;
instruction_memory instruction_memory_dut(.pc(pc), .instruction(instruction));
initial
	begin
		 cnt <= 5'b0; pc <= 64'b0;
	end
always @ (posedge clk) begin
cnt <= cnt + 1;
pc <= pc + 1;
end
endmodule

module test_bench_reg(input clk);
reg[4:0] rr1, rr2, wr;
reg[63:0] write_data;
reg write_enable;
wire[63:0] rd1, rd2;
reg [22:0] cnt;
register_files rf_dut(.clk(clk), .read_register_1(rr1), .read_register_2(rr2), .write_register(wr), .write_data(write_data), .write_en(write_enable), .read_data_1(rd1), .read_data_2(rd2));
initial
	begin
		 rr1 = 5'd10; rr2 = 5'd20; wr = 5'd20; write_data = 64'd15; write_enable = 1'b1;
		 cnt <= 32'h00000000;
	end
always @ (posedge clk) begin
cnt <= cnt + 1;
end
endmodule

module risc_v_project_test(input clk);
wire alu_src, mem_reg, reg_write, mem_read, mem_write, branch;
wire[1:0] alu_op;
wire[6:0] opcode;
wire[63:0] test_data;
wire[31:0] test_data_2;
datapath d(.clk(clk),
.alu_src(alu_src), .mem_reg(mem_reg), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch),
.alu_op(alu_op), .opcode(opcode), .test_data(test_data), .test_data_2(test_data_2));

control_unit c(.opcode(opcode), .alu_op(alu_op), 
.alu_src(alu_src), .mem_reg(mem_reg), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch));

endmodule



module clk_test(input clk, output[9:0] LED);

reg [22:0] cnt;

initial begin
cnt <= 32'h00000000;
end

always @ (posedge clk) begin
cnt <= cnt + 1;
end

assign LED[0] = cnt[22];
assign LED[9:1] = 9'b00000000;

endmodule