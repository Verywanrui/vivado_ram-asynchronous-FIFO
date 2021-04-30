module	fifomem(
		input	wire			w_clk,
		input	wire			r_clk,
		input	wire			w_en,		//来自于FIFO的写控制模块
		//RAM不需要读使能就可以，给一个地址他就出数据
		input	wire			w_full,		//来自FIFO的写控制模块
		input	wire	[559:0]	w_data,		//来自于外部数据源
		input	wire	[4:0]	w_addr,		//来自于我们的FIFO写控制模块
		input	wire			r_empty,
		input	wire	[4:0]	r_addr,		//来自于FIFO的读控制模块
		input   wire			en_ram,		//
		output	wire	[559:0]	r_data		//读数据从内部ram中读取
		
);

wire	ram_w_en;
assign	ram_w_en = w_en&(~w_full);//这个控制信号都是根据FIFO的逻辑框图来看着写的

/*
dp_ram_512_8	dp_ram_512_8_inst (
	.wraddress ( w_addr[7:0] ),
	.wren ( ram_w_en ),	
	.wrclock ( w_clk ),
	.data ( w_data ),
	.rdclock ( r_clk ),
	.rdaddress ( r_addr[7:0] ),
	.q ( r_data )
	);
*/ 
blk_mem_gen_0 fifo_ram_inst (
  .clka(w_clk),    // input wire clka
  .wea(ram_w_en),      // input wire [0 : 0] wea
  .addra(w_addr[3:0]),  // input wire [3 : 0] addra
  .dina(w_data),    // input wire [559 : 0] dina
  .clkb(r_clk),    // input wire clkb
  .enb(en_ram),      // input wire enb
  .addrb(r_addr[3:0]),  // input wire [3 : 0] addrb
  .doutb(r_data)  // output wire [559 : 0] doutb
);


endmodule