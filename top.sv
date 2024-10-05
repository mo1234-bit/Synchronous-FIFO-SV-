module top();
	bit clk;

	initial begin
		clk=0;
		forever
		#30 clk=~clk;
	end

	FIFO_IF fifoif(clk);

	FIFO DUT (fifoif);

	TB tb(fifoif);

	MONITOR mon(fifoif);

endmodule