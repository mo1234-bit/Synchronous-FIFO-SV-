interface FIFO_IF (clk);
input bit clk;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en,full, empty, almostfull, almostempty, underflow;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;

modport TEST (input clk,full, empty, almostfull, almostempty, underflow, data_out, wr_ack, overflow,
output data_in,rst_n,wr_en,rd_en);

modport DUT (input clk, data_in, rst_n, wr_en, rd_en,
	output full, empty, almostfull, almostempty, underflow, data_out, wr_ack, overflow);

modport MON (input data_in,clk, rst_n, wr_en, rd_en, full, empty, almostfull, almostempty, underflow, data_out, wr_ack, overflow);	

endinterface : FIFO_IF