module control_unit(
    input [6:0] opcode,
    output reg [1:0] alu_op,
    output reg alu_src, mem_reg, reg_write, mem_read, mem_write, branch
);

always @(*)
begin
    // Default assignments
    alu_src = 1'b0;
    mem_reg = 1'b0;
    reg_write = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    branch = 1'b0;
    alu_op = 2'b00; // Default value

    case(opcode)
        7'b0110011: // R-type instructions
        begin
            reg_write = 1'b1;
            alu_op = 2'b10;
        end

        7'b0000011: // ld-type instructions
        begin
            alu_src = 1'b1;
            mem_reg = 1'b1;
            reg_write = 1'b1;
            mem_read = 1'b1;
            alu_op = 2'b00;
        end

        7'b0100011: // sd-type instructions
        begin
            alu_src = 1'b1;
            mem_write = 1'b1;
            alu_op = 2'b00;
        end

        7'b1100011: // br-type instructions
        begin
            branch = 1'b1;
            alu_op = 2'b01;
        end
        
        default: // Default case for any other opcode values
        begin
            // Optionally handle unexpected values here
        end
    endcase
end

endmodule
