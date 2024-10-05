import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
module MONITOR(FIFO_IF.MON fifo_if);
FIFO_transaction a;
FIFO_coverage b;
FIFO_scoreboard c;
initial begin
	a=new();
	b=new();
    c=new();
    forever begin
     @(negedge fifo_if.clk);
     a.rst_n=fifo_if.rst_n;
     a.data_in=fifo_if.data_in;
     a.wr_en=fifo_if.wr_en;
     a.rd_en=fifo_if.rd_en;
     a.data_out=fifo_if.data_out;
     a.full=fifo_if.full;
     a.empty=fifo_if.empty;
     a.almostfull=fifo_if.almostfull;
     a.almostempty=fifo_if.almostempty;
     a.underflow=fifo_if.underflow;
     a.overflow=fifo_if.overflow;
     a.wr_ack=fifo_if.wr_ack;

     fork begin
     	b.sample_data(a);
     end
     begin
     	@(posedge fifo_if.clk);
     	#15
     	c.check_data(a);
     end
 join
 if(test_finished==1)begin
 	$display("num of correct counts=%0d, num of error counts=%0d",correct_count, errors_count);
 	$stop;
 end
end
end
endmodule

