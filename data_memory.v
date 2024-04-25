module data_memory(
input clk,
 // address input, shared by read and write port
input [15:0]   mem_access_addr,
 
 // write port
input [63:0] mem_write_data,
input mem_write_en,
input mem_read,
 // read port
output [63:0] mem_read_data
);

reg[63:0] memory [7:0];
wire[2:0] ram_addr = mem_access_addr[2:0];
initial
 begin
  $readmemb("data_memory.txt", memory);
 end
always @(posedge clk) begin
  if (mem_write_en)
   memory[ram_addr] <= mem_write_data;
end
//assign mem_read_data = (mem_read==1'b1) ? memory[ram_addr]: 64'd0; 
assign mem_read_data = memory[ram_addr];
endmodule