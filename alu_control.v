module alu_control(
  input [3:0] instruction_bits,
  output reg [3:0] alu_opcodes
);
  //instruction_bits is i[30]:i[14]:i[13]:i[12]
  always @(*)
  begin
    case(instruction_bits)
      4'b0000:
        alu_opcodes = 4'b0010; // add
      
      4'b1000:
        alu_opcodes = 4'b0110; // subtract
      
      4'b0111:
        alu_opcodes = 4'b0000; // and
      
      4'b0110:
        alu_opcodes = 4'b0001; // or
    endcase
  end
endmodule