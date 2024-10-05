////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_IF.DUT fifoif);

localparam max_fifo_addr = $clog2(fifoif.FIFO_DEPTH);

reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;
		fifoif.wr_ack <= 0;
		fifoif.overflow <= 0;
	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full && fifoif.wr_en)
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
		fifoif.data_out<=0;
		fifoif.underflow <= 0;
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin  
		if (fifoif.empty && fifoif.rd_en)
			fifoif.underflow <= 1;
		else
			fifoif.underflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
			count <= count - 1;
		else if( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty)
			count <= count + 1;
		else if( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full)
			count <= count - 1;
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; 
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0; 
assign fifoif.almostempty = (count == 1)? 1 : 0;

// Assertions

property num1;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en&&count < fifoif.FIFO_DEPTH)|=>fifoif.wr_ack;
	//@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en&&!fifoif.full)|=>fifoif.wr_ack;
endproperty

	Write_Acknowledge_a:assert property(num1);
    Write_Acknowledge_ac:cover property (num1);

property num2;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.rd_en&&fifoif.empty)|=>fifoif.underflow;
endproperty

	underflow_assert:assert property(num2);
    underflow_cover:cover property (num2);

property num3;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.wr_en&&fifoif.full)|=>fifoif.overflow;
endproperty

	overflow_assert:assert property(num3);
    overflow_cover:cover property (num3);

property num4;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (!fifoif.rd_en&&fifoif.wr_en&&!fifoif.full)|=>count==$past(count)+4'b0001;
endproperty

	count_in_assert:assert property(num4);
    count_in_cover:cover property (num4); 

 property num5;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (fifoif.rd_en&&!fifoif.wr_en&&!fifoif.empty)|=>count==$past(count)-4'b0001;
endproperty

	count_de_assert:assert property(num5);
    conut_de_cover:cover property (num5); 

property num6;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (count == 0)|->fifoif.empty;
endproperty

	empty_assert:assert property(num6);
    empty_cover:cover property (num6);

   property num7;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (count == 1)|->fifoif.almostempty;
endproperty

	almostempty_assert:assert property(num7);
    almostempty_cover:cover property (num7);

 property num8;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (count == fifoif.FIFO_DEPTH-1)|->fifoif.almostfull;
endproperty


	almostfull_assert:assert property(num8);
    almostfull_cover:cover property (num8);


property num9;
	@(posedge fifoif.clk) disable iff (!fifoif.rst_n) (count == fifoif.FIFO_DEPTH)|->fifoif.full;
endproperty


	full_assert:assert property(num9);
    full_cover:cover property (num9);
// always_comb begin
// if(count == fifoif.FIFO_DEPTH&&fifoif.rst_n)

// assert_full: assert(fifoif.full==1)

// if(count == 0&&fifoif.rst_n)

// assert_empty: assert(fifoif.empty==1)

// if(count == fifoif.FIFO_DEPTH-1&&fifoif.rst_n)

// assert_almostfull:assert(fifoif.almostfull==1)

// if(count == 1&&fifoif.rst_n)

// assert_almostempty:assert(fifoif.almostempty==1)

//end

endmodule
