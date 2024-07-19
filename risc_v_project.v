module risc_v_project(input clk);
reg[63:0] pc;
wire[63:0] pc_next;
//wire[63:0] pc_2;
wire[31:0] instruction;
reg [22:0] cnt;
wire alu_src, mem_reg, reg_write, mem_read, mem_write, branch;
wire [1:0] alu_op;
wire [6:0] opcode;
wire [63:0] test_data;
wire [63:0] reg1;
wire [63:0] reg2;
wire [63:0] write_reg;
wire [63:0] extension;

instruction_memory instruction_memory_dut(.pc(pc), .instruction(instruction));
initial
	begin
		 cnt <= 23'b0; pc <= 64'b0;
	end
always @ (posedge clk) begin
cnt <= cnt + 1;
pc <= pc_next;
end
//assign pc_next = pc + 4;

datapath dp_dut(.clk(clk), .alu_src(alu_src), .mem_reg(mem_reg), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch),
.alu_op(alu_op), .instruction_current(instruction), .pc_current(pc), .opcode(opcode), .pc_next(pc_next), .test_data_1(test_data), .reg1(reg1), .reg2(reg2),
.write_reg(write_reg), .extension(extension));

control_unit cu(.opcode(opcode), .alu_op(alu_op), .alu_src(alu_src), .mem_reg(mem_reg), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write), .branch(branch));
endmodule
