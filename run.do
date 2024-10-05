vlib work
vlog FIFO.sv package1.sv pac2.sv pac3.sv pac4.sv TB.sv mointor.sv interface.sv top.sv +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave *
add wave -position insertpoint  \
sim:/top/fifoif/FIFO_WIDTH \
sim:/top/fifoif/FIFO_DEPTH \
sim:/top/fifoif/clk \
sim:/top/fifoif/data_in \
sim:/top/fifoif/rst_n \
sim:/top/fifoif/wr_en \
sim:/top/fifoif/rd_en \
sim:/top/fifoif/full \
sim:/top/fifoif/empty \
sim:/top/fifoif/almostfull \
sim:/top/fifoif/almostempty \
sim:/top/fifoif/underflow \
sim:/top/fifoif/data_out \
sim:/top/fifoif/wr_ack \
sim:/top/fifoif/overflow
add wave -position insertpoint  \
sim:/top/DUT/count
coverage save FIFO_tb.ucdb -onexit
run -all


