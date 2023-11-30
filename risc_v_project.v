module risc_v_project(input clk);
reg[4:0] rr1, rr2, wr;
reg[63:0] write_data;
reg write_enable;
wire[63:0] rd1, rd2;
reg [22:0] cnt;
register_files rf_dut(.clk(clk), .read_register_1(rr1), .read_register_2(rr2), .write_register(wr), .write_data(write_data), .write_en(write_enable), .read_data_1(rd1), .read_data_2(rd2));
initial
	begin
		 rr1 = 5'd10; rr2 = 5'd20; wr = 5'd20; write_data = 64'd15; write_enable = 1'b1;
		 cnt <= 32'h00000000;
	end
always @ (posedge clk) begin
cnt <= cnt + 1;
end
endmodule