package FIFO_coverage_pkg ;
	import FIFO_transaction_pkg::*;
	class FIFO_coverage ;
		FIFO_transaction F_cvg_txn=new();

		covergroup group;
			rd:coverpoint F_cvg_txn.rd_en;

			wr:coverpoint F_cvg_txn.wr_en;

			wrack:coverpoint F_cvg_txn.wr_ack;

			full_cover:coverpoint F_cvg_txn.full;

			empty_cover:coverpoint F_cvg_txn.empty;

			almostfull_cover:coverpoint F_cvg_txn.almostfull;

			almostempty_cover:coverpoint F_cvg_txn.almostempty;

			overflow_cover:coverpoint F_cvg_txn.overflow;

			underflow_cover:coverpoint F_cvg_txn.underflow;


wr_ack_crross : cross wr, rd, wrack {
    //option.cross_auto_bin_max=0;
    ignore_bins a = binsof(wr) intersect {0} && binsof(wrack) intersect {1};
    ignore_bins b = binsof(wr) intersect {0} && binsof(rd) intersect {1} && binsof(wrack) intersect {1};
}


full_cross : cross wr, rd, full_cover {
    //option.cross_auto_bin_max=0;
    ignore_bins a = binsof(wr) intersect {0} && binsof(full_cover) intersect {1};
    ignore_bins b = binsof(rd) intersect {1} && binsof(full_cover) intersect {1};
}


empty_cross : cross wr, rd, empty_cover ;


overflow_cross : cross wr, rd, overflow_cover {
//option.cross_auto_bin_max=0;
    ignore_bins a = binsof(wr) intersect {0} && binsof(overflow_cover) intersect {1};
    
}


underflow_cross : cross wr, rd, underflow_cover {
//option.cross_auto_bin_max=0;
   ignore_bins a = binsof(rd) intersect {0} && binsof(underflow_cover) intersect {1};
}


almostfull_cross : cross wr, rd, almostfull_cover{
//option.cross_auto_bin_max=0;
   ignore_bins a = binsof(wr) intersect {0} && binsof(almostfull_cover) intersect {1};
   
}


almostempty_cross : cross wr, rd, almostempty_cover;

endgroup 

	function  new();
			group=new;
		endfunction

		function void sample_data(input FIFO_transaction F_txn);
			 F_cvg_txn=F_txn;
			 group.sample();
				
			endfunction
	endclass 
endpackage