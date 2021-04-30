module	r_ctrl(
		input	wire			r_clk,	//读时钟
		input	wire			rst_n,	
		input	wire			r_en,	//读使能
		input	wire	[4:0]	w_gaddr,//写时钟域的写地址指针
		output	reg				r_empty,//读空标志
		output	wire	[4:0]	r_addr,//读时钟域的地址
		output	wire	[4:0]	r_gaddr,  //读格雷码的地址
		output	reg				en_ram

);


reg		[4:0]	addr;
reg		[4:0]	gaddr;
wire	[4:0]	addr_wire;
wire	[4:0]	gaddr_wire;
reg		[4:0]	w_gaddr_d1,w_gaddr_d2;
reg 			r_en_reg;

always	@(posedge r_clk or negedge	rst_n)
			if(rst_n == 1'b0)
				{w_gaddr_d2,w_gaddr_d1} <= 10'd0;
			else
				{w_gaddr_d2,w_gaddr_d1} <= {w_gaddr_d1,w_gaddr};

always @(posedge r_clk or negedge	rst_n) begin
	if (!rst_n) 	r_en_reg <= 'b0;
	else 			r_en_reg <= r_en;
end

always @(posedge r_clk or negedge	rst_n) begin
	if (!rst_n) 	en_ram <= 'b0;
	else begin
		if (r_en & (addr < 'd15)) 	en_ram <= 'b1;
		else 		en_ram <= 'b0;
	end
end


//读二进制的地址
assign r_addr = addr;
assign	addr_wire = addr + ((~r_empty)&(r_en_reg));
always	@(posedge r_clk or negedge rst_n)
			if(rst_n == 1'b0)
				addr <= 5'd0;
			else
				addr <= addr_wire;

//读格雷码的地址				
assign	r_gaddr = gaddr;

assign	gaddr_wire = (addr_wire>>1)^addr_wire;

always @(posedge r_clk or negedge rst_n)
			if(rst_n == 1'b0)
					gaddr <= 5'd0;
			else
					gaddr <= gaddr_wire;
//读空标志的产生
always	@(posedge r_clk or negedge	rst_n)
			if(rst_n == 1'b0)
					r_empty <= 1'b0;
			else if(gaddr_wire == w_gaddr_d2)
					r_empty <= 1'b1;
			else
					r_empty <=1'b0;
endmodule
