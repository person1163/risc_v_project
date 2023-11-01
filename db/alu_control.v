module alu_control(
input[3:0] instruction_bits,
output reg[3:0] alu_opcodes);
//instruction_bits is i[30]:i[14]:i[13]:i[12]
always @(*)
begin
case(instruction_bits)
	4b'0000:
	begin
		alu_opcodes = 4b'0010; //add
	end
	4b'1000:
	begin
		alu_opcodes = 4b'0110; //subtract
	end
	4b'0111:
	begin
		alu_opcodes = 4b'0000; //and
	end
	4b'0110:
	begin
		alu_opcodes = 4b'0001; //or
	end
end

	
