import shared_pkg::*;
import FIFO_transaction_pkg::*;

module TB(FIFO_IF.TEST fifo_tb);

FIFO_transaction a=new();

initial begin
	fifo_tb.rst_n=0;
     fifo_tb.rd_en = 1; 
     fifo_tb.wr_en = 1 ; 
    fifo_tb.data_in = 10 ; 
	repeat(2)@(negedge fifo_tb.clk);
	fifo_tb.rst_n=1;
 	a.constraint_mode(0); 
a.wr.constraint_mode(1); 
repeat(100) begin 
    assert(a.randomize()); 
    fifo_tb.rst_n = a.rst_n ; 
     fifo_tb.rd_en = a.rd_en ; 
     fifo_tb.wr_en = a.wr_en ; 
    fifo_tb.data_in = a.data_in ; 
    @(negedge fifo_tb.clk); 
end 
 a.constraint_mode(0); 
 a.rd.constraint_mode(1); 
repeat(100) begin 
   assert(a.randomize()); 
    fifo_tb.rst_n = a.rst_n ; 
     fifo_tb.rd_en = a.rd_en ; 
     fifo_tb.wr_en = a.wr_en ; 
    fifo_tb.data_in = a.data_in ; 
    @(negedge fifo_tb.clk); 
end 

 a.constraint_mode(1);  
 a.rd.constraint_mode(0); 
 a.wr.constraint_mode(0); 
 a.rd_wr.constraint_mode(0);
repeat(10000) begin 
    assert(a.randomize()); 
    fifo_tb.rst_n = a.rst_n ; 
    fifo_tb.rd_en = a.rd_en ; 
    fifo_tb.wr_en = a.wr_en ; 
    fifo_tb.data_in = a.data_in ; 
    @(negedge fifo_tb.clk); 
end
a.constraint_mode(0); 
a.wr.constraint_mode(1);
repeat(100) begin 
    assert(a.randomize()); 
    fifo_tb.rst_n = a.rst_n ; 
     fifo_tb.rd_en = a.rd_en ; 
     fifo_tb.wr_en = a.wr_en ; 
    fifo_tb.data_in = a.data_in ; 
    @(negedge fifo_tb.clk); 
end 
a.constraint_mode(0); 
a.rd_wr.constraint_mode(1);
repeat(100) begin 
   assert(a.randomize()); 
    fifo_tb.rst_n = a.rst_n ; 
     fifo_tb.rd_en = a.rd_en ; 
     fifo_tb.wr_en = a.wr_en ; 
    fifo_tb.data_in = a.data_in ; 
    @(negedge fifo_tb.clk); 
end 
test_finished=1;
end
endmodule

