//这个是用来描述写的控制信号
module	w_ctrl(
		input	wire		w_clk,//写时钟
		input	wire		rst_n, //复位
		input	wire		w_en,	//写使能
		input	wire [4:0]	r_gaddr,//读时钟域过来的格雷码读地址指针
		output	reg			w_full, //写满标志
		output	wire [4:0]	w_addr, //假设这次是16深度的FIFO, 因为要判断满空，所以最高位加一位
		output	wire [4:0]	w_gaddr //写FIFO地址格雷码编码
);
reg		[4:0]	addr;		//从格雷码计算器的图可以看出来最终输出的都是经过寄存器的数据
reg		[4:0]	gaddr;		//从格雷码计算器的图可以看出来最终输出的都是经过寄存器的数据
wire	[4:0]	addr_wire;
wire	[4:0]	gaddr_wire;
reg		[4:0]	r_gaddr_d1,r_gaddr_d2;

//这是将输入的格雷码打两拍，避免亚稳态
always @(posedge w_clk or negedge rst_n)
			if(rst_n == 1'b0)
				{r_gaddr_d2,r_gaddr_d1} <= 10'd0;
			else
				{r_gaddr_d2,r_gaddr_d1} <= {r_gaddr_d1,r_gaddr};


//产生写RAM的地址指针 二进制
assign	addr_wire = addr + ((~w_full)&w_en);

always @(posedge w_clk or negedge rst_n)
			if(rst_n == 1'b0)
				addr <= 5'd0;
			else
				addr <= addr_wire;


assign	w_addr = addr;

//转换格雷码地址
assign	gaddr_wire = (addr_wire>>1)^addr_wire;//^这个符号的意思就是异或
always @(posedge w_clk or negedge rst_n)
		if(rst_n == 1'b0)
				gaddr <= 5'd0;
		else
				gaddr <= gaddr_wire;

assign	w_gaddr = gaddr;
//产生写满标志
always @(posedge w_clk or	negedge	rst_n)
		if(rst_n == 1'b0)
			w_full <= 1'b0;
		//else if({~gaddr_wire[8],gaddr_wire[7:0]} == r_gaddr_d2) //输入比较的话应该拿输入与wire类型的数据进行比较,二进制比较这样就可以
		else if({~gaddr_wire[4:3],gaddr_wire[2:0]} == r_gaddr_d2)
		//格雷码比较是需要把高位和次高位都取反
			w_full<=1'b1;
		else
			w_full<=1'b0;

endmodule
