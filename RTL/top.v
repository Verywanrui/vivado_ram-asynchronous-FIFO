module ex_fifo(
		input	wire		w_clk,
		input	wire		r_clk,
		input	wire		rst_n,
		input	wire		w_en,
		input	wire	[559:0] w_data,
		output	wire		w_full,
		input	wire		r_en,
		output	wire	[559:0] r_data,
		output	wire		r_empty


);

wire	[4:0]	r_gaddr;
wire	[4:0]	w_addr;
wire	[4:0]	w_gaddr;
wire	[4:0]	r_addr;

w_ctrl	w_ctrl_inst(
		.w_clk(w_clk),//写时钟
		.rst_n(rst_n), //复位
		.w_en(w_en),	//写使能
		.r_gaddr(r_gaddr),//读时钟域过来的格雷码读地址指针
		.w_full(w_full), //写满标志
		.w_addr(w_addr), //假设这次是256深度的FIFO
		.w_gaddr(w_gaddr) //写FIFO地址格雷码编码
);

fifomem		fifomem_inst(
		.w_clk(w_clk),
		.r_clk(r_clk),
		.w_en(w_en),		//来自于FIFO的写控制模块

		.w_full(w_full),		//来自FIFO的写控制模块
		.w_data(w_data),		//来自于外部数据源
		.w_addr(w_addr),		//来自于我们的FIFO写控制模块
		.r_empty(r_empty),
		.r_addr(r_addr),		//来自于FIFO的读控制模块
		.en_ram(en_ram),
		.r_data(r_data)		//读数据从内部ram中读取
		
);


r_ctrl	r_ctrl_inst(
		.r_clk(r_clk),	//读时钟
		.rst_n(rst_n),	
		.r_en(r_en),	//读使能
		.w_gaddr(w_gaddr),//写时钟域的写地址指针
		.r_empty(r_empty),//读空标志
		.r_addr(r_addr),//读时钟域的地址
		.r_gaddr(r_gaddr),  //读格雷码的地址
		.en_ram(en_ram)
);

endmodule
