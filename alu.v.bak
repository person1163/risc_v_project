module alu(
input[15:0] a, b,
input[3:0] alu_opcodes,
output reg[15:0] result);

always @(*)
begin
case(alu_opcodes)
	4b'0000: result = a & b;
	4b'0001: result = a | b;
	4b'0010: result = a + b;
	4b'0110: result = a - b;
end
	
