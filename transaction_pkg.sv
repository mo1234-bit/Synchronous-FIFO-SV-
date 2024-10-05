package FIFO_transaction_pkg;
	class FIFO_transaction;
	parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic full, empty, almostfull, almostempty, underflow;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
 int RD_EN_ON_DIST = 30;
  int WR_EN_ON_DIST = 70;
  function new(int rd_dist = 30, int wr_dist = 70);
    this.RD_EN_ON_DIST = rd_dist;
    this.WR_EN_ON_DIST = wr_dist;
  endfunction

constraint rstn {
rst_n dist{0:=10,1:=90};}

constraint wr_en_c {
wr_en dist{0:=WR_EN_ON_DIST,1:=100-WR_EN_ON_DIST};}

constraint rd_en_c {
rd_en dist{0:=RD_EN_ON_DIST,1:=100-RD_EN_ON_DIST};}

 constraint wr { rst_n == 1;  wr_en == 1;  rd_en == 0; } 

constraint rd { rst_n == 1;  wr_en == 0;  rd_en == 1; } 

constraint rd_wr { rst_n == 1;  wr_en == 1;  rd_en == 1; } 

endclass
endpackage