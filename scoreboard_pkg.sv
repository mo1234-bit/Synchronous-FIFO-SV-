package FIFO_scoreboard_pkg ;
	import shared_pkg::*;
	import FIFO_transaction_pkg::*;
	class FIFO_scoreboard  ;
		parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        bit [FIFO_WIDTH-1:0]data_out_ref;
        bit wr_ack_ref,overflow_ref,underflow_ref,full_ref,almostfull_ref,empty_ref,almostempty_ref;
        int count;
        bit [FIFO_WIDTH-1:0]FIFO[$];
        FIFO_transaction a=new();
        function void referance_model(input FIFO_transaction b);

       fork begin
       
       	if(!b.rst_n)begin
       		FIFO.delete();
       		wr_ack_ref=0;
       		full_ref=0;
       		almostfull_ref=0;
       		almostempty_ref=0;
       	
       	end
       	else if(b.wr_en && count < FIFO_DEPTH)begin
       	wr_ack_ref=1;
        FIFO.push_back(b.data_in);	
       	end
       	else begin 
		wr_ack_ref= 0; 
		if (full_ref && b.wr_en)
			overflow_ref = 1;
		else
			overflow_ref = 0;
	end
      	 end
       	 begin
       		if (!b.rst_n) begin
       	empty_ref=1;
		data_out_ref=0;
		underflow_ref = 0;
		almostempty_ref=0;
	end
	else if (b.rd_en && count != 0) begin
		data_out_ref = FIFO.pop_front();
			end
	else begin  
		if (empty_ref && b.rd_en)
			underflow_ref = 1;
		else
			underflow_ref = 0;
	end
end
       
      join
        	if (!b.rst_n) begin
		count = 0;
	end
	else begin
		if	( ({b.wr_en, b.rd_en} == 2'b10) && !full_ref) 
			count = count + 1;
		else if ( ({b.wr_en, b.rd_en} == 2'b01) && !empty_ref)
			count = count - 1;
		else if( ({b.wr_en, b.rd_en} == 2'b11) && empty_ref)
			count = count + 1;
		else if( ({b.wr_en, b.rd_en} == 2'b11) && full_ref)
			count = count - 1;
	end
	full_ref = (count == FIFO_DEPTH)? 1 : 0;
empty_ref = (count == 0)? 1 : 0;
almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
almostempty_ref = (count == 1)? 1 : 0;
        endfunction

function void check_data(input FIFO_transaction c);
 referance_model(c);
 if(!c.rst_n)begin
 	if(c.data_out!=0||c.wr_ack!=0||c.overflow!=0||c.underflow!=0)
 		begin
 			$display("ERROR at time=%0t the rst_n is broken data out =%0d ,wr_ack=%0d ,overflow=%0d,underflow=%0d",$time,c.data_out, c.wr_ack,c.overflow,c.underflow);
 		errors_count=errors_count+1;
 		end
 end
 if(c.data_out!=data_out_ref)
 	begin
 		$display("ERROR at time=%0t the data_out or data_out_ref is not matched data_out=%0p and data_out_ref=%0p",$time,c.data_out, data_out_ref);
 		errors_count=errors_count+1;
 	end
   else
   	$display(" at time=%0t the FIFO=%p",$time,FIFO);
   	correct_count=correct_count+1;
   
 endfunction 
	endclass 
	
endpackage 