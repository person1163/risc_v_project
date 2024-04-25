module register_files(
input clk,
input[4:0] read_register_1,//2^5 = 32 regs
input[4:0] read_register_2,
input[4:0] write_register,
input[63:0] write_data,//data should be width 64 bits
input write_en,
output[63:0] read_data_1,
output[63:0] read_data_2);
reg[63:0] reg_array[31:0];//array width 64 bits and length 32 
integer i;
 initial begin
  for(i=0;i<32;i=i+1)
   reg_array[i] <= 0;
 end
  always @ (posedge clk ) begin
   if(write_en) begin
    reg_array[write_register] <= write_data;
   end
 end
 
 assign read_data_1 = reg_array[read_register_1];
 assign read_data_2 = reg_array[read_register_2];


endmodule