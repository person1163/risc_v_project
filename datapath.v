module datapath(
    input clk, 
    input alu_src, mem_reg, reg_write, mem_read, mem_write, branch,
    input [1:0] alu_op,
	 input [31:0] instruction_current,
	 input [63:0] pc_current,
    output [6:0] opcode,
	 output reg [63:0] pc_next,
	 output [63:0] test_data_1,
	 output [63:0] reg1,
	 output [63:0] reg2,
	 output [63:0] write_reg,
	 output [63:0] extension
);


//wire [63:0] pc_next;
wire [2:0] funct3;
wire [6:0] funct7;
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
//wire [5:0] instruction_alu;
wire [3:0] alu_opcode;
wire [63:0] a;
wire [63:0] b;
wire [63:0] result;
//reg [63:0] pc_current;
//wire [31:0] instruction_current; // Add this line
reg signed [63:0] ldstr;
wire [63:0] pc_beq;
//instruction_memory im(.pc(pc_current), .instruction(instruction_current));
//initial begin
    //pc_current <= 64'd0;
//end

//always @(posedge clk) begin
    //pc_current <= pc_next;
//end
assign funct3 = instruction_current[14:12];
assign funct7 = instruction_current[31:25];
assign alu_opcode = alu_op[1] ? {funct3, funct7[5]} : 4'b0000;
assign write_register = instruction_current[11:7];
assign read_register_1 = instruction_current[19:15];
assign read_register_2 = instruction_current[24:20];

always @(*) begin
    if (mem_write)
        imm_ext = {{52{instruction_current[31]}}, instruction_current[31:25], instruction_current[11:7]};
    else if(branch)
        imm_ext = {{50{instruction_current[31]}}, instruction_current[31], instruction_current[7], instruction_current[30:25], instruction_current[11:8], 1'b0, 1'b0};
	 else
		  imm_ext = {{52{instruction_current[31]}}, instruction_current[31:20]};
		
end


register_files rf(.clk(clk), .read_register_1(read_register_1),
                   .read_register_2(read_register_2), .write_register(write_register),
                   .write_data(write_data), .write_en(reg_write), .read_data_1(read_data_1), .read_data_2(read_data_2));

//alu_control ac(.instruction_bits(instruction_alu), .alu_opcodes(alu_opcode));
assign a = read_data_1;
assign b = alu_src ? imm_ext : read_data_2; 


        


alu ad(.a(a), .b(b), .alu_opcodes(alu_opcode), .result(result));


data_memory dm(.clk(clk), .mem_access_addr(result), .mem_write_data(read_data_2),
               .mem_write_en(mem_write), .mem_read(mem_read), .mem_read_data(mem_read_data));

always @(*) begin//for different size loads and stores
    if ((mem_write || mem_read) && (funct3 == 3'b000))
        ldstr <= {{56{mem_read_data[7]}}, mem_read_data[7:0]};
    else if ((mem_write || mem_read) && (funct3 == 3'b001))
        ldstr <= {{48{mem_read_data[15]}}, mem_read_data[15:0]};
    else if ((mem_write || mem_read) && (funct3 == 3'b010))
        ldstr <= {{32{mem_read_data[31]}}, mem_read_data[31:0]};
    else if ((mem_write || mem_read) && (funct3 == 3'b011))
        ldstr <= mem_read_data[63:0];
    else if ((mem_read) && (funct3 == 3'b100))
        ldstr <= {{56'b0}, mem_read_data[7:0]};
    else if ((mem_read) && (funct3 == 3'b101))
        ldstr <= {{48'b0}, mem_read_data[15:0]};
end
		
assign write_data = mem_read ? ldstr : result;


		
assign opcode = instruction_current[6:0];

always @(*) begin // For different types of branches
    if ((branch) && (read_data_1 == read_data_2) && (funct3 == 3'b000))
        pc_next = pc_current + imm_ext;
    else if ((branch) && (read_data_1 != read_data_2) && (funct3 == 3'b001))
        pc_next = pc_current + imm_ext;
    else if ((branch) && (read_data_1 < read_data_2) && (funct3 == 3'b010))
        pc_next = pc_current + imm_ext;
    else if ((branch) && (read_data_1 >= read_data_2) && (funct3 == 3'b011))
        pc_next = pc_current + imm_ext;
	 else
		  pc_next = pc_current + 4;
end

//assign pc_beq = pc_current + imm_ext; //imm_ext calc(not using alu in this case)
//assign pc_next = (branch) ? pc_beq : (pc_current + 4);
assign test_data_1 = write_data;
assign reg1 = read_register_1;
assign reg2 = read_data_2;
assign write_reg = write_register;
assign extension = imm_ext;
endmodule