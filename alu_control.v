module alu_control(
  input [5:0] instruction_bits,
  output reg [3:0] alu_opcodes
);

  always @(*)
  begin
    if (instruction_bits[5:4] == 2'b00)
      alu_opcodes = 4'b0010; // add
    else if ((instruction_bits[5] == 1'b0 && instruction_bits[4] == 1'b1) || (instruction_bits[5] == 1'b1 && instruction_bits[3:0] == 4'b0000))
      alu_opcodes = 4'b0110; // subtract
    else if (instruction_bits[5] == 1'b1 && instruction_bits[4] == 1'b0)
      alu_opcodes = 4'b0010; // add
    else if (instruction_bits[5] == 1'b1 && instruction_bits[4] == 1'b0)
      alu_opcodes = 4'b0110; // subtract
    else if (instruction_bits == 6'b101110 || instruction_bits == 6'b101100)
      alu_opcodes = 4'b0000; // AND
    else if (instruction_bits == 6'b101110 || instruction_bits == 6'b101100)
      alu_opcodes = 4'b0001; // OR
    else
      alu_opcodes = 4'b0000; // Default value
  end
endmodule

