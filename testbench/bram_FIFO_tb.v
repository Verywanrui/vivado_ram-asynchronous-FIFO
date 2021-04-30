`timescale 1ns / 1ps
`define inner_clk_period 10
`define outer_clk_period 30

module	tb_ex_fifo;
    reg		r_clk,w_clk,rst_n;
    reg		w_en;
    reg	[559:0]	w_data;
    reg		r_en;
    wire [559:0]	r_data;
    wire	w_full;
    wire	r_empty;

    reg [560-1:0] data_in_mem [0:15];

    //写的初始化模块
    initial	begin
                r_clk <= 0;
                w_clk <= 0;
                rst_n <= 0;
                w_en  <= 0;
                r_en  <= 0;
                #200
                rst_n <= 1;
    end
    always #(`outer_clk_period/2)  w_clk <= ~w_clk;
    always #(`inner_clk_period/2)  r_clk <= ~r_clk;

    integer i;
    initial begin
        #(`outer_clk_period*13);
        #33;
        $readmemb("E:/WORK/Vivado/bram_FIFO/bram_FIFO.srcs/sim_1/matlabfiles/data.txt", data_in_mem);
        w_en  <= 1;
        for (i = 0; i < 16; i = i+1) begin
            w_data <= data_in_mem[i];
            #(`outer_clk_period);
        end
        w_en  <= 0;

        #(`outer_clk_period*13);
        r_en <= 1;

        #1000 $stop;


    end

    integer fid1, fid2;
    initial begin
        fid1 = $fopen("E:/WORK/Vivado/bram_FIFO/bram_FIFO.srcs/sim_1/matlabfiles/w_data.txt");
        fid2 = $fopen("E:/WORK/Vivado/bram_FIFO/bram_FIFO.srcs/sim_1/matlabfiles/r_data.txt");
    end
    always @(w_data) begin
        $fdisplay(fid1, "%h", w_data);
    end

    always @(r_data) begin
        if (r_data != 'b0) 
            $fdisplay(fid2, "%h", r_data);
    end


    ex_fifo ex_fifo_inst(
        .w_clk(w_clk),
        .r_clk(r_clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .w_data(w_data),
        .w_full(w_full),
        .r_en(r_en),
        .r_data(r_data),
        .r_empty(r_empty)
    );

endmodule
