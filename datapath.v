module datapath(
    input clk, 
    input alu_src, mem_reg, reg_write, mem_read, mem_write, branch,
    input [1:0] alu_op,
	 input [31:0] instruction_current,
	 input [63:0] pc_current,
    output [6:0] opcode,
	 output [63:0] pc_next,
	 output [63:0] test_data_1
);


//wire [63:0] pc_next;
wire [4:0] read_register_1;
wire [4:0] read_register_2;
wire [4:0] write_register;
wire [63:0] write_data;
wire [63:0] read_data_1;
wire [63:0] read_data_2;
wire [15:0] mem_access_addr;
wire [63:0] mem_write_data;
wire [63:0] mem_read_data;
reg signed [63:0] imm_ext;
wire [5:0] instruction_alu;
wire [3:0] alu_opcode;
wire [63:0] a;
wire [63:0] b;
wire [63:0] result;
//reg [63:0] pc_current;
//wire [31:0] instruction_current; // Add this line
wire [63:0] pc_2;
wire [63:0] pc_beq;
//instruction_memory im(.pc(pc_current), .instruction(instruction_current));
//initial begin
    //pc_current <= 64'd0;
//end

//always @(posedge clk) begin
    //pc_current <= pc_next;
//end


assign instruction_alu = {alu_op, instruction_current[30], instruction_current[14], instruction_current[13], instruction_current[12]};
assign write_register = mem_reg ? mem_read_data : instruction_current[11:7];
assign read_register_1 = instruction_current[19:15];
assign read_register_2 = instruction_current[24:20];

always @(posedge clk) begin
    if (mem_read)
        imm_ext = {{52{instruction_current[31]}}, instruction_current[31:20]};
    else if (mem_write)
        imm_ext = {{52{instruction_current[31]}}, instruction_current[31:25], instruction_current[11:7]};
    else if(branch)
        imm_ext = {{50{instruction_current[31]}}, instruction_current[31], instruction_current[7], instruction_current[30:25], instruction_current[11:8], 1'b0, 1'b0};

end

register_files rf(.clk(clk), .read_register_1(read_register_1),
                   .read_register_2(read_register_2), .write_register(write_register),
                   .write_data(write_data), .write_en(reg_write), .read_data_1(read_data_1), .read_data_2(read_data_2));

alu_control ac(.instruction_bits(instruction_alu), .alu_opcodes(alu_opcode));
assign a = (branch) ? pc_current : read_data_1;
assign b = alu_src ? read_data_2 : imm_ext;
alu ad(.a(a), .b(b), .alu_opcodes(alu_opcode), .result(result));


data_memory dm(.clk(clk), .mem_access_addr(result), .mem_write_data(read_data_2),
               .mem_write_en(mem_write), .mem_read(mem_read), .mem_read_data(mem_read_data));

assign write_data = alu_src ? result : mem_read_data;
assign opcode = instruction_current[6:0];
assign pc_beq = pc_current + imm_ext;
assign pc_next = (branch  && (read_data_1 != read_data_2)) ? pc_beq : (pc_current + 4);
assign test_data_1 = mem_read_data;
endmodule