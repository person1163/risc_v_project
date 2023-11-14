module alu(
  input [15:0] a,
  input [15:0] b,
  input [3:0] alu_opcodes,
  output reg [15:0] result
);

always @(*)
begin
  case (alu_opcodes)
    4'b0000: result = a & b;
    4'b0001: result = a | b;
    4'b0010: result = a + b;
    4'b0110: result = a - b;
    default: result = 16'b0; // Handle undefined cases
  endcase
end

endmodule